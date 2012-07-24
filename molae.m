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

#include "molae.h"

#import <Cocoa/Cocoa.h>
#include <CoreServices/CoreServices.h>

@interface molae : NSObject
{
	AEDesc *descPtr;
	BOOL eventIsOapp;
}

@end

@implementation molae

- (void)handleEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
#if DEBUG
	NSLog(@"%s %@", __func__, event);
#endif
	AEDisposeDesc(descPtr);
	AEDuplicateDesc([event aeDesc], descPtr);

	/* If event is oapp, there might be a followup event sent through the appleevent mach port */
	eventIsOapp = [event eventID] == kAEOpenApplication;
}

- (id)initWithDescPtr:(AEDesc*)ptr
{
	self = [super init];
	if (self)
	{
		NSAppleEventManager *manager = [NSAppleEventManager sharedAppleEventManager];

		descPtr = ptr;

		[manager setEventHandler:self andSelector:@selector(handleEvent:withReplyEvent:)
			forEventClass:kCoreEventClass andEventID:kAEOpenApplication];
		[manager setEventHandler:self andSelector:@selector(handleEvent:withReplyEvent:)
			forEventClass:kCoreEventClass andEventID:kAEOpenDocuments];
		[manager setEventHandler:self andSelector:@selector(handleEvent:withReplyEvent:)
			forEventClass:kCoreEventClass andEventID:kAEPrintDocuments];
		[manager setEventHandler:self andSelector:@selector(handleEvent:withReplyEvent:)
			forEventClass:kCoreEventClass andEventID:kAEOpenContents];
		[manager setEventHandler:self andSelector:@selector(handleEvent:withReplyEvent:)
			forEventClass:kInternetEventClass andEventID:kAEGetURL];
	}
	return self;
}

- (void)dealloc
{
	NSAppleEventManager *manager = [NSAppleEventManager sharedAppleEventManager];

	[manager removeEventHandlerForEventClass:kCoreEventClass andEventID:kAEOpenApplication];
	[manager removeEventHandlerForEventClass:kCoreEventClass andEventID:kAEOpenDocuments];
	[manager removeEventHandlerForEventClass:kCoreEventClass andEventID:kAEPrintDocuments];
	[manager removeEventHandlerForEventClass:kCoreEventClass andEventID:kAEOpenContents];

	[super dealloc];
}

- (void)grabEvent:(double)maxwait
{
	NSRunLoop *runloop = [NSRunLoop currentRunLoop];
	NSDate *limit = [NSDate dateWithTimeIntervalSinceNow:maxwait];

	do
	{
		/* NSApp enqueues the event */
		[NSApp nextEventMatchingMask:NSAnyEventMask untilDate:[NSDate distantPast] inMode:NSDefaultRunLoopMode dequeue:YES];
		/* NSRunloop dequeues it. */
		[runloop acceptInputForMode:NSDefaultRunLoopMode beforeDate:limit];
	} while ((descPtr->descriptorType == typeNull || eventIsOapp) && [limit compare:[NSDate date]] == NSOrderedDescending);
}

@end

int get_launch_appleevent(AEDesc *dst, double maxwait)
{
	int res = -1;
	NSAutoreleasePool *pool = nil;
	molae *m = nil;

	AEInitializeDesc(dst);

	@try
	{
		if (NSApplicationLoad())
		{
			pool = [[NSAutoreleasePool alloc] init];
			m = [[molae alloc] initWithDescPtr:dst];

			[m grabEvent:maxwait];
			res = 0;
		}
	}
	@catch (...)
	{
	}

	[m release];
	[pool release];
	return res;
}

