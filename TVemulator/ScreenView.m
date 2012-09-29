//
//  ScreenView.m
//  TVemulator
//
//  Created by Semen Belokovsky on 25.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import "ScreenView.h"

@implementation ScreenView

@synthesize image = m_image;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		m_backgroundColor = [NSColor blackColor];
		m_image = nil;
		m_menuView = [[MenuView alloc] initWithFrame:CGRectMake(20, 20, frame.size.width - 40, 50)];
		[self addSubview:m_menuView];
		[m_menuView setHidden:YES];
		m_inputChannelView = [[InputChannelView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 30, self.bounds.size.height - 40, 20, 20)];
		[self addSubview:m_inputChannelView];
		[m_inputChannelView setHidden:YES];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	if (m_image == nil) {
		[m_backgroundColor setFill];
		NSRectFill(dirtyRect);
	} else {
		[m_image drawInRect:dirtyRect fromRect:dirtyRect operation:NSCompositeSourceOver fraction:1.0];
	}
}

- (void)switchOn
{
	m_backgroundColor = [NSColor blueColor];
	[self setNeedsDisplay:YES];
}

- (void)switchOff
{
	m_image = nil;
	m_backgroundColor = [NSColor blackColor];
	[self setNeedsDisplay:YES];
}

- (void)updateScreen
{
	[self setNeedsDisplay:YES];
}

- (void)showMenu
{
	[m_menuView setHidden:NO];
}

- (void)hideMenu
{
	[m_menuView setHidden:YES];
}

- (void)showInputChannel
{
	[m_inputChannelView setHidden:NO];
}

- (void)hideInputChannel
{
	[m_inputChannelView setHidden:YES];
}

- (void)setMenuString:(NSString *)menuString
{
	_menuString = menuString;
	m_menuView.title = menuString;
}

- (void)setMenuValue:(NSNumber *)menuValue
{
	_menuValue = menuValue;
	m_menuView.value = menuValue;
}

- (void)setInputChannel:(NSNumber *)inputChannel
{
	_inputChannel = inputChannel;
	m_inputChannelView.channel = inputChannel;
}

- (void)setIsIdle:(BOOL)isIdle
{
	_isIdle = isIdle;
	m_inputChannelView.isIdle = isIdle;
}

@end
