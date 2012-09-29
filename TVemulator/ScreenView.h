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
#import <Quartz/Quartz.h>

@interface ScreenView : NSView {
	NSColor *m_backgroundColor;
	NSImage *m_image;
	MenuView *m_menuView;
	InputChannelView *m_inputChannelView;
	CIFilter *m_CIColorControls;
}

@property (nonatomic, retain) NSImage *image;
@property (nonatomic, retain) NSString *menuString;
@property (nonatomic, retain) NSNumber *menuValue;
@property (nonatomic, retain) NSNumber *inputChannel;
@property (nonatomic, assign) BOOL isIdle;
@property (nonatomic, assign) float brightness;
@property (nonatomic, assign) float contrast;

- (void)switchOn;
- (void)switchOff;

- (void)updateScreen;
- (void)showMenu;
- (void)hideMenu;
- (void)showInputChannel;
- (void)hideInputChannel;

@end
