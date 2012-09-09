
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <sys/types.h>
#include <signal.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <sys/resource.h>

const char*  DIR_SETUP_CMD    = "/usr/local/bottlenose/scripts/setup-directory.sh sandbox";
const char*  DIR_TEARDOWN_CMD = "/usr/local/bottlenose/scripts/teardown-directory.sh sandbox";
const char*  GRADING_CMD      = "/usr/local/bottlenose/scripts/start-grading.sh";

const time_t TIME_LIMIT = 300;
const rlim_t MEM_LIMIT  = 768000000;   
const rlim_t PROC_LIMIT = 64;

void
run_in_sandbox(int uid, const char* key)
{
  chdir("sandbox");
  chroot(".");

  struct rlimit as_lim;
  as_lim.rlim_cur = MEM_LIMIT;
  as_lim.rlim_max = MEM_LIMIT;
  setrlimit(RLIMIT_AS, &as_lim);

  struct rlimit np_lim;
  np_lim.rlim_cur = PROC_LIMIT;
  np_lim.rlim_max = PROC_LIMIT;
  setrlimit(RLIMIT_NPROC, &np_lim);

  setreuid(uid, uid);
  
  chdir("/home/student");

  char tmp[256];
  snprintf(tmp, 256, "(%s %s) 2>&1", GRADING_CMD, key);
  system(tmp);
}

void
watchdog_process(pid_t pid)
{
  time_t start_time = time(0);
  int pid2;

  while (1) {
    sleep(2);

    time_t now = time(0);
    if (now > start_time + TIME_LIMIT) {
      printf("Sandbox process has taken too long.\n");
      printf("SIGKILL!\n");
      kill(pid, SIGKILL);
      sleep(1);
    }

    if ((pid2 = waitpid(pid, 0, WNOHANG))) {
      printf("Sandbox process (%d) terminated.\n", pid2);
      break;
    }
  }
}

int
main(int argc, char* argv[])
{
  if (argc < 3) {
    printf("Requires three arguments.");
    return 1;
  }

  const char* DIR = argv[1];
  int         UID = atoi(argv[2]);
  const char* KEY = argv[3];

  setlinebuf(stdout);
  setreuid(0, 0);

  chdir(DIR);
  system(DIR_SETUP_CMD);
 
  int pid;
  if ((pid = fork())) {
    watchdog_process(pid);
  }
  else {
    run_in_sandbox(UID, KEY);
    exit(0);
  }

  system(DIR_TEARDOWN_CMD);

  return 0;
}
