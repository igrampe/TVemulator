//
//  InputChannelView.m
//  TVemulator
//
//  Created by Semen Belokovsky on 27.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import "InputChannelView.h"

@implementation InputChannelView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		_isIdle = NO;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor blackColor] setFill];
	NSRectFill(dirtyRect);
    NSMutableDictionary * stringAttributes;
	stringAttributes = [NSMutableDictionary dictionary];
	[stringAttributes setObject:[NSFont fontWithName:@"Monaco" size:16] forKey:NSFontAttributeName];
	[stringAttributes setObject:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	[stringAttributes retain];
	NSString *channelString = nil;
	if ([self.channel intValue] < 10) {
		if (_isIdle) {
			channelString = [NSString stringWithFormat:@"0%d",[self.channel intValue]];
		} else {
			channelString = [NSString stringWithFormat:@"%d-",[self.channel intValue]];
		}
	} else {
		channelString = [NSString stringWithFormat:@"%d",[self.channel intValue]];
	}
	[channelString drawAtPoint:NSMakePoint(0,0) withAttributes:stringAttributes];
	[stringAttributes release];
}

@end
