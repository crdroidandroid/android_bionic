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
#include <linux/magic.h>
#include <linux/memfd.h>
#include <linux/stat.h>
#include <stdio.h>
#include <stdatomic.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/statfs.h>
#include <sys/syscall.h>
#include <sys/sysmacros.h>
#include <unistd.h>
#include <private/android_filesystem_config.h>

#define HIDE_MEMFD_TAG "mf"
#define HIDE_MEMFD_NAME_PREFIX HIDE_MEMFD_TAG ":"
#define HIDE_MEMFD_LINK_PREFIX "/memfd:" HIDE_MEMFD_TAG ":"
#define HIDE_MEMFD_LINK_PREFIX_LEN (sizeof(HIDE_MEMFD_LINK_PREFIX) - 1)
#define HIDE_TRACKED_FD_LIMIT 32768
#define HIDE_TRACKED_FD_WORD_BITS 64
#define HIDE_TRACKED_FD_WORD_COUNT (HIDE_TRACKED_FD_LIMIT / HIDE_TRACKED_FD_WORD_BITS)

struct PrefixEntry {
    const char* str;
    size_t len;
};
#define PE(s) { s, sizeof(s) - 1 }

static const char* const kBlockedDirnames[] = {
    "addon.d", "init.d", "TWRP", nullptr
};

static const PrefixEntry kDirParents[] = {
    PE("/system"), PE("/system/etc"),
    PE("/system_ext"), PE("/system_ext/etc"),
    PE("/product"), PE("/product/etc"),
    PE("/vendor"), PE("/vendor/etc"),
    PE("/sdcard"), PE("/data/media/0"),
    { nullptr, 0 }
};

static const PrefixEntry kProcFilterKeywords[] = {
    PE("lineage"), PE("Lineage"), PE("crdroid"), PE("crDroid"),
    PE("omnirom"), PE("aospa"),
    { nullptr, 0 }
};

static const char* const kMountFilterKeywords[] = {
    "/debug_ramdisk", "overlay", "magisk", "ksu", "KSU", "ksud", "apatch", "/data/adb", nullptr
};

static const char* const kAllowlistedPackages[] = {
    "org.lineageos.updater",
    nullptr
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

static _Atomic(uint64_t) g_substituted_fd_bits[HIDE_TRACKED_FD_WORD_COUNT];
static _Atomic(bool) g_custom_rom_hide_enabled = false;
static _Atomic(bool) g_adb_enabled = false;
static _Atomic(bool) g_selinux_enforcing_enabled = false;

static constexpr char kPrivacyEnvName[] = "BIONIC_AX_SANDBOX_PRIVACY";
static constexpr char kAdbEnvName[] = "BIONIC_AX_SANDBOX_ADB";
static constexpr char kSelinuxEnforcingEnvName[] =
        "BIONIC_AX_SANDBOX_SELINUX_ENFORCING";

void custom_rom_hide_set_enabled(bool enabled) {
    atomic_store_explicit(&g_custom_rom_hide_enabled, enabled, memory_order_release);
}

bool custom_rom_hide_is_enabled() {
    if (atomic_load_explicit(&g_custom_rom_hide_enabled, memory_order_acquire)) return true;

    const char* inherited = getenv(kPrivacyEnvName);
    if (inherited == nullptr || strcmp(inherited, "1") != 0) return false;

    atomic_store_explicit(&g_custom_rom_hide_enabled, true, memory_order_release);
    return true;
}

void custom_rom_hide_set_adb_enabled(bool enabled) {
    atomic_store_explicit(&g_adb_enabled, enabled, memory_order_release);
}

bool custom_rom_hide_is_adb_enabled() {
    if (atomic_load_explicit(&g_adb_enabled, memory_order_acquire)) return true;

    const char* inherited = getenv(kAdbEnvName);
    if (inherited == nullptr || strcmp(inherited, "1") != 0) return false;

    atomic_store_explicit(&g_adb_enabled, true, memory_order_release);
    atomic_store_explicit(&g_custom_rom_hide_enabled, true, memory_order_release);
    return true;
}

void custom_rom_hide_set_selinux_enforcing_enabled(bool enabled) {
    atomic_store_explicit(&g_selinux_enforcing_enabled, enabled, memory_order_release);
}

bool custom_rom_hide_is_selinux_enforcing_enabled() {
    if (atomic_load_explicit(&g_selinux_enforcing_enabled, memory_order_acquire)) return true;

    const char* inherited = getenv(kSelinuxEnforcingEnvName);
    if (inherited == nullptr || strcmp(inherited, "1") != 0) return false;

    atomic_store_explicit(&g_selinux_enforcing_enabled, true, memory_order_release);
    atomic_store_explicit(&g_custom_rom_hide_enabled, true, memory_order_release);
    return true;
}

bool custom_rom_hide_should_propagate_selinux_enforcing() {
    return custom_rom_hide_is_selinux_enforcing_enabled();
}

bool custom_rom_hide_should_propagate_adb() {
    return custom_rom_hide_is_adb_enabled();
}

bool custom_rom_hide_should_propagate() {
    return custom_rom_hide_is_enabled();
}

static bool is_trackable_fd(int fd) {
    return fd >= 0 && fd < HIDE_TRACKED_FD_LIMIT;
}

static bool is_tracked_fd(int fd) {
    if (!is_trackable_fd(fd)) return false;
    uint64_t bit = 1ULL << (fd % HIDE_TRACKED_FD_WORD_BITS);
    uint64_t word = atomic_load_explicit(&g_substituted_fd_bits[fd / HIDE_TRACKED_FD_WORD_BITS],
                                         memory_order_acquire);
    return (word & bit) != 0;
}

static void register_fd(int fd) {
    if (!is_trackable_fd(fd)) return;
    uint64_t bit = 1ULL << (fd % HIDE_TRACKED_FD_WORD_BITS);
    atomic_fetch_or_explicit(&g_substituted_fd_bits[fd / HIDE_TRACKED_FD_WORD_BITS], bit,
                             memory_order_release);
}

void custom_rom_hide_unregister_fd(int fd) {
    if (!is_trackable_fd(fd)) return;
    uint64_t bit = 1ULL << (fd % HIDE_TRACKED_FD_WORD_BITS);
    _Atomic(uint64_t)* word = &g_substituted_fd_bits[fd / HIDE_TRACKED_FD_WORD_BITS];
    if ((atomic_load_explicit(word, memory_order_acquire) & bit) == 0) return;
    atomic_fetch_and_explicit(word, ~bit, memory_order_release);
}

void custom_rom_hide_transfer_fd(int old_fd, int new_fd) {
    if (new_fd < 0 || old_fd == new_fd) return;
    if (is_tracked_fd(old_fd)) register_fd(new_fd);
    else custom_rom_hide_unregister_fd(new_fd);
}

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

static inline int raw_fstatat(int dirfd, const char* path, struct stat* sb, int flags) {
#if defined(__LP64__)
    return static_cast<int>(syscall(__NR_newfstatat, dirfd, path, sb, flags));
#else
    return static_cast<int>(syscall(__NR_fstatat64, dirfd, path, sb, flags));
#endif
}

static inline int raw_statx(int dirfd, const char* path, int flags, unsigned mask, struct statx* sx) {
    return static_cast<int>(syscall(__NR_statx, dirfd, path, flags, mask, sx));
}

static inline int raw_statfs(const char* path, struct statfs* sf) {
#if defined(__LP64__)
    return static_cast<int>(syscall(__NR_statfs, path, sf));
#else
    return static_cast<int>(syscall(__NR_statfs64, path, sizeof(*sf), sf));
#endif
}

static bool compute_allowlisted() {
    int fd = raw_openat("/proc/self/cmdline", O_RDONLY);
    if (fd < 0) return false;

    char cmdline[256];
    ssize_t n = raw_read(fd, cmdline, sizeof(cmdline) - 1);
    raw_close(fd);
    if (n <= 0) return false;

    cmdline[n] = '\0';
    if (char* colon = strchr(cmdline, ':')) *colon = '\0';

    for (const char* const* p = kAllowlistedPackages; *p; ++p) {
        if (strcmp(cmdline, *p) == 0) return true;
    }
    return false;
}

static bool compute_app_process() {
    if (!custom_rom_hide_is_enabled()) return false;
    if ((getuid() % AID_USER_OFFSET) < AID_APP_START) return false;

    // crash_dump runs with the crashing app's UID. Treating it as an app
    // replaces /proc/<pid>/maps with a memfd and prevents debuggerd from
    // producing a tombstone under SELinux.
    const char* progname = getprogname();
    if (progname && (strcmp(progname, "crash_dump32") == 0 ||
                     strcmp(progname, "crash_dump64") == 0)) {
        return false;
    }

    if (compute_allowlisted()) return false;
    return true;
}

static bool is_app_process() {
    static _Atomic(pid_t) cached_pid = -1;
    static _Atomic(uid_t) cached_uid = static_cast<uid_t>(-1);
    static _Atomic(bool) cached_value = false;

    // An exec'd helper enables the policy lazily from its inherited marker. Do not cache a
    // disabled result before that marker is consumed.
    if (!custom_rom_hide_is_enabled()) return false;

    pid_t cur = getpid();
    uid_t cur_uid = getuid();
    if (atomic_load_explicit(&cached_pid, memory_order_acquire) == cur &&
        atomic_load_explicit(&cached_uid, memory_order_acquire) == cur_uid) {
        return atomic_load_explicit(&cached_value, memory_order_acquire);
    }

    bool result = compute_app_process();
    atomic_store_explicit(&cached_value, result, memory_order_release);
    atomic_store_explicit(&cached_uid, cur_uid, memory_order_release);
    atomic_store_explicit(&cached_pid, cur, memory_order_release);
    return result;
}

static const char* path_basename(const char* path) {
    const char* slash = strrchr(path, '/');
    return slash ? slash + 1 : path;
}

static bool path_parent_equals(const char* path, const char* parent, size_t plen) {
    if (strncmp(path, parent, plen) != 0) return false;
    return path[plen] == '/';
}

static bool is_blocked_dir(const char* path) {
    const char* base = path_basename(path);

    bool name_match = false;
    for (const char* const* dn = kBlockedDirnames; *dn; ++dn) {
        if (strcmp(base, *dn) == 0) { name_match = true; break; }
    }
    if (!name_match) return false;

    for (const PrefixEntry* pp = kDirParents; pp->str; ++pp) {
        if (path_parent_equals(path, pp->str, pp->len)) return true;
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

    if (is_blocked_dir(clean)) return true;
    return false;
}

static bool is_adb_socket_path(const char* path) {
    return custom_rom_hide_is_adb_enabled() &&
            path != nullptr && strcmp(path, "/dev/socket/adbd") == 0;
}

static bool resolve_fd_path(int fd, char* buf, size_t size) {
    char proc_link[64];
    if (fd < 0) return false;
    snprintf(proc_link, sizeof(proc_link), "/proc/self/fd/%d", fd);
    ssize_t n = raw_readlinkat(proc_link, buf, size - 1);
    if (n > 0) {
        buf[n] = '\0';
        return true;
    }
    return false;
}

bool custom_rom_hide_should_block(const char* path) {
    if (!path || reinterpret_cast<uintptr_t>(path) < 0x1000000) return false;
    if (path[0] != '/') return false;
    if (!is_app_process()) return false;
    return is_rom_path(path) || is_adb_socket_path(path);
}

bool custom_rom_hide_should_block_at(int dirfd, const char* path) {
    if (!path || reinterpret_cast<uintptr_t>(path) < 0x1000000) return false;
    if (!is_app_process()) return false;

    int saved_errno = errno;
    bool result = false;

    if (path[0] == '/') {
        result = is_rom_path(path) || is_adb_socket_path(path);
    } else if (dirfd != AT_FDCWD) {
        size_t plen = strlen(path);
        bool candidate = plen > 0 && path[plen - 1] == '/';
        if (custom_rom_hide_is_adb_enabled() && strcmp(path, "adbd") == 0) {
            candidate = true;
        }
        if (!candidate) {
            const char* base = path_basename(path);
            for (const char* const* dn = kBlockedDirnames; *dn; ++dn) {
                if (strcmp(base, *dn) == 0) { candidate = true; break; }
            }
        }
        if (candidate) {
            char dir_path[256];
            if (resolve_fd_path(dirfd, dir_path, sizeof(dir_path))) {
                char full_path[512];
                snprintf(full_path, sizeof(full_path), "%s/%s", dir_path, path);
                result = is_rom_path(full_path) || is_adb_socket_path(full_path);
            }
        }
    }

    errno = saved_errno;
    return result;
}

int custom_rom_hide_filter_faccessat_syscall(int dirfd, const char* path) {
    return custom_rom_hide_should_block_at(dirfd, path) ? ENOENT : 0;
}

bool custom_rom_hide_should_filter_dirent(int dirfd, const char* name) {
    if (!name || reinterpret_cast<uintptr_t>(name) < 0x1000000) return false;
    if (!is_app_process()) return false;

    int saved_errno = errno;
    char dir_path[256];
    if (custom_rom_hide_is_adb_enabled() && strcmp(name, "adbd") == 0) {
        const bool is_adb_socket = resolve_fd_path(dirfd, dir_path, sizeof(dir_path)) &&
                strcmp(dir_path, "/dev/socket") == 0;
        errno = saved_errno;
        if (is_adb_socket) return true;
    }

    bool name_match = false;
    for (const char* const* dn = kBlockedDirnames; *dn; ++dn) {
        if (strcmp(name, *dn) == 0) { name_match = true; break; }
    }
    if (!name_match) return false;

    bool result = false;

    if (resolve_fd_path(dirfd, dir_path, sizeof(dir_path))) {
        for (const PrefixEntry* pp = kDirParents; pp->str; ++pp) {
            if (strcmp(dir_path, pp->str) == 0) { result = true; break; }
        }
    }

    errno = saved_errno;
    return result;
}

static int create_encoded_memfd(const char* path) {
    char memfd_name[250];
    snprintf(memfd_name, sizeof(memfd_name), HIDE_MEMFD_NAME_PREFIX "%s", path);
    int fd = raw_memfd_create(memfd_name, 0);
    if (fd >= 0) register_fd(fd);
    return fd;
}

int custom_rom_hide_filter_selinux_enforce_at(int dirfd, const char* path, int flags) {
    if (!path || reinterpret_cast<uintptr_t>(path) < 0x1000000) return -1;
    if ((flags & O_ACCMODE) != O_RDONLY || (flags & O_PATH) != 0) return -1;
    if (!custom_rom_hide_is_selinux_enforcing_enabled() || !is_app_process()) return -1;

    int saved_errno = errno;
    bool match = strcmp(path, "/sys/fs/selinux/enforce") == 0;
    char full_path[512];
    if (!match && path[0] != '/' && dirfd != AT_FDCWD) {
        char dir_path[384];
        if (resolve_fd_path(dirfd, dir_path, sizeof(dir_path))) {
            int n = snprintf(full_path, sizeof(full_path), "%s/%s", dir_path, path);
            match = n > 0 && static_cast<size_t>(n) < sizeof(full_path)
                    && strcmp(full_path, "/sys/fs/selinux/enforce") == 0;
        }
    }
    if (!match) {
        errno = saved_errno;
        return -1;
    }

    int mem_fd = create_encoded_memfd("/sys/fs/selinux/enforce");
    if (mem_fd >= 0) {
        static constexpr char kEnforcing[] = "1\n";
        if (raw_write(mem_fd, kEnforcing, sizeof(kEnforcing) - 1)
                != static_cast<ssize_t>(sizeof(kEnforcing) - 1)
                || raw_lseek(mem_fd, 0, SEEK_SET) < 0) {
            custom_rom_hide_unregister_fd(mem_fd);
            raw_close(mem_fd);
            mem_fd = -1;
        }
    }
    errno = saved_errno;
    return mem_fd;
}

static bool decode_encoded_memfd_link(const char* link, char* out, size_t out_size) {
    if (!link || !out || out_size == 0) return false;
    if (strncmp(link, HIDE_MEMFD_LINK_PREFIX, HIDE_MEMFD_LINK_PREFIX_LEN) != 0) return false;

    const char* real_path = link + HIDE_MEMFD_LINK_PREFIX_LEN;
    size_t real_len = strlen(real_path);
    const char* deleted_suffix = strstr(real_path, " (deleted)");
    if (deleted_suffix) real_len = static_cast<size_t>(deleted_suffix - real_path);
    if (real_len == 0 || real_len >= out_size) return false;

    memcpy(out, real_path, real_len);
    out[real_len] = '\0';
    return true;
}

static bool resolve_encoded_memfd_path(int fd, char* out, size_t out_size) {
    if (!is_tracked_fd(fd)) return false;

    char fd_path[512];
    if (!resolve_fd_path(fd, fd_path, sizeof(fd_path))) return false;
    bool decoded = decode_encoded_memfd_link(fd_path, out, out_size);
    if (!decoded) custom_rom_hide_unregister_fd(fd);
    return decoded;
}

ssize_t custom_rom_hide_readlink_post(char* buf, size_t size, ssize_t ret) {
    if (ret <= 0 || !is_app_process()) return ret;

    if (ret > static_cast<ssize_t>(HIDE_MEMFD_LINK_PREFIX_LEN) &&
        strncmp(buf, HIDE_MEMFD_LINK_PREFIX, HIDE_MEMFD_LINK_PREFIX_LEN) == 0) {
        char temp[512];
        size_t copy_len = static_cast<size_t>(ret) < sizeof(temp) - 1 ? static_cast<size_t>(ret) : sizeof(temp) - 1;
        memcpy(temp, buf, copy_len);
        temp[copy_len] = '\0';

        char real_path[512];
        if (!decode_encoded_memfd_link(temp, real_path, sizeof(real_path))) return ret;
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
    PROC_FILTER_STATUS,
};

static bool is_own_proc_status(const char* path) {
    if (strcmp(path, "/proc/self/status") == 0 ||
        strcmp(path, "/proc/thread-self/status") == 0) {
        return true;
    }

    if (strncmp(path, "/proc/", 6) != 0) return false;
    char* end = nullptr;
    long pid = strtol(path + 6, &end, 10);
    return end != path + 6 && strcmp(end, "/status") == 0 && pid == getpid();
}

static ProcFilterType get_proc_filter_type(const char* path) {
    if (!path || reinterpret_cast<uintptr_t>(path) < 0x1000000) return PROC_FILTER_NONE;
    if (strcmp(path, "/proc/cmdline") == 0) return PROC_FILTER_CMDLINE;
    if (strcmp(path, "/proc/filesystems") == 0) return PROC_FILTER_FILESYSTEMS;
    if (is_own_proc_status(path)) return PROC_FILTER_STATUS;
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

static bool line_has_blocked_segment(const char* line) {
    const char* path = strchr(line, '/');
    if (!path) return false;
    for (const PrefixEntry* kw = kProcFilterKeywords; kw->str; ++kw) {
        const char* p = path;
        while ((p = strstr(p, kw->str)) != nullptr) {
            char before = (p == line) ? '/' : p[-1];
            char after = p[kw->len];
            bool lb = before == '/' || before == ' ' || before == '\0';
            bool rb = after == '/' || after == ' ' || after == '.' || after == '\0' || after == '\n';
            if (lb && rb) return true;
            p += kw->len;
        }
    }
    return false;
}

static bool line_contains_any(const char* line, const char* const* keywords) {
    for (const char* const* kw = keywords; *kw; ++kw) {
        if (strstr(line, *kw) != nullptr) return true;
    }
    return false;
}

static bool should_filter_line(ProcFilterType type, const char* line) {
    switch (type) {
        case PROC_FILTER_MAPS: return line_has_blocked_segment(line);
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

typedef bool (*LinePredicate)(const char* line, void* ctx);
typedef void (*LineWriter)(int mem_fd, char* line, size_t line_len, void* ctx);

static void write_line_raw(int mem_fd, char* line, size_t line_len, void*) {
    raw_write(mem_fd, line, line_len);
}

static void write_status_line(int mem_fd, char* line, size_t line_len, void*) {
    static constexpr char kTracerPid[] = "TracerPid:";
    if (strncmp(line, kTracerPid, sizeof(kTracerPid) - 1) == 0) {
        static constexpr char kHiddenTracer[] = "TracerPid:\t0\n";
        raw_write(mem_fd, kHiddenTracer, sizeof(kHiddenTracer) - 1);
        return;
    }
    raw_write(mem_fd, line, line_len);
}

static int filter_file_with(const char* path, LinePredicate drop, LineWriter writer, void* ctx) {
    size_t file_size = 0;
    char* content = read_file_raw(path, &file_size);
    if (!content) return -1;

    int mem_fd = create_encoded_memfd(path);
    if (mem_fd < 0) {
        free(content);
        return -1;
    }

    char* pos = content;
    while (*pos) {
        char* eol = strchr(pos, '\n');
        size_t line_len = eol ? static_cast<size_t>(eol - pos + 1) : strlen(pos);
        char saved = pos[line_len];
        pos[line_len] = '\0';
        if (!drop || !drop(pos, ctx)) {
            (writer ? writer : write_line_raw)(mem_fd, pos, line_len, ctx);
        }
        pos[line_len] = saved;
        pos += line_len;
    }

    free(content);
    raw_lseek(mem_fd, 0, SEEK_SET);
    return mem_fd;
}

static void replace_all_cmdline(char* content, size_t len, const char* needle, size_t needle_len,
                                const char* replacement, size_t replacement_len) {
    if (needle_len == 0 || needle_len != replacement_len) return;

    char* end = content + strnlen(content, len);
    for (char* p = content; p < end;) {
        char* hit = strstr(p, needle);
        if (!hit || hit >= end) break;
        memcpy(hit, replacement, needle_len);
        p = hit + needle_len;
    }
}

#define REPLACE_CMDLINE_LITERAL(content, len, needle, replacement) \
    do { \
        static_assert(sizeof(needle) == sizeof(replacement), \
                      "cmdline replacement must preserve byte length"); \
        replace_all_cmdline(content, len, needle, sizeof(needle) - 1, replacement, \
                            sizeof(replacement) - 1); \
    } while (false)

static void filter_cmdline(int mem_fd, char* content, size_t len) {
    REPLACE_CMDLINE_LITERAL(content, len, "androidboot.verifiedbootstate=orange", "androidboot.verifiedbootstate=green ");
    REPLACE_CMDLINE_LITERAL(content, len, "androidboot.verifiedbootstate=yellow", "androidboot.verifiedbootstate=green ");
    REPLACE_CMDLINE_LITERAL(content, len, "androidboot.flash.locked=0", "androidboot.flash.locked=1");
    REPLACE_CMDLINE_LITERAL(content, len, "androidboot.vbmeta.device_state=unlocked", "androidboot.vbmeta.device_state=locked  ");
    raw_write(mem_fd, content, strnlen(content, len));
}

struct MountDm { const char* mnt; const char* dev; };
static const MountDm kMountDm[] = {
    { " /system ",     "/dev/block/dm-0" },
    { " /vendor ",     "/dev/block/dm-1" },
    { " /product ",    "/dev/block/dm-2" },
    { " /system_ext ", "/dev/block/dm-3" },
    { " /odm ",        "/dev/block/dm-4" },
    { nullptr,         nullptr },
};

static void write_spoofed_mount_line(int mem_fd, char* line, size_t line_len, void*) {
    char* rw_delim = strstr(line, ",rw,");
    if (rw_delim) { rw_delim[1] = 'r'; rw_delim[2] = 'o'; }
    rw_delim = strstr(line, " rw,");
    if (rw_delim) { rw_delim[1] = 'r'; rw_delim[2] = 'o'; }
    rw_delim = strstr(line, ",rw ");
    if (rw_delim) { rw_delim[1] = 'r'; rw_delim[2] = 'o'; }

    if (!strstr(line, "/dev/block/loop")) {
        const char* replacement = nullptr;
        for (const MountDm* m = kMountDm; m->mnt; ++m) {
            if (strstr(line, m->mnt)) { replacement = m->dev; break; }
        }
        if (!replacement &&
            (strstr(line, " / / ") || strstr(line, " / ext4") ||
             strstr(line, " / erofs") || strstr(line, " / f2fs")))
            replacement = "/dev/block/dm-0";

        if (replacement) {
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

static bool drop_proc_line(const char* line, void* ctx) {
    return should_filter_line(*static_cast<ProcFilterType*>(ctx), line);
}

int custom_rom_hide_filter_proc(const char* path) {
    if (!is_app_process()) return -1;
    if (!path || reinterpret_cast<uintptr_t>(path) < 0x1000000) return -1;

    int saved_errno = errno;
    ProcFilterType type = get_proc_filter_type(path);
    if (type == PROC_FILTER_NONE) { errno = saved_errno; return -1; }

    if (type != PROC_FILTER_CMDLINE) {
        LineWriter writer;
        if (type == PROC_FILTER_MOUNTS || type == PROC_FILTER_MOUNTINFO) {
            writer = write_spoofed_mount_line;
        } else if (type == PROC_FILTER_STATUS) {
            writer = write_status_line;
        } else {
            writer = write_line_raw;
        }
        int mem_fd = filter_file_with(path, drop_proc_line, writer, &type);
        errno = saved_errno;
        return mem_fd;
    }

    size_t file_size = 0;
    char* content = read_file_raw(path, &file_size);
    if (!content) { errno = saved_errno; return -1; }

    int mem_fd = create_encoded_memfd(path);
    if (mem_fd < 0) { free(content); errno = saved_errno; return -1; }

    filter_cmdline(mem_fd, content, file_size);

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
    if (!path || reinterpret_cast<uintptr_t>(path) < 0x1000000) return -1;

    int saved_errno = errno;
    bool match = false;
    for (const char* const* p = kSepolicyFilterPaths; *p; ++p) {
        if (strcmp(path, *p) == 0) { match = true; break; }
    }
    if (!match) { errno = saved_errno; return -1; }

    int mem_fd = filter_file_with(path, [](const char* line, void*) {
        return strstr(line, "lineage") != nullptr;
    }, write_line_raw, nullptr);
    errno = saved_errno;
    return mem_fd;
}

#ifndef CUSTOM_ROM_HIDE_FILTER_VINTF
#define CUSTOM_ROM_HIDE_FILTER_VINTF 1
#endif

#if CUSTOM_ROM_HIDE_FILTER_VINTF
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
#endif

int custom_rom_hide_filter_vintf(const char* path) {
#if !CUSTOM_ROM_HIDE_FILTER_VINTF
    (void) path;
    return -1;
#else
    if (!is_app_process()) return -1;
    if (!path || reinterpret_cast<uintptr_t>(path) < 0x1000000) return -1;

    int saved_errno = errno;
    bool match = false;
    for (const char* const* p = kVintfFilterPaths; *p; ++p) {
        if (strcmp(path, *p) == 0) { match = true; break; }
    }
    if (!match) { errno = saved_errno; return -1; }

    struct VintfCtx {
        int skip_depth;
    } ctx = {};
    int mem_fd = filter_file_with(path, [](const char* line, void* raw_ctx) {
        VintfCtx* ctx = static_cast<VintfCtx*>(raw_ctx);
        bool keyword_hit = line_contains_any(line, kVintfFilterKeywords);
        bool opens_block = strstr(line, "<hal") != nullptr || strstr(line, "<interface") != nullptr;
        bool closes_block = strstr(line, "</hal>") != nullptr || strstr(line, "</interface>") != nullptr;

        if (ctx->skip_depth > 0) {
            if (opens_block) ctx->skip_depth++;
            if (closes_block) ctx->skip_depth--;
            return true;
        }
        if (keyword_hit) {
            if (opens_block && !closes_block) ctx->skip_depth = 1;
            return true;
        }
        return false;
    }, write_line_raw, &ctx);
    if (mem_fd >= 0 && ctx.skip_depth != 0) {
        custom_rom_hide_unregister_fd(mem_fd);
        raw_close(mem_fd);
        errno = saved_errno;
        return -1;
    }
    errno = saved_errno;
    return mem_fd;
#endif
}

static const char* const kSpoofedEmptyProps[] = {
    "ro.crdroid.version", "ro.lineage.version", "ro.lineage.build.version", "ro.cm.build.version",
    "ro.modversion", nullptr
};

static const char* const kSpoofedAdbEmptyProps[] = {
    "init.svc_debug_pid.adb_root", "init.svc.adb_root", "service.adb.root", nullptr
};

struct PropOverride { const char* name; const char* value; };
static const PropOverride kSpoofedValueProps[] = {
    {"ro.debuggable", "0"},
    {"ro.build.type", "user"},
    {"ro.build.tags", "release-keys"},
    {"ro.secure", "1"},
    {nullptr, nullptr}
};

static const PropOverride kSpoofedAdbValueProps[] = {
    {"ro.adb.secure", "1"},
    {"init.svc.adbd", "stopped"},
    {"sys.usb.config", "mtp"},
    {"sys.usb.state", "mtp"},
    {"sys.usb.adb.disabled", "1"},
    {"persist.sys.usb.config", "mtp"},
    {nullptr, nullptr}
};

bool custom_rom_hide_should_spoof_prop(const char* name, char* value) {
    if (!name || !value) return false;
    if (reinterpret_cast<uintptr_t>(name) < 0x1000000) return false;
    if (reinterpret_cast<uintptr_t>(value) < 0x1000000) return false;
    if (!is_app_process()) return false;
    for (const char* const* p = kSpoofedEmptyProps; *p; ++p) {
        if (strcmp(name, *p) == 0) { value[0] = '\0'; return true; }
    }
    for (const PropOverride* o = kSpoofedValueProps; o->name; ++o) {
        if (strcmp(name, o->name) == 0) { strcpy(value, o->value); return true; }
    }
    if (!custom_rom_hide_is_adb_enabled()) return false;
    for (const char* const* p = kSpoofedAdbEmptyProps; *p; ++p) {
        if (strcmp(name, *p) == 0) { value[0] = '\0'; return true; }
    }
    for (const PropOverride* o = kSpoofedAdbValueProps; o->name; ++o) {
        if (strcmp(name, o->name) == 0) { strcpy(value, o->value); return true; }
    }
    return false;
}

bool custom_rom_hide_should_hide_prop(const char* name) {
    if (!name || reinterpret_cast<uintptr_t>(name) < 0x1000000) return false;
    if (!is_app_process()) return false;
    for (const char* const* p = kSpoofedEmptyProps; *p; ++p) {
        if (strcmp(name, *p) == 0) return true;
    }
    if (!custom_rom_hide_is_adb_enabled()) return false;
    for (const char* const* p = kSpoofedAdbEmptyProps; *p; ++p) {
        if (strcmp(name, *p) == 0) return true;
    }
    return false;
}

const char* custom_rom_hide_get_prop_override(const char* name) {
    if (!name || reinterpret_cast<uintptr_t>(name) < 0x1000000) return nullptr;
    if (!is_app_process()) return nullptr;
    for (const PropOverride* o = kSpoofedValueProps; o->name; ++o) {
        if (strcmp(name, o->name) == 0) return o->value;
    }
    if (!custom_rom_hide_is_adb_enabled()) return nullptr;
    for (const PropOverride* o = kSpoofedAdbValueProps; o->name; ++o) {
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

void custom_rom_hide_spoof_fd_stat(int fd, struct stat* sb) {
    if (fd < 0 || !sb) return;
    if (!is_tracked_fd(fd)) return;
    if (!is_app_process()) return;

    int saved_errno = errno;
    char real_path[512];
    if (resolve_encoded_memfd_path(fd, real_path, sizeof(real_path))) {
        struct stat real_sb;
        if (raw_fstatat(AT_FDCWD, real_path, &real_sb, 0) == 0) {
            *sb = real_sb;
        } else {
            sb->st_dev = makedev(0, 0);
            sb->st_ino = 0;
        }
    }
    errno = saved_errno;
}

void custom_rom_hide_spoof_fd_statx(int fd, unsigned mask, struct statx* sx) {
    if (fd < 0 || !sx) return;
    if (!is_tracked_fd(fd)) return;
    if (!is_app_process()) return;

    int saved_errno = errno;
    char real_path[512];
    if (resolve_encoded_memfd_path(fd, real_path, sizeof(real_path))) {
        struct statx real_sx;
        if (raw_statx(AT_FDCWD, real_path, 0, mask, &real_sx) == 0) {
            *sx = real_sx;
        } else {
            sx->stx_dev_major = 0;
            sx->stx_dev_minor = 0;
            sx->stx_ino = 0;
        }
    }
    errno = saved_errno;
}

void custom_rom_hide_spoof_fd_statfs(int fd, struct statfs* sf) {
    if (fd < 0 || !sf) return;
    if (!is_tracked_fd(fd)) return;
    if (!is_app_process()) return;

    int saved_errno = errno;
    char real_path[512];
    if (resolve_encoded_memfd_path(fd, real_path, sizeof(real_path))) {
        struct statfs real_sf;
        if (raw_statfs(real_path, &real_sf) == 0) {
            *sf = real_sf;
        } else {
            sf->f_type = PROC_SUPER_MAGIC;
        }
    }
    errno = saved_errno;
}
