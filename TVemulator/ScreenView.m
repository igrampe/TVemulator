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
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [m_backgroundColor setFill];
    NSRectFill(dirtyRect);
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

@end
