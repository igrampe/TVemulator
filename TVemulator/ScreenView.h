//
//  ScreenView.h
//  TVemulator
//
//  Created by Semen Belokovsky on 25.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ScreenView : NSView {
	NSColor *m_backgroundColor;
}

- (void)switchOn;
- (void)switchOff;

@end
