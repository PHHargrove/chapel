#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#if defined __APPLE__ || defined __MTA__
#include <sys/sysctl.h>
#endif
#if defined _AIX
#include <sys/systemcfg.h>
#endif
#include <sys/utsname.h>
#if defined __MTA__
#include <machine/runtime.h>
#endif
#include "chplrt.h"
#include "chpl_mem.h"
#include "chplsys.h"
#include "chpltasks.h"
#include "chplcomm.h"
#include "error.h"

#ifndef chplGetPageSize
#define chplGetPageSize() sysconf(_SC_PAGE_SIZE)
#endif

uint64_t chpl_bytesPerLocale(void) {
#ifdef NO_BYTES_PER_LOCALE
  chpl_internal_error("sorry- bytesPerLocale not supported on this platform");
  return 0;
#elif defined __APPLE__
  uint64_t membytes;
  size_t len = sizeof(membytes);
  if (sysctlbyname("hw.memsize", &membytes, &len, NULL, 0)) 
    chpl_internal_error("query of physical memory failed");
  return membytes;
#elif defined __MTA__
  int mib[2] = {CTL_HW, HW_PHYSMEM}, membytes;
  size_t len = sizeof(membytes);
  sysctl(mib, 2, &membytes, &len, NULL, 0);
  return membytes;
#elif defined _AIX
  return _system_configuration.physmem;
#elif defined __NetBSD__
  uint64_t membytes;
  size_t len = sizeof(membytes);
  if (sysctlbyname("hw.usermem", &membytes, &len, NULL, 0))
    chpl_internal_error("query of physical memory failed");
  return membytes;
#else
  long int numPages, pageSize;
  numPages = sysconf(_SC_PHYS_PAGES);
  if (numPages < 0)
    chpl_internal_error("query of physical memory failed");
  pageSize = chplGetPageSize();
  if (pageSize < 0)
    chpl_internal_error("query of physical memory failed");
  return (uint64_t)numPages * (uint64_t)pageSize;
#endif
}


int32_t chpl_coresPerLocale(void) {
#ifdef NO_CORES_PER_LOCALE
  return 1;
#elif defined __APPLE__
  uint64_t numcores = 0;
  size_t len = sizeof(numcores);
  if (sysctlbyname("hw.physicalcpu", &numcores, &len, NULL, 0))
    chpl_internal_error("query of number of cores failed");
#ifdef __BIG_ENDIAN__
  // On a PowerPC system, the number of cores is apparently stored in the most
  // significant 32 bits.
  numcores = numcores >> 32;
#endif
  return numcores;
#elif defined __MTA__
  int32_t numcores = mta_get_num_teams();
  return numcores;
#else
  int32_t numcores = (int32_t)sysconf(_SC_NPROCESSORS_ONLN);
  return numcores;
#endif
}


int32_t chpl_maxThreads(void) {
  int32_t comm_max = chpl_comm_getMaxThreads();
  int32_t threads_max = chpl_threads_getMaxThreads();

  if (comm_max == 0)
    return threads_max;
  else if (threads_max == 0)
    return comm_max;
  else
    return comm_max < threads_max ? comm_max : threads_max;
}


int32_t chpl_maxThreadsLimit(void) {
  int32_t comm_max = chpl_comm_maxThreadsLimit();
  int32_t threads_max = chpl_threads_maxThreadsLimit();

  if (comm_max == 0)
    return threads_max;
  else if (threads_max == 0)
    return comm_max;
  else
    return comm_max < threads_max ? comm_max : threads_max;
}


chpl_string chpl_localeName(void) {
  static char* namespace = NULL;
  static int namelen = 0;
  struct utsname utsinfo;
  int newnamelen;
  uname(&utsinfo);
  newnamelen = strlen(utsinfo.nodename)+1;
  if (newnamelen > namelen) {
    namelen = newnamelen;
    namespace = chpl_realloc(namespace, newnamelen, sizeof(char), 
                             CHPL_RT_MD_LOCALE_NAME_BUFFER, 0, NULL);
  }
  strcpy(namespace, utsinfo.nodename);
  return namespace;
}
