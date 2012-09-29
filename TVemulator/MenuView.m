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
		self.value = [NSNumber numberWithInt:100];
		self.title = nil;
	}
	return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor colorWithSRGBRed:0 green:0 blue:0 alpha:0.25] setFill];
	NSRectFill(dirtyRect);
	NSMutableDictionary * stringAttributes;
	stringAttributes = [NSMutableDictionary dictionary];
	[stringAttributes setObject:[NSFont fontWithName:@"Monaco" size:16] forKey:NSFontAttributeName];
	[stringAttributes setObject:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	[stringAttributes retain];
	[self.title drawAtPoint:NSMakePoint(50, dirtyRect.size.height - 20) withAttributes:stringAttributes];
	[stringAttributes release];
	[[NSColor yellowColor] setFill];
	float valueWith = (dirtyRect.size.width - 40) * ([self.value floatValue] / 100);
	NSRect valueRect = NSRectFromCGRect(CGRectMake(20, dirtyRect.size.height - 45, valueWith, 20));
	NSRectFill(valueRect);
}

@end