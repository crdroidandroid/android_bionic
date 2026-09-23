/*-
 * Copyright (c) 1991, 1993
 *	The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#include <sys/types.h>
#include <sys/uio.h>

#include <errno.h>
#include <limits.h>
#include <paths.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <async_safe/log.h>

#include "custom_rom_hide.h"
#include "private/FdPath.h"
#include "private/__bionic_get_shell_path.h"

extern "C" char** environ;
extern "C" int __execve(const char*, char* const*, char* const*);

int execve(const char* name, char* const* argv, char* const* envp) {
  const bool propagate_privacy = custom_rom_hide_should_propagate();
  const bool propagate_adb = custom_rom_hide_should_propagate_adb();
  const bool propagate_selinux = custom_rom_hide_should_propagate_selinux_enforcing();
  if (!propagate_privacy && !propagate_adb && !propagate_selinux) {
    return __execve(name, argv, envp);
  }

  async_safe_format_log(ANDROID_LOG_INFO, "AxSandboxAudit",
                        "exec name=%s argv0=%s argv1=%s argv2=%s privacy=%d adb=%d selinux=%d",
                        name != nullptr ? name : "<null>",
                        argv != nullptr && argv[0] != nullptr ? argv[0] : "<null>",
                        argv != nullptr && argv[1] != nullptr ? argv[1] : "<null>",
                        argv != nullptr && argv[2] != nullptr ? argv[2] : "<null>",
                        propagate_privacy, propagate_adb, propagate_selinux);

  static char privacy_marker[] = "BIONIC_AX_SANDBOX_PRIVACY=1";
  static constexpr char privacy_prefix[] = "BIONIC_AX_SANDBOX_PRIVACY=";
  static char adb_marker[] = "BIONIC_AX_SANDBOX_ADB=1";
  static constexpr char adb_prefix[] = "BIONIC_AX_SANDBOX_ADB=";
  static char selinux_marker[] = "BIONIC_AX_SANDBOX_SELINUX_ENFORCING=1";
  static constexpr char selinux_prefix[] = "BIONIC_AX_SANDBOX_SELINUX_ENFORCING=";
  size_t env_count = 0;
  if (envp != nullptr) {
    while (envp[env_count] != nullptr) ++env_count;
  }

  char* inherited_env[env_count + 4];
  bool privacy_present = false;
  bool adb_present = false;
  bool selinux_present = false;
  size_t inherited_count = 0;
  for (size_t i = 0; i < env_count; ++i) {
    if (strncmp(envp[i], privacy_prefix, sizeof(privacy_prefix) - 1) == 0) {
      privacy_present = true;
      if (propagate_privacy) inherited_env[inherited_count++] = privacy_marker;
    } else if (strncmp(envp[i], adb_prefix, sizeof(adb_prefix) - 1) == 0) {
      adb_present = true;
      if (propagate_adb) inherited_env[inherited_count++] = adb_marker;
    } else if (strncmp(envp[i], selinux_prefix, sizeof(selinux_prefix) - 1) == 0) {
      selinux_present = true;
      if (propagate_selinux) inherited_env[inherited_count++] = selinux_marker;
    } else {
      inherited_env[inherited_count++] = envp[i];
    }
  }
  if (propagate_privacy && !privacy_present) inherited_env[inherited_count++] = privacy_marker;
  if (propagate_adb && !adb_present) inherited_env[inherited_count++] = adb_marker;
  if (propagate_selinux && !selinux_present) inherited_env[inherited_count++] = selinux_marker;
  inherited_env[inherited_count] = nullptr;
  return __execve(name, argv, inherited_env);
}

enum { ExecL, ExecLE, ExecLP };

template <int variant>
static int __execl(const char* name, const char* argv0, va_list ap) {
  // Count the arguments.
  va_list count_ap;
  va_copy(count_ap, ap);
  size_t n = 1;
  while (va_arg(count_ap, char*) != nullptr) {
    ++n;
  }
  va_end(count_ap);

  // Construct the new argv.
  char* argv[n + 1];
  argv[0] = const_cast<char*>(argv0);
  n = 1;
  while ((argv[n] = va_arg(ap, char*)) != nullptr) {
    ++n;
  }

  // Collect the argp too.
  char** argp = (variant == ExecLE) ? va_arg(ap, char**) : environ;

  va_end(ap);

  return (variant == ExecLP) ? execvp(name, argv) : execve(name, argv, argp);
}

int execl(const char* name, const char* arg, ...) {
  va_list ap;
  va_start(ap, arg);
  int result = __execl<ExecL>(name, arg, ap);
  va_end(ap);
  return result;
}

int execle(const char* name, const char* arg, ...) {
  va_list ap;
  va_start(ap, arg);
  int result = __execl<ExecLE>(name, arg, ap);
  va_end(ap);
  return result;
}

int execlp(const char* name, const char* arg, ...) {
  va_list ap;
  va_start(ap, arg);
  int result = __execl<ExecLP>(name, arg, ap);
  va_end(ap);
  return result;
}

int execv(const char* name, char* const* argv) {
  return execve(name, argv, environ);
}

int execvp(const char* name, char* const* argv) {
  return execvpe(name, argv, environ);
}

static int __exec_as_script(const char* buf, char* const* argv, char* const* envp) {
  size_t arg_count = 1;
  while (argv[arg_count] != nullptr) ++arg_count;

  const char* script_argv[arg_count + 2];
  script_argv[0] = "sh";
  script_argv[1] = buf;
  memcpy(script_argv + 2, argv + 1, arg_count * sizeof(char*));
  return execve(__bionic_get_shell_path(), const_cast<char**>(script_argv), envp);
}

int execvpe(const char* name, char* const* argv, char* const* envp) {
  // Do not allow null name.
  if (name == nullptr || *name == '\0') {
    errno = ENOENT;
    return -1;
  }

  // If it's an absolute or relative path name, it's easy.
  if (strchr(name, '/') && execve(name, argv, envp) == -1) {
    if (errno == ENOEXEC) return __exec_as_script(name, argv, envp);
    return -1;
  }

  // Get the path we're searching.
  const char* path = getenv("PATH");
  if (path == nullptr) path = _PATH_DEFPATH;

  // Make a writable copy.
  size_t len = strlen(path) + 1;
  char writable_path[len];
  memcpy(writable_path, path, len);

  bool saw_EACCES = false;

  // Try each element of $PATH in turn...
  char* strsep_buf = writable_path;
  const char* dir;
  while ((dir = strsep(&strsep_buf, ":"))) {
    // It's a shell path: double, leading and trailing colons
    // mean the current directory.
    if (*dir == '\0') dir = const_cast<char*>(".");

    size_t dir_len = strlen(dir);
    size_t name_len = strlen(name);

    char buf[dir_len + 1 + name_len + 1];
    mempcpy(mempcpy(mempcpy(buf, dir, dir_len), "/", 1), name, name_len + 1);

    execve(buf, argv, envp);
    switch (errno) {
    case EISDIR:
    case ELOOP:
    case ENAMETOOLONG:
    case ENOENT:
    case ENOTDIR:
      break;
    case ENOEXEC:
      return __exec_as_script(buf, argv, envp);
    case EACCES:
      saw_EACCES = true;
      break;
    default:
      return -1;
    }
  }
  if (saw_EACCES) errno = EACCES;
  return -1;
}

int fexecve(int fd, char* const* argv, char* const* envp) {
  // execveat with AT_EMPTY_PATH (>= 3.19) seems to offer no advantages.
  execve(FdPath(fd).c_str(), argv, envp);
  if (errno == ENOENT) errno = EBADF;
  return -1;
}
