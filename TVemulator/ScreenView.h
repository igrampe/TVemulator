//
//  ScreenView.h
//  TVemulator
//
//  Created by Semen Belokovsky on 25.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MenuView.h"

@interface ScreenView : NSView {
	NSColor *m_backgroundColor;
	NSImage *m_image;
	MenuView *m_menuView;
}

@property (nonatomic, retain) NSImage *image;

- (void)switchOn;
- (void)switchOff;

- (void)updateScreen;

@end
