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

struct statx;

__BEGIN_DECLS

bool custom_rom_hide_is_app_process();

bool custom_rom_hide_should_block(const char* path);
bool custom_rom_hide_should_block_at(int dirfd, const char* path);
bool custom_rom_hide_should_filter_dirent(int dirfd, const char* name);

void custom_rom_hide_spoof_stat(const char* path, struct stat* sb);
void custom_rom_hide_spoof_statx(const char* path, struct statx* sx);

int custom_rom_hide_filter_vintf(const char* path);
int custom_rom_hide_filter_proc(const char* path);
int custom_rom_hide_filter_sepolicy(const char* path);

bool custom_rom_hide_should_spoof_prop(const char* name, char* value);
bool custom_rom_hide_should_hide_prop(const char* name);
const char* custom_rom_hide_get_prop_override(const char* name);

ssize_t custom_rom_hide_readlink_post(char* buf, size_t size, ssize_t ret);

__END_DECLS
