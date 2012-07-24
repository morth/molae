
#include <CoreServices/CoreServices.h>

/*
 * Retrieve the initial Apple Event
 *
 * LSOpenApplication include an initialEvent parameter, usually used to
 * indicate that a file or URL should be opened on program launch.
 * Other LSOpen* function use the same parameter in similar ways.
 *
 * This function registers Apple Event handlers for the most common type of
 * events and uses NSApp and NSRunloop to check which one was received.
 *
 * PARAMETERS
 *
 *   dst        Target pointer for the received Apple Event. Will always
 *              be initialized using AEInitializeDesc, even on error.
 *
 *   maxwait    If the received event is an "Open Application", and maxwait
 *              is non-zero, wait the specified time in seconds for an
 *              asynchronous event. E.g. AppleScript's 
 *                tell application "X" to open "Y"
 *              requires this mode.
 *
 * RETURN VALUE
 *
 *   On success, 0 is returned and dst is filled with the given Apple Event.
 *   If no Apple Event was received a "Open Application" event is returned.
 *
 *   -1 is returned on error, usually indicating NSApplicationLoad() failed.
 *   Might also indicate a Objective-C exception was raised.
 * 
 */
int get_launch_appleevent(AEDesc *dst, double maxwait);

