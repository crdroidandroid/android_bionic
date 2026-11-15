/*
 * Copyright (C) 2013 The Android Open Source Project
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
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#include "custom_rom_hide.h"

extern "C" int __statx(int, const char*, int, unsigned, struct statx*);
#if defined(__LP64__)
extern "C" int __fstatat(int, const char*, struct stat*, int);
extern "C" int __fstat(int, struct stat*);
#else
extern "C" int __fstatat64(int, const char*, struct stat*, int);
extern "C" int __fstat64(int, struct stat*);
#endif

static int raw_fstatat(int dirfd, const char* path, struct stat* sb, int flags) {
#if defined(__LP64__)
  return __fstatat(dirfd, path, sb, flags);
#else
  return __fstatat64(dirfd, path, sb, flags);
#endif
}

int fstat(int fd, struct stat* sb) {
#if defined(__LP64__)
  int res = __fstat(fd, sb);
#else
  int res = __fstat64(fd, sb);
#endif
  if (res == 0) {
    custom_rom_hide_spoof_fd_stat(fd, sb);
  }
  return res;
}
__strong_alias(fstat64, fstat);

int fstatat(int dirfd, const char* path, struct stat* sb, int flags) {
  if (custom_rom_hide_should_block_at(dirfd, path)) {
    errno = ENOENT;
    return -1;
  }
  int res = raw_fstatat(dirfd, path, sb, flags);
  if (res == 0) {
    if ((flags & AT_EMPTY_PATH) && custom_rom_hide_is_empty_path(path)) {
      custom_rom_hide_spoof_fd_stat(dirfd, sb);
    } else {
      custom_rom_hide_spoof_stat(path, sb);
    }
  }
  return res;
}
__strong_alias(fstatat64, fstatat);

int stat(const char* path, struct stat* sb) {
  if (custom_rom_hide_should_block(path)) {
    errno = ENOENT;
    return -1;
  }
  int res = raw_fstatat(AT_FDCWD, path, sb, 0);
  if (res == 0) {
    custom_rom_hide_spoof_stat(path, sb);
  }
  return res;
}
__strong_alias(stat64, stat);

int statx(int dirfd, const char* path, int flags, unsigned mask, struct statx* buf) {
  if (custom_rom_hide_should_block_at(dirfd, path)) {
    errno = ENOENT;
    return -1;
  }
  int res = __statx(dirfd, path, flags, mask, buf);
  if (res == 0) {
    if ((flags & AT_EMPTY_PATH) && custom_rom_hide_is_empty_path(path)) {
      custom_rom_hide_spoof_fd_statx(dirfd, mask, buf);
    } else {
      custom_rom_hide_spoof_statx(path, buf);
    }
  }
  return res;
}
