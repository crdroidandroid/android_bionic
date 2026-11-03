/*
 * Copyright (C) 2008 The Android Open Source Project
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#include <errno.h>
#include <fcntl.h>
#include <stdarg.h>
#include <stdlib.h>
#include <unistd.h>

#include "private/bionic_fdtrack.h"
#include "private/bionic_fortify.h"
#include "custom_rom_hide.h"

extern "C" int __openat(int, const char*, int, int);

static inline int force_O_LARGEFILE(int flags) {
#if defined(__LP64__)
  return flags; // No need, and aarch64's strace gets confused.
#else
  return flags | O_LARGEFILE;
#endif
}

static inline bool needs_mode(int flags) {
  return ((flags & O_CREAT) == O_CREAT) || ((flags & O_TMPFILE) == O_TMPFILE);
}

static inline bool can_filter_open(int flags) {
  return (flags & O_ACCMODE) == O_RDONLY &&
         (flags & (O_CREAT | O_TRUNC | O_TMPFILE | O_PATH | O_DIRECTORY)) == 0;
}

static int filter_readonly_file(const char* path, int flags) {
  if (!path || path[0] != '/' || !can_filter_open(flags)) return -1;
  int fd = custom_rom_hide_filter_proc(path);
  if (fd < 0) fd = custom_rom_hide_filter_vintf(path);
  if (fd < 0) fd = custom_rom_hide_filter_sepolicy(path);
  // O_NOFOLLOW only concerns the last component: regular files such as /proc/cmdline are
  // substituted as usual, while a symlink such as /proc/mounts must still fail with ELOOP.
  if (fd >= 0 && (flags & O_NOFOLLOW) && custom_rom_hide_is_symlink(path)) {
    close(fd);
    return -1;
  }
  return fd;
}

static inline int finish_filtered(int filtered_fd, int flags) {
  if (filtered_fd >= 0 && (flags & O_CLOEXEC)) {
    fcntl(filtered_fd, F_SETFD, FD_CLOEXEC);
  }
  return filtered_fd;
}

int creat(const char* pathname, mode_t mode) {
  return open(pathname, O_CREAT | O_TRUNC | O_WRONLY, mode);
}
__strong_alias(creat64, creat);

int open(const char* pathname, int flags, ...) {
  mode_t mode = 0;

  if (needs_mode(flags)) {
    va_list args;
    va_start(args, flags);
    mode = static_cast<mode_t>(va_arg(args, int));
    va_end(args);
  }

  int filtered_fd = filter_readonly_file(pathname, flags);
  if (filtered_fd >= 0) return FDTRACK_CREATE(finish_filtered(filtered_fd, flags));

  if (custom_rom_hide_should_block(pathname)) {
    errno = ENOENT;
    return -1;
  }

  return FDTRACK_CREATE(__openat(AT_FDCWD, pathname, force_O_LARGEFILE(flags), mode));
}
__strong_alias(open64, open);

int __open_2(const char* pathname, int flags) {
  if (needs_mode(flags)) __fortify_fatal("open: called with O_CREAT/O_TMPFILE but no mode");
  int filtered_fd = filter_readonly_file(pathname, flags);
  if (filtered_fd >= 0) return FDTRACK_CREATE_NAME("open", finish_filtered(filtered_fd, flags));
  if (custom_rom_hide_should_block(pathname)) {
    errno = ENOENT;
    return -1;
  }
  return FDTRACK_CREATE_NAME("open", __openat(AT_FDCWD, pathname, force_O_LARGEFILE(flags), 0));
}

int openat(int fd, const char *pathname, int flags, ...) {
  mode_t mode = 0;

  if (needs_mode(flags)) {
    va_list args;
    va_start(args, flags);
    mode = static_cast<mode_t>(va_arg(args, int));
    va_end(args);
  }

  int filtered_fd = filter_readonly_file(pathname, flags);
  if (filtered_fd >= 0) return FDTRACK_CREATE_NAME("openat", finish_filtered(filtered_fd, flags));

  if (custom_rom_hide_should_block_at(fd, pathname)) {
    errno = ENOENT;
    return -1;
  }

  return FDTRACK_CREATE_NAME("openat", __openat(fd, pathname, force_O_LARGEFILE(flags), mode));
}
__strong_alias(openat64, openat);

int __openat_2(int fd, const char* pathname, int flags) {
  if (needs_mode(flags)) __fortify_fatal("open: called with O_CREAT/O_TMPFILE but no mode");
  int filtered_fd = filter_readonly_file(pathname, flags);
  if (filtered_fd >= 0) return FDTRACK_CREATE_NAME("openat", finish_filtered(filtered_fd, flags));
  if (custom_rom_hide_should_block_at(fd, pathname)) {
    errno = ENOENT;
    return -1;
  }
  return FDTRACK_CREATE_NAME("openat", __openat(fd, pathname, force_O_LARGEFILE(flags), 0));
}
