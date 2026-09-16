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

#pragma once

#include <sys/cdefs.h>
#include <stdbool.h>
#include <sys/stat.h>

struct statfs;
struct statx;

__BEGIN_DECLS

void custom_rom_hide_set_enabled(bool enabled);
bool custom_rom_hide_is_enabled();
void custom_rom_hide_set_adb_enabled(bool enabled);
bool custom_rom_hide_is_adb_enabled();
void custom_rom_hide_set_selinux_enforcing_enabled(bool enabled);
bool custom_rom_hide_is_selinux_enforcing_enabled();
bool custom_rom_hide_is_app_process();

bool custom_rom_hide_should_block(const char* path);
bool custom_rom_hide_should_block_at(int dirfd, const char* path);
bool custom_rom_hide_should_filter_dirent(int dirfd, const char* name);
__LIBC_HIDDEN__ int custom_rom_hide_filter_faccessat_syscall(int dirfd, const char* path);

void custom_rom_hide_spoof_stat(const char* path, struct stat* sb);
void custom_rom_hide_spoof_statx(const char* path, struct statx* sx);
void custom_rom_hide_spoof_fd_stat(int fd, struct stat* sb);
void custom_rom_hide_spoof_fd_statx(int fd, unsigned mask, struct statx* sx);
void custom_rom_hide_spoof_fd_statfs(int fd, struct statfs* sf);
void custom_rom_hide_unregister_fd(int fd);
void custom_rom_hide_transfer_fd(int old_fd, int new_fd);

int custom_rom_hide_filter_vintf(const char* path);
int custom_rom_hide_filter_proc(const char* path);
int custom_rom_hide_filter_sepolicy(const char* path);
int custom_rom_hide_filter_selinux_enforce_at(int dirfd, const char* path, int flags);

bool custom_rom_hide_should_propagate_selinux_enforcing();
bool custom_rom_hide_should_propagate_adb();
bool custom_rom_hide_should_propagate();

bool custom_rom_hide_should_spoof_prop(const char* name, char* value);
bool custom_rom_hide_should_hide_prop(const char* name);
const char* custom_rom_hide_get_prop_override(const char* name);

ssize_t custom_rom_hide_readlink_post(char* buf, size_t size, ssize_t ret);

__END_DECLS
