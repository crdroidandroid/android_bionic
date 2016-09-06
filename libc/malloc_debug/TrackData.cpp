/*
 * Copyright (C) 2015 The Android Open Source Project
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

#include <pthread.h>
#include <stdint.h>
#include <stdlib.h>

#include <algorithm>
#include <vector>

#include <private/ScopedPthreadMutexLocker.h>

#include "backtrace.h"
#include "BacktraceData.h"
#include "Config.h"
#include "DebugData.h"
#include "debug_disable.h"
#include "debug_log.h"
#include "malloc_debug.h"
#include "TrackData.h"

TrackData::TrackData(DebugData* debug_data) : OptionData(debug_data) {
}

void TrackData::GetList(std::vector<const Header*>* list) {
  for (const auto& header : headers_) {
    list->push_back(header);
  }

  // Sort by the size of the allocation.
  std::sort(list->begin(), list->end(), [](const Header* a, const Header* b) {
    if (a->size == b->size) return a < b;
    return a->size > b->size;
  });
}

void TrackData::Add(const Header* header, bool backtrace_found) {
  pthread_mutex_lock(&mutex_);
  if (backtrace_found) {
    total_backtrace_allocs_++;
  }
  headers_.insert(header);
  pthread_mutex_unlock(&mutex_);
}

void TrackData::Remove(const Header* header, bool backtrace_found) {
  pthread_mutex_lock(&mutex_);
  headers_.erase(header);
  if (backtrace_found) {
    total_backtrace_allocs_--;
  }
  pthread_mutex_unlock(&mutex_);
}

bool TrackData::Contains(const Header* header) {
  pthread_mutex_lock(&mutex_);
  bool found = headers_.count(header);
  pthread_mutex_unlock(&mutex_);
  return found;
}

void TrackData::DisplayLeaks() {
  std::vector<const Header*> list;
  GetList(&list);

  size_t track_count = 0;
  for (const auto& header : list) {
    error_log("+++ %s leaked block of size %zu at %p (leak %zu of %zu)", getprogname(),
              header->real_size(), debug_->GetPointer(header), ++track_count, list.size());
    if (debug_->config().options & BACKTRACE) {
      BacktraceHeader* back_header = debug_->GetAllocBacktrace(header);
      if (back_header->num_frames > 0) {
        error_log("Backtrace at time of allocation:");
        backtrace_log(&back_header->frames[0], back_header->num_frames);
      }
    }
    g_dispatch->free(header->orig_pointer);
  }
}

void TrackData::GetInfo(uint8_t** info, size_t* overall_size, size_t* info_size,
                        size_t* total_memory, size_t* backtrace_size) {
  ScopedPthreadMutexLocker scoped(&mutex_);

  if (headers_.size() == 0 || total_backtrace_allocs_ == 0) {
    return;
  }

  *backtrace_size = debug_->config().backtrace_frames;
  *info_size = sizeof(size_t) * 2 + sizeof(uintptr_t) * *backtrace_size;
  *info = reinterpret_cast<uint8_t*>(g_dispatch->calloc(*info_size, total_backtrace_allocs_));
  if (*info == nullptr) {
    return;
  }
  *overall_size = *info_size * total_backtrace_allocs_;

  std::vector<const Header*> list;
  GetList(&list);

  uint8_t* data = *info;
  size_t num_allocations = 1;
  for (const auto& header : list) {
    BacktraceHeader* back_header = debug_->GetAllocBacktrace(header);
    if (back_header->num_frames > 0) {
      memcpy(data, &header->size, sizeof(size_t));
      memcpy(&data[sizeof(size_t)], &num_allocations, sizeof(size_t));
      memcpy(&data[2 * sizeof(size_t)], &back_header->frames[0],
            back_header->num_frames * sizeof(uintptr_t));

      *total_memory += header->real_size();

      data += *info_size;
    }
  }
}

// Leak Patch Begin
#include <errno.h>
#include <signal.h>
#include <sys/types.h>
#include <unistd.h>

#define DEBUG_SIGNAL        SIGWINCH
#define DEBUG_MAX_STACK     (30)
extern DebugData* g_debug;

struct LeakHeader {
  size_t size;
  size_t count;
  BacktraceHeader* back_header;
} __attribute__((packed));

LeakHeader* SearchLeakHeader(LeakHeader* list, BacktraceHeader* back_header, int records) {
  LeakHeader* leakHeader = list;

  //error_log("SearchLeakHeader list = %p, back_header = %p", list, back_header);
  //error_log("SearchLeakHeader num_frames = %zu, record = %d", back_header->num_frames, records);

  for (int i = 0; i < records; i++) {
    //error_log("SearchLeakHeader leakHeader = %p, back_header = %p, i = %d", leakHeader, leakHeader->back_header, i);
    //error_log("SearchLeakHeader num_frames = %zu", leakHeader->back_header->num_frames);

    if ((leakHeader->back_header->num_frames == back_header->num_frames) &&
        (!memcmp(leakHeader->back_header->frames, back_header->frames, back_header->num_frames * sizeof(uintptr_t)))) {
      // error_log("SearchLeakHeader leakHeader = %p", leakHeader);
      return leakHeader;
    }
    leakHeader ++;
  }

  return nullptr;
}

int CompareHeader( const void *a ,const void *b) {
  return (*(LeakHeader *)a).size > (*(LeakHeader *)b).size ? -1 : 1;
}

void TrackData::DumpLeaks(DebugData& debug) {
  ScopedDisableDebugCalls disable;

  if (headers_.size() == 0 || total_backtrace_allocs_ == 0) {
    return;
  }

  if (!(debug.config().options & BACKTRACE)) {
    return;
  }

  pthread_mutex_lock(&mutex_);

  int records = 0;
  int top = 0;
  size_t total_size = 0;
  BacktraceHeader* back_header;
  LeakHeader* list = static_cast<LeakHeader*>(g_dispatch->calloc(total_backtrace_allocs_, sizeof(LeakHeader)));
  LeakHeader* leakHeader = list;
  LeakHeader* findHeader = nullptr;

  error_log("+++ %s leaked memory dumping started +++", getprogname());
  //error_log("DumpLeaks list = %p, total_backtrace_allocs_ = %zu", list, total_backtrace_allocs_);

  for (const auto& header : headers_) {
    back_header = debug.GetAllocBacktrace(header);
    if(back_header->num_frames == 0) {
      continue;
	}

    findHeader = SearchLeakHeader(list, back_header, records);

    // error_log("findHeader = %p", findHeader);

    total_size += header->real_size();
    if (findHeader != nullptr) {
      findHeader->size += header->real_size();
      findHeader->count ++;
    } else {
       records ++;
       leakHeader->size = header->real_size();
       leakHeader->count = 1;
       leakHeader->back_header = back_header;
       leakHeader ++;
    }
  }

  //error_log("+++ %s leaked memory sorting started +++", getprogname());
  qsort(list, records, sizeof(LeakHeader), CompareHeader);
  //error_log("+++ %s leaked memory sorting ended +++", getprogname());

  leakHeader = list;

  if (records > DEBUG_MAX_STACK) {
    top = DEBUG_MAX_STACK;  // Only print DEBUG_MAX_STACK records.
  } else {
    top = records;
  }

  error_log("+++ total size: %d K, total records: %d, top records: %d +++", (int)(total_size / 1024), records, top);

  for (int i = 0; i < top; i++) {
      error_log("+++ Backtrace at time of allocation: total size %zu (leak times: %zu, avg size: %zu) +++",
                 leakHeader->size, leakHeader->count, leakHeader->size / leakHeader->count);
      //error_log("num_frames: %zu frames: %zu", leakHeader->back_header->num_frames, leakHeader->back_header->frames[0]);
      backtrace_log(&leakHeader->back_header->frames[0], leakHeader->back_header->num_frames);
      leakHeader ++;
  }

  error_log("+++ %s leaked memory dumping ended +++", getprogname());

  g_dispatch->free(list);

  pthread_mutex_unlock(&mutex_);
}

static void* PrintLeaks(void *arg) {
  //g_debug->track->DisplayLeaks(*g_debug);

  info_log("PrintLeaks::%s:%d backtrace printing. Thread = %s", getprogname(), getpid(), (char*)arg);

  g_debug->track->DumpLeaks(*g_debug);

  return nullptr;
}

static void PrintLeaksSignal(int, siginfo_t*, void*) {
  if (!(g_debug->config().options & BACKTRACE) || !(g_debug->config().options & LEAK_TRACK)) {
    error_log("PrintLeaksSignal::%s:%d backtrace hasn't been enabled.", getprogname(), getpid());
    return;
  }

  int err;
  pthread_t ntid;
  pthread_attr_t attributes;
  pthread_attr_init(&attributes);
  err = pthread_create(&ntid, &attributes, PrintLeaks, (void*)"PrintLeaks Thread");
  if (err != 0) {
    error_log("PrintLeaksSignal::%s:%d can't create PrintLeaks thread.", getprogname(), getpid());
  }
}

TrackData::TrackData() {
  error_log(" SIGWINCH handler registration");
  struct sigaction enable_act;
  memset(&enable_act, 0, sizeof(enable_act));

  enable_act.sa_sigaction = PrintLeaksSignal;
  enable_act.sa_flags = SA_RESTART | SA_SIGINFO | SA_ONSTACK;
  sigemptyset(&enable_act.sa_mask);
  if (sigaction(DEBUG_SIGNAL, &enable_act, nullptr) != 0) {
    error_log("Unable to set up memory leak signal function: %s", strerror(errno));
    return;
  }
  info_log("%s: Run: 'kill -28 <pid of process>' to print memory leak information.", getprogname());
}
// Leack Patch End
