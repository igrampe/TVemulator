//
//  MenuView.m
//  TVemulator
//
//  Created by Sema Belokovsky on 26.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView

- (id)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:(NSRect)frameRect];
	if (self) {
		m_titleView = [[NSTextView alloc] initWithFrame:CGRectMake(0, 0, frameRect.size.width, frameRect.size.height)];
	}
	return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor colorWithSRGBRed:0 green:0 blue:0 alpha:0.25] setFill];
	NSRectFill(dirtyRect);
	NSMutableDictionary * stringAttributes;
	stringAttributes = [NSMutableDictionary dictionary];
	[stringAttributes setObject:[NSFont fontWithName:@"Monaco" size:10] forKey:NSFontAttributeName];
	[stringAttributes setObject:[NSColor yellowColor] forKey:NSForegroundColorAttributeName];
	[stringAttributes retain];
	[@"Some string..." drawAtPoint:NSMakePoint(dirtyRect.size.width / 2 - 20, dirtyRect.size.height - 12) withAttributes:stringAttributes];
	[stringAttributes release];
}

@end