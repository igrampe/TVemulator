//
//  ScreenView.m
//  TVemulator
//
//  Created by Semen Belokovsky on 25.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import "ScreenView.h"

@implementation ScreenView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		m_backgroundColor = [NSColor blackColor];
		m_image = nil;
		m_menuView = [[MenuView alloc] initWithFrame:CGRectMake(20, 50, frame.size.width - 40, 50)];
		[self addSubview:m_menuView];
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
	m_backgroundColor = [NSColor blackColor];
	[self setNeedsDisplay:YES];
}

- (void)updateScreen
{
	[self setNeedsDisplay:YES];
}

@end
