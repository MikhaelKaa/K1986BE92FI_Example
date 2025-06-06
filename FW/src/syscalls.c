#include <errno.h>
#include <sys/unistd.h>

int _kill(int pid, int sig) { 
    (void)pid; (void)sig;
    errno = ENOSYS;
    return -1; 
}

int _getpid(void) { 
    return 1; 
}

void _exit(int status) { 
    (void)status;
    while(1); 
}