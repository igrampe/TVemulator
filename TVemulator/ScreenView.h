//
//  ScreenView.h
//  TVemulator
//
//  Created by Semen Belokovsky on 25.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MenuView.h"
#import "InputChannelView.h"

@interface ScreenView : NSView {
	NSColor *m_backgroundColor;
	NSImage *m_image;
	MenuView *m_menuView;
	InputChannelView *m_inputChannelView;
}

@property (nonatomic, retain) NSImage *image;
@property (nonatomic, retain) NSString *menuString;
@property (nonatomic, retain) NSNumber *menuValue;
@property (nonatomic, retain) NSNumber *inputChannel;
@property (nonatomic, assign) BOOL isIdle;

- (void)switchOn;
- (void)switchOff;

- (void)updateScreen;
- (void)showMenu;
- (void)hideMenu;
- (void)showInputChannel;
- (void)hideInputChannel;

@end
