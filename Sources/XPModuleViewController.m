/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * XAMPP Control - Controls XAMPP                                    *
 * Copyright (C) 2007-2009  Christian Speich <kleinweby@kleinweby.de>*
 *                                                                   *
 * XAMPP Control comes with ABSOLUTELY NO WARRANTY; This is free     * 
 * software, and you are welcome to redistribute it under certain    *
 * conditions; see COPYING for details.                              *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "XPModuleViewController.h"
#import "StatusView.h"
#import "StatusIndicatorView.h"
#import "XPModule.h"
#import "XPModuleErrorWindow.h"

@interface XPModuleViewController (PRIVATE)

- (void) updateActionButton;

@end


@implementation XPModuleViewController

- (id) initWithModule:(XPModule*) aModule
{
	NSParameterAssert(aModule != Nil);
	
	self = [self init];
	if (self != nil) {
		module = [aModule retain];
		
		if (![NSBundle loadNibNamed:@"ModuleView" owner:self]) {
			[self release];
			return nil;
		}
		
		[module addObserver:self forKeyPath:@"status" options:Nil context:NULL];
		[self observeValueForKeyPath:@"status" ofObject:module change:Nil context:NULL];
		[nameField setStringValue:[module name]];
	}
	return self;
}

- (void) dealloc
{
	[module release];
	
	[super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (module == object && [keyPath isEqualToString:@"status"]) {
		// Update status
		
		switch ([module status]) {
			case XPNotRunning:
				[actionButton setTitle:NSLocalizedString(@"Start", @"Start a Module")];
				[actionButton setEnabled:YES];
				[statusIndicator setStatus:RedStatus];
				break;
			case XPRunning:
				[actionButton setTitle:NSLocalizedString(@"Stop", @"Stop a Module")];
				[actionButton setEnabled:YES];
				[statusIndicator setStatus:GreenStatus];
				break;
			case XPStarting:
			case XPStopping:
				[actionButton setEnabled:NO];
				[statusIndicator setStatus:WorkingStatus];
				break;
			default:
				[actionButton setEnabled:NO];
				[statusIndicator setStatus:UnknownStatus];
				break;
		}
	}
}

- (IBAction) action:(id)sender
{
	switch ([module status]) {
		case XPNotRunning:
			[self start:sender];
			break;
		case XPRunning:
			[self stop:sender];
			break;
		default:
			break;
	}
}

- (IBAction) reload:(id)sender
{
	[NSThread detachNewThreadSelector:@selector(doReload) 
							 toTarget:self 
						   withObject:Nil];
}

- (void) doReload
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSError *error;
	
	error = [module reload];
	
	if (error)
		[NSApp presentError:error];
	
	[pool release];
}

- (IBAction) start:(id)sender
{
	[NSThread detachNewThreadSelector:@selector(doStart) 
							 toTarget:self 
						   withObject:Nil];
}

- (void) doStart
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSError *error;
	
	error = [module start];
	
	if (error)
		[XPModuleErrorWindow presentError:error];
	
	[pool release];
}

- (IBAction) stop:(id)sender
{
	[NSThread detachNewThreadSelector:@selector(doStop) 
							 toTarget:self 
						   withObject:Nil];
}

- (void) doStop
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSError *error;
	
	error = [module stop];
	
	if (error)
		[NSApp presentError:error];
	
	[pool release];
}

@end

