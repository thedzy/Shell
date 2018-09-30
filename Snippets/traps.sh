#!/bin/sh

## SIGNALS
# SIGABRT: 		The SIGABRT and SIGIOT signal is sent to a process to tell it to abort, i.e. to terminate. 
# SIGALRM: 		The SIGALRM, SIGVTALRM and SIGPROF signal is sent to a process when the time limit specified in a call to a preceding alarm setting function (such as setitimer) elapses.
# SIGBUS: 		The SIGBUS signal is sent to a process when it causes a bus error.
# SIGCHLD: 		The SIGCHLD signal is sent to a process when a child process terminates, is interrupted, or resumes after being interrupted. 
# SIGCONT: 		The SIGCONT signal instructs the operating system to continue (restart) a process previously paused by the SIGSTOP or SIGTSTP signal. 
# SIGEMT:		The SIGEMT signal is sent to a process when an emulator trap occurs.
# SIGFPE:		The SIGFPE signal is sent to a process when it executes an erroneous arithmetic operation, such as division by zero (the name "FPE", standing for floating-point exception, is a misnomer as the signal covers integer-arithmetic errors as well).
# SIGHUP: 		The SIGHUP signal is sent to a process when its controlling terminal is closed. It was originally designed to notify the process of a serial line drop (a hangup).
# SIGILL:		The SIGILL signal is sent to a process when it attempts to execute an illegal, malformed, unknown, or privileged instruction.
# SIGINFO:		The SIGINFO signal is sent to a process when a status (info) request is received from the controlling terminal.
# SIGINT: 		The SIGINT signal is sent to a process by its controlling terminal when a user wishes to interrupt the process. 
# SIGIO:		The SIGABRT and SIGIOT signal is sent to a process to tell it to abort, i.e. to terminate.
# SIGKILL:		The SIGKILL signal is sent to a process to cause it to terminate immediately (kill). In contrast to SIGTERM and SIGINT, this signal cannot be caught or ignored, and the receiving process cannot perform any clean-up upon receiving this signal. 
# SIGPIPE:		The SIGPIPE signal is sent to a process when it attempts to write to a pipe without a process connected to the other end.
# SIGPROF:		The SIGALRM, SIGVTALRM and SIGPROF signal is sent to a process when the time limit specified in a call to a preceding alarm setting function (such as setitimer) elapses. SIGALRM is sent when real or clock time elapses.
# SIGQUIT:		The SIGQUIT signal is sent to a process by its controlling terminal when the user requests that the process quit and perform a core dump.
# SIGSEGV:		The SIGSEGV signal is sent to a process when it makes an invalid virtual memory reference, or segmentation fault, i.e. when it performs a segmentation violation.
# SIGSTOP:		The SIGSTOP signal instructs the operating system to stop a process for later resumption.
# SIGSYS:		The SIGSYS signal is sent to a process when it passes a bad argument to a system call. 
# SIGTERM:		The SIGTERM signal is sent to a process to request its termination. 
# SIGTRAP:		The SIGTRAP signal is sent to a process when an exception (or trap) occurs: a condition that a debugger has requested to be informed of — for example, when a particular function is executed, or when a particular variable changes value.
# SIGTSTP:		The SIGTSTP signal is sent to a process by its controlling terminal to request it to stop (terminal stop).
# SIGTTIN:		The SIGTTIN and SIGTTOU signals are sent to a process when it attempts to read in or write out respectively from the tty while in the background. 
# SIGTTOU:		The SIGTTIN and SIGTTOU signals are sent to a process when it attempts to read in or write out respectively from the tty while in the background. 
# SIGURG:		The SIGURG signal is sent to a process when a socket has urgent or out-of-band data available to read.
# SIGUSR1:		The SIGUSR1 and SIGUSR2 signals are sent to a process to indicate user-defined conditions.
# SIGUSR2:		The SIGUSR1 and SIGUSR2 signals are sent to a process to indicate user-defined conditions.
# SIGVTALRM:	The SIGALRM, SIGVTALRM and SIGPROF signal is sent to a process when the time limit specified in a call to a preceding alarm setting function (such as setitimer) elapses. SIGALRM is sent when real or clock time elapses.		
# SIGWINCH:		The SIGWINCH signal is sent to a process when its controlling terminal changes its size (a window change).
# SIGXCPU:		The SIGXCPU signal is sent to a process when it has used up the CPU for a duration that exceeds a certain predetermined user-settable value.
# SIGXFSZ:		The SIGXFSZ signal is sent to a process when it grows a file that exceeds than the maximum allowed size.
# See: https://en.wikipedia.org/wiki/Signal_(IPC)



# Signal interupt
trap_sigint (){
	printf "\tInterupt Called: $1\n"
	exit $1
}
trap 'trap_sigint $?' SIGINT


# Signal interupt alt
trap_interupt () {
	printf "\tInterupt Called: $1\n"
	exit $1
}
trap 'trap_interupt $?' INT

# Signal interupt by code
trap_interupt () {
	printf "\tInterupt Called: $1\n"
	exit $1
}
trap 'trap_interupt $?' 2


# Exit
trap_exit (){
	printf "\tProgram Exited with $1\n"
	exit $1
}
trap 'trap_exit $?' EXIT


# Killed
trap_kill (){
	printf "\tProgram killed with $1"
	exit $1
}
trap 'trap_kill $?' SIGKILL


# Error
trap_error () {
	printf "\tError $1\n"
}
trap 'trap_error ${LINENO} ${?}' ERR


# Window Resize
trap_resize(){
	printf "\tWindow resized\n"
}
trap 'trap_resize' WINCH


# Everytime before a line is run
trap_debug(){
	printf "\tDebug\n"
}
trap 'trap_debug' DEBUG


# Should trap when returning from a dor (.) or source file.
# Note: Not had success
trap_return(){
	printf "\tReturn from source\n"
}
trap 'trap_return' RETURN



###########################
# Examples
###########################

# Combining traps
trap_break () {
	printf "\tProgram termination: $1\n"
	exit $1
}
trap 'trap_break $?' INT EXIT TERM


# Trap error and display where the error occured and what the error number was
trap_error () {
	# Error trapping
	local ERRLNE="$1"
	local ERRNUM="$2"
	local ERRCMD=$(sed -n -e  "$1  p" "$0")
	local ERRDAT=$(date +"%Y.%m.%d %H.%M.%S")
	
	#Output err to screen and line
	printf "$ERRDAT Error: $ERRNUM on line $ERRLNE: $ERRCMD\n"
}
trap 'trap_error ${LINENO} ${?}' ERR


# Exit if any error occurs
trap_error () {
	exit $1
}
trap 'trap_error ${LINENO} ${?}' ERR


# Do not send an exit, preventing early termination, extreme cases
trap_exit () {
	printf "\tProgram termination: $1\n"
	exit $1
}
trap 'trap_exit $?' INT TERM




