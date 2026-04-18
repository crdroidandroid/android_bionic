/*
 * Copyright (C) 2025-2026 AxionOS
 * Copyright (C) 2026 VoltageOS
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "custom_rom_hide.h"

#include <errno.h>
#include <fcntl.h>
#include <linux/memfd.h>
#include <linux/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/sysmacros.h>
#include <unistd.h>
#include <private/android_filesystem_config.h>

struct PrefixEntry {
    const char* str;
    size_t len;
};
#define PE(s) { s, sizeof(s) - 1 }

static const char* const kBlockedDirnames[] = {
    "addon.d", "init.d", "TWRP", nullptr
};

static const char* const kDirParents[] = {
    "/system", "/system/etc",
    "/system_ext", "/system_ext/etc",
    "/product", "/product/etc",
    "/vendor", "/vendor/etc",
    "/sdcard", "/data/media/0",
    nullptr
};

static const char* const kBlockedExactPaths[] = {
    "/system/bin/install-recovery.sh",
    "/sbin/recovery",
    "/tmp/recovery.log",
    nullptr
};

static const PrefixEntry kRecoveryPrefixes[] = {
    PE("/cache/recovery/"),
    {nullptr, 0}
};

static const char* const kProcFilterKeywords[] = {
    "lineage", "Lineage", "crdroid", "crDroid", "omnirom",
    "aospa",
    nullptr
};

static const char* const kMountFilterKeywords[] = {
    "/debug_ramdisk", "overlay", "magisk", "ksu", "KSU", "ksud", "apatch", "/data/adb", nullptr
};

#define DM_MAJOR 253u

struct PartitionDevEntry {
    const char* path;
    unsigned int dm_minor;
};

static const PartitionDevEntry kPartitionDmMap[] = {
    { "/system",     0 },
    { "/vendor",     1 },
    { "/product",    2 },
    { "/system_ext", 3 },
    { "/odm",        4 },
    { nullptr,       0 },
};

static inline int raw_openat(const char* path, int flags) {
    return static_cast<int>(syscall(__NR_openat, AT_FDCWD, path, flags, 0));
}

static inline ssize_t raw_read(int fd, void* buf, size_t count) {
    return syscall(__NR_read, fd, buf, count);
}

static inline ssize_t raw_write(int fd, const void* buf, size_t count) {
    return syscall(__NR_write, fd, buf, count);
}

static inline int raw_close(int fd) {
    return static_cast<int>(syscall(__NR_close, fd));
}

static inline off_t raw_lseek(int fd, off_t offset, int whence) {
    return syscall(__NR_lseek, fd, offset, whence);
}

static inline int raw_memfd_create(const char* name, unsigned int flags) {
    return static_cast<int>(syscall(__NR_memfd_create, name, flags));
}

static inline ssize_t raw_readlinkat(const char* path, char* buf, size_t size) {
    return syscall(__NR_readlinkat, AT_FDCWD, path, buf, size);
}

static bool is_app_process() {
    return (getuid() % AID_USER_OFFSET) >= AID_APP_START;
}

static const char* path_basename(const char* path) {
    const char* slash = strrchr(path, '/');
    return slash ? slash + 1 : path;
}

static bool path_parent_equals(const char* path, const char* parent) {
    size_t plen = strlen(parent);
    if (strncmp(path, parent, plen) != 0) return false;
    return path[plen] == '/';
}

static bool is_blocked_dir(const char* path) {
    const char* base = path_basename(path);
    for (const char* const* dn = kBlockedDirnames; *dn; ++dn) {
        if (strcmp(base, *dn) != 0) continue;
        for (const char* const* pp = kDirParents; *pp; ++pp) {
            if (path_parent_equals(path, *pp)) return true;
        }
    }
    return false;
}

static bool is_rom_path(const char* path) {
    if (!path || path[0] != '/') return false;

    size_t len = strlen(path);
    bool has_trailing = len > 1 && path[len - 1] == '/';
    char stack_buf[512];
    const char* clean = path;
    if (has_trailing) {
        if (len >= sizeof(stack_buf)) len = sizeof(stack_buf) - 1;
        memcpy(stack_buf, path, len);
        while (len > 1 && stack_buf[len - 1] == '/') len--;
        stack_buf[len] = '\0';
        clean = stack_buf;
    }

    for (const char* const* p = kBlockedExactPaths; *p; ++p) {
        if (strcmp(clean, *p) == 0) return true;
    }

    for (const PrefixEntry* p = kRecoveryPrefixes; p->str; ++p) {
        if (strncmp(clean, p->str, p->len) == 0) return true;
    }

    if (is_blocked_dir(clean)) return true;
    return false;
}

static bool resolve_fd_path(int fd, char* buf, size_t size) {
    char proc_link[64];
    snprintf(proc_link, sizeof(proc_link), "/proc/self/fd/%d", fd);
    ssize_t n = raw_readlinkat(proc_link, buf, size - 1);
    if (n > 0) {
        buf[n] = '\0';
        return true;
    }
    return false;
}

bool custom_rom_hide_should_block(const char* path) {
    if (!is_app_process()) return false;
    if (!path || reinterpret_cast<uintptr_t>(path) < 0x10000) return false;
    if (path[0] != '/') return false;
    return is_rom_path(path);
}

bool custom_rom_hide_should_block_at(int dirfd, const char* path) {
    if (!is_app_process()) return false;
    if (!path || reinterpret_cast<uintptr_t>(path) < 0x10000) return false;

    int saved_errno = errno;
    bool result = false;

    if (path[0] == '/') {
        result = custom_rom_hide_should_block(path);
    } else if (dirfd != AT_FDCWD) {
        char dir_path[256];
        if (resolve_fd_path(dirfd, dir_path, sizeof(dir_path))) {
            char full_path[512];
            snprintf(full_path, sizeof(full_path), "%s/%s", dir_path, path);
            result = custom_rom_hide_should_block(full_path);
        }
    }

    errno = saved_errno;
    return result;
}

bool custom_rom_hide_should_filter_dirent(int dirfd, const char* name) {
    if (!is_app_process()) return false;
    if (!name || reinterpret_cast<uintptr_t>(name) < 0x10000) return false;

    int saved_errno = errno;
    bool result = false;

    char dir_path[256];
    if (resolve_fd_path(dirfd, dir_path, sizeof(dir_path))) {
        for (const char* const* pp = kDirParents; *pp; ++pp) {
            if (strcmp(dir_path, *pp) == 0) {
                for (const char* const* dn = kBlockedDirnames; *dn; ++dn) {
                    if (strcmp(name, *dn) == 0) {
                        result = true;
                        break;
                    }
                }
                break;
            }
        }
    }

    errno = saved_errno;
    return result;
}

static int create_encoded_memfd(const char* path) {
    char memfd_name[250];
    snprintf(memfd_name, sizeof(memfd_name), "axion:%s", path);
    return raw_memfd_create(memfd_name, 0);
}

ssize_t custom_rom_hide_readlink_post(char* buf, size_t size, ssize_t ret) {
    if (ret <= 0 || !is_app_process()) return ret;

    const char* prefix = "/memfd:axion:";
    size_t prefix_len = 13;

    if (ret > static_cast<ssize_t>(prefix_len) && strncmp(buf, prefix, prefix_len) == 0) {
        char temp[256];
        size_t copy_len = static_cast<size_t>(ret) < sizeof(temp) - 1 ? static_cast<size_t>(ret) : sizeof(temp) - 1;
        memcpy(temp, buf, copy_len);
        temp[copy_len] = '\0';

        char* deleted_suffix = strstr(temp, " (deleted)");
        if (deleted_suffix) *deleted_suffix = '\0';

        const char* real_path = temp + prefix_len;
        size_t real_len = strlen(real_path);

        if (real_len > 0 && real_len <= size) {
            memcpy(buf, real_path, real_len);
            return static_cast<ssize_t>(real_len);
        }
    }
    return ret;
}

enum ProcFilterType {
    PROC_FILTER_NONE, PROC_FILTER_MAPS, PROC_FILTER_MOUNTS,
    PROC_FILTER_MOUNTINFO, PROC_FILTER_FILESYSTEMS, PROC_FILTER_CMDLINE,
};

static ProcFilterType get_proc_filter_type(const char* path) {
    if (!path || reinterpret_cast<uintptr_t>(path) < 0x10000) return PROC_FILTER_NONE;
    if (strcmp(path, "/proc/cmdline") == 0) return PROC_FILTER_CMDLINE;
    if (strcmp(path, "/proc/filesystems") == 0) return PROC_FILTER_FILESYSTEMS;
    if (strncmp(path, "/proc/", 6) != 0) return PROC_FILTER_NONE;

    const char* leaf = nullptr;
    if (strncmp(path, "/proc/self/", 11) == 0) leaf = path + 11;
    else if (strncmp(path, "/proc/thread-self/", 18) == 0) leaf = path + 18;
    else {
        const char* p = path + 6;
        while (*p >= '0' && *p <= '9') p++;
        if (*p == '/' && *(p + 1) != '\0') leaf = p + 1;
        else leaf = path + 6;
    }

    if (!leaf) return PROC_FILTER_NONE;
    if (strcmp(leaf, "maps") == 0 || strcmp(leaf, "smaps") == 0) return PROC_FILTER_MAPS;
    if (strcmp(leaf, "mounts") == 0) return PROC_FILTER_MOUNTS;
    if (strcmp(leaf, "mountinfo") == 0) return PROC_FILTER_MOUNTINFO;

    return PROC_FILTER_NONE;
}

static bool line_contains_any(const char* line, const char* const* keywords) {
    for (const char* const* kw = keywords; *kw; ++kw) {
        if (strstr(line, *kw) != nullptr) return true;
    }
    return false;
}

static bool should_filter_line(ProcFilterType type, const char* line) {
    switch (type) {
        case PROC_FILTER_MAPS: return line_contains_any(line, kProcFilterKeywords);
        case PROC_FILTER_MOUNTS:
        case PROC_FILTER_MOUNTINFO: return line_contains_any(line, kMountFilterKeywords);
        case PROC_FILTER_FILESYSTEMS: return strstr(line, "overlay") != nullptr;
        default: return false;
    }
}

static char* read_file_raw(const char* path, size_t* out_size) {
    int fd = raw_openat(path, O_RDONLY);
    if (fd < 0) return nullptr;

    size_t capacity = 16384;
    size_t size = 0;
    char* buf = static_cast<char*>(malloc(capacity));
    if (!buf) { raw_close(fd); return nullptr; }

    ssize_t n;
    while ((n = raw_read(fd, buf + size, capacity - size - 1)) > 0) {
        size += n;
        if (size >= capacity - 1) {
            capacity *= 2;
            char* new_buf = static_cast<char*>(realloc(buf, capacity));
            if (!new_buf) { free(buf); raw_close(fd); return nullptr; }
            buf = new_buf;
        }
    }
    raw_close(fd);
    buf[size] = '\0';
    *out_size = size;
    return buf;
}

static void filter_cmdline(int mem_fd, char* content, size_t len) {
    char* p;
    if ((p = strstr(content, "androidboot.verifiedbootstate=orange")) != nullptr) memcpy(p, "androidboot.verifiedbootstate=green ", 36);
    if ((p = strstr(content, "androidboot.verifiedbootstate=yellow")) != nullptr) memcpy(p, "androidboot.verifiedbootstate=green ", 36);
    if ((p = strstr(content, "androidboot.flash.locked=0")) != nullptr) memcpy(p, "androidboot.flash.locked=1", 26);
    if ((p = strstr(content, "androidboot.vbmeta.device_state=unlocked")) != nullptr) memcpy(p, "androidboot.vbmeta.device_state=locked  ", 40);
    raw_write(mem_fd, content, strnlen(content, len));
}

static void write_spoofed_mount_line(int mem_fd, char* line, size_t line_len) {
    char* rw_delim = strstr(line, ",rw,");
    if (rw_delim) { rw_delim[1] = 'r'; rw_delim[2] = 'o'; }
    rw_delim = strstr(line, " rw,");
    if (rw_delim) { rw_delim[1] = 'r'; rw_delim[2] = 'o'; }
    rw_delim = strstr(line, ",rw ");
    if (rw_delim) { rw_delim[1] = 'r'; rw_delim[2] = 'o'; }

    if (!strstr(line, "/dev/block/loop")) {
        char* target = strstr(line, " /system ");
        if (!target) target = strstr(line, " /vendor ");
        if (!target) target = strstr(line, " /product ");
        if (!target) target = strstr(line, " /system_ext ");
        if (!target) target = strstr(line, " /odm ");
        if (!target && (strstr(line, " / / ") || strstr(line, " / ext4") || strstr(line, " / erofs") || strstr(line, " / f2fs"))) target = line;

        if (target) {
            const char* replacement = "/dev/block/dm-0";
            if (strstr(line, " /vendor ")) replacement = "/dev/block/dm-1";
            else if (strstr(line, " /product ")) replacement = "/dev/block/dm-2";
            else if (strstr(line, " /system_ext ")) replacement = "/dev/block/dm-3";
            else if (strstr(line, " /odm ")) replacement = "/dev/block/dm-4";

            char* dev_start = strstr(line, "/dev/block/");
            if (!dev_start) dev_start = strstr(line, "/dev/root");

            if (dev_start) {
                char* dev_end = strchr(dev_start, ' ');
                if (!dev_end) dev_end = dev_start + strlen(dev_start);
                raw_write(mem_fd, line, dev_start - line);
                raw_write(mem_fd, replacement, strlen(replacement));
                raw_write(mem_fd, dev_end, line_len - (dev_end - line));
                return;
            }
        }
    }
    raw_write(mem_fd, line, line_len);
}

int custom_rom_hide_filter_proc(const char* path) {
    if (!is_app_process()) return -1;
    if (!path || reinterpret_cast<uintptr_t>(path) < 0x10000) return -1;

    int saved_errno = errno;
    ProcFilterType type = get_proc_filter_type(path);
    if (type == PROC_FILTER_NONE) { errno = saved_errno; return -1; }

    size_t file_size = 0;
    char* content = read_file_raw(path, &file_size);
    if (!content) { errno = saved_errno; return -1; }

    int mem_fd = create_encoded_memfd(path);
    if (mem_fd < 0) { free(content); errno = saved_errno; return -1; }

    if (type == PROC_FILTER_CMDLINE) {
        filter_cmdline(mem_fd, content, file_size);
    } else {
        char* pos = content;
        while (*pos) {
            char* eol = strchr(pos, '\n');
            size_t line_len = eol ? (eol - pos + 1) : strlen(pos);
            char saved = pos[line_len];
            pos[line_len] = '\0';
            if (!should_filter_line(type, pos)) {
                if (type == PROC_FILTER_MOUNTS || type == PROC_FILTER_MOUNTINFO) write_spoofed_mount_line(mem_fd, pos, line_len);
                else raw_write(mem_fd, pos, line_len);
            }
            pos[line_len] = saved;
            pos += line_len;
        }
    }

    free(content);
    raw_lseek(mem_fd, 0, SEEK_SET);
    errno = saved_errno;
    return mem_fd;
}

static const char* const kSepolicyFilterPaths[] = {
    "/system/etc/selinux/plat_service_contexts", "/system/etc/selinux/plat_seapp_contexts",
    "/system/etc/selinux/plat_file_contexts", "/system/etc/selinux/plat_property_contexts",
    "/system/etc/selinux/plat_sepolicy.cil", "/system_ext/etc/selinux/system_ext_service_contexts",
    "/system_ext/etc/selinux/system_ext_seapp_contexts", "/system_ext/etc/selinux/system_ext_file_contexts",
    "/system_ext/etc/selinux/system_ext_property_contexts", "/system_ext/etc/selinux/system_ext_sepolicy.cil",
    "/product/etc/selinux/product_service_contexts", "/product/etc/selinux/product_seapp_contexts",
    "/product/etc/selinux/product_file_contexts", "/product/etc/selinux/product_property_contexts",
    "/vendor/etc/selinux/vendor_file_contexts", "/vendor/etc/selinux/vendor_service_contexts",
    "/vendor/etc/selinux/vendor_hwservice_contexts", "/vendor/etc/selinux/vendor_property_contexts",
    "/vendor/etc/selinux/vendor_sepolicy.cil", "/vendor/etc/selinux/plat_pub_versioned.cil", nullptr
};

int custom_rom_hide_filter_sepolicy(const char* path) {
    if (!is_app_process()) return -1;
    if (!path || reinterpret_cast<uintptr_t>(path) < 0x10000) return -1;

    int saved_errno = errno;
    bool match = false;
    for (const char* const* p = kSepolicyFilterPaths; *p; ++p) {
        if (strcmp(path, *p) == 0) { match = true; break; }
    }
    if (!match) { errno = saved_errno; return -1; }

    size_t file_size = 0;
    char* content = read_file_raw(path, &file_size);
    if (!content) { errno = saved_errno; return -1; }

    int mem_fd = create_encoded_memfd(path);
    if (mem_fd < 0) { free(content); errno = saved_errno; return -1; }

    char* pos = content;
    while (*pos) {
        char* eol = strchr(pos, '\n');
        size_t line_len = eol ? (eol - pos + 1) : strlen(pos);
        char saved = pos[line_len];
        pos[line_len] = '\0';
        if (!strstr(pos, "lineage")) raw_write(mem_fd, pos, line_len);
        pos[line_len] = saved;
        pos += line_len;
    }

    free(content);
    raw_lseek(mem_fd, 0, SEEK_SET);
    errno = saved_errno;
    return mem_fd;
}

static const char* const kVintfFilterPaths[] = {
    "/system/etc/vintf/compatibility_matrix.xml", "/system/etc/vintf/compatibility_matrix.device.xml",
    "/vendor/etc/vintf/compatibility_matrix.xml", "/vendor/etc/vintf/compatibility_matrix.device.xml",
    "/product/etc/vintf/compatibility_matrix.xml", "/product/etc/vintf/compatibility_matrix.device.xml",
    "/system_ext/etc/vintf/compatibility_matrix.xml", "/system_ext/etc/vintf/compatibility_matrix.device.xml",
    "/odm/etc/vintf/compatibility_matrix.xml", "/odm/etc/vintf/compatibility_matrix.device.xml",
    "/system/etc/vintf/manifest.xml", "/vendor/etc/vintf/manifest.xml", "/product/etc/vintf/manifest.xml",
    "/system_ext/etc/vintf/manifest.xml", "/odm/etc/vintf/manifest.xml", nullptr
};

static const char* const kVintfFilterKeywords[] = {
    "lineage", "Lineage", "crdroid", "crDroid", nullptr
};

int custom_rom_hide_filter_vintf(const char* path) {
    if (!is_app_process()) return -1;
    if (!path || reinterpret_cast<uintptr_t>(path) < 0x10000) return -1;

    int saved_errno = errno;
    bool match = false;
    for (const char* const* p = kVintfFilterPaths; *p; ++p) {
        if (strcmp(path, *p) == 0) { match = true; break; }
    }
    if (!match) { errno = saved_errno; return -1; }

    size_t file_size = 0;
    char* content = read_file_raw(path, &file_size);
    if (!content) { errno = saved_errno; return -1; }

    int mem_fd = create_encoded_memfd(path);
    if (mem_fd < 0) { free(content); errno = saved_errno; return -1; }

    int skip_depth = 0;
    char* pos = content;
    while (*pos) {
        char* eol = strchr(pos, '\n');
        size_t line_len = eol ? static_cast<size_t>(eol - pos + 1) : strlen(pos);
        char saved = pos[line_len];
        pos[line_len] = '\0';

        bool keyword_hit = line_contains_any(pos, kVintfFilterKeywords);
        bool opens_block  = strstr(pos, "<hal") != nullptr || strstr(pos, "<interface") != nullptr;
        bool closes_block = strstr(pos, "</hal>") != nullptr || strstr(pos, "</interface>") != nullptr;

        if (skip_depth > 0) {
            if (opens_block) skip_depth++;
            if (closes_block) skip_depth--;
        } else if (keyword_hit) {
            if (opens_block && !closes_block) skip_depth = 1;
        } else {
            raw_write(mem_fd, pos, line_len);
        }

        pos[line_len] = saved;
        pos += line_len;
    }

    free(content);
    raw_lseek(mem_fd, 0, SEEK_SET);
    errno = saved_errno;
    return mem_fd;
}

static const char* const kSpoofedEmptyProps[] = {
    "ro.crdroid.version", "ro.lineage.version", "ro.lineage.build.version", "ro.cm.build.version",
    "ro.modversion", "init.svc_debug_pid.adb_root", "init.svc_debug_pid.adbd",
    "init.svc.adb_root", "init.svc.adbd", "service.adb.root", nullptr
};

struct PropOverride { const char* name; const char* value; };
static const PropOverride kSpoofedValueProps[] = {
    {"ro.debuggable", "0"}, {"ro.build.type", "user"}, {"ro.secure", "1"},
    {"ro.adb.secure", "1"}, {"persist.sys.usb.config", "mtp"},
    {"sys.usb.config", "mtp"}, {nullptr, nullptr}
};

bool custom_rom_hide_should_spoof_prop(const char* name, char* value) {
    if (!is_app_process() || !name) return false;
    for (const char* const* p = kSpoofedEmptyProps; *p; ++p) {
        if (strcmp(name, *p) == 0) { value[0] = '\0'; return true; }
    }
    for (const PropOverride* o = kSpoofedValueProps; o->name; ++o) {
        if (strcmp(name, o->name) == 0) { strcpy(value, o->value); return true; }
    }
    return false;
}

bool custom_rom_hide_should_hide_prop(const char* name) {
    if (!is_app_process() || !name) return false;
    for (const char* const* p = kSpoofedEmptyProps; *p; ++p) {
        if (strcmp(name, *p) == 0) return true;
    }
    return false;
}

const char* custom_rom_hide_get_prop_override(const char* name) {
    if (!is_app_process() || !name) return nullptr;
    for (const PropOverride* o = kSpoofedValueProps; o->name; ++o) {
        if (strcmp(name, o->name) == 0) return o->value;
    }
    return nullptr;
}

bool custom_rom_hide_is_app_process() {
    return is_app_process();
}

static const PartitionDevEntry* find_partition_entry(const char* path) {
    if (!path) return nullptr;
    for (const PartitionDevEntry* e = kPartitionDmMap; e->path; ++e) {
        if (strcmp(path, e->path) == 0) return e;
    }
    return nullptr;
}

void custom_rom_hide_spoof_stat(const char* path, struct stat* sb) {
    if (!is_app_process() || !path || !sb) return;
    if (strcmp(path, "/data/local/tmp") == 0) { sb->st_ino = 4223; return; }
    const PartitionDevEntry* e = find_partition_entry(path);
    if (e && major(sb->st_dev) != DM_MAJOR) sb->st_dev = makedev(DM_MAJOR, e->dm_minor);
}

void custom_rom_hide_spoof_statx(const char* path, struct statx* sx) {
    if (!is_app_process() || !path || !sx) return;
    const PartitionDevEntry* e = find_partition_entry(path);
    if (e && sx->stx_dev_major != DM_MAJOR) {
        sx->stx_dev_major = DM_MAJOR;
        sx->stx_dev_minor = e->dm_minor;
    }
}
