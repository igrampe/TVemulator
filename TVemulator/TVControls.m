//
//  TVControlsr.m
//  TVemulator
//
//  Created by Semen Belokovsky on 25.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import "TVControls.h"

@implementation TVControls

- (IBAction)buttonPressed:(id)sender
{
	TVControlsButtonKey buttonKey = 0;
	switch ([sender tag]) {
		case 0:
			buttonKey = kTVControlsButtonPower;
			break;
		case 1:
			buttonKey = kTVControlsButtonUp;
			break;
		case 2:
			buttonKey = kTVControlsButtonDown;
			break;
		case 3:
			buttonKey = kTVControlsButtonReset;
			break;
		default:
			break;
	}
	[self.delegate panelButtonWithKeyPressed:buttonKey];
}

@end
