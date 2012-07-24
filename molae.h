/* Copyright (c) 2012 Per Johansson, per at morth.org
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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

