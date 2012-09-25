//
//  RemoteController.m
//  TVemulator
//
//  Created by Semen Belokovsky on 25.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import "RemoteController.h"

@implementation RemoteController

- (IBAction)buttonPressed:(id)sender
{
	NSLog(@"Button %@ with tag %ld pressed", [(NSButton *)sender title], [sender tag]);
	RemoteButtonKey buttonKey = 0;
	if ([sender tag] == 0) {
		buttonKey = [[(NSButton *)sender title] intValue];
	}
	if ([sender tag] == 1) {
		if ([[(NSButton *)sender title] isEqualToString:@"+"]) {
			buttonKey = kRemoteButtonProgramUp;
		} else {
			buttonKey = kRemoteButtonProgramDown;
		}
	}
	if ([sender tag] == 2) {
		if ([[(NSButton *)sender title] isEqualToString:@"+"]) {
			buttonKey = kRemoteButtonVolumeUp;
		} else {
			buttonKey = kRemoteButtonVolumeDown;
		}
	}
	if ([sender tag] == 3) {
		if ([[(NSButton *)sender title] isEqualToString:@"Menu"]) {
			buttonKey = kRemoteButtonMenu;
		}
		if ([[(NSButton *)sender title] isEqualToString:@"<"]) {
			buttonKey = kRemoteButtonLeft;
		}
		if ([[(NSButton *)sender title] isEqualToString:@">"]) {
			buttonKey = kRemoteButtonRight;
		}
	}
	[self.delegate remoteButtonWithKeyPressed:buttonKey];
}

@end
