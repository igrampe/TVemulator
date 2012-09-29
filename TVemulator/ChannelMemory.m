//
//  ChannelMemory.m
//  TVemulator
//
//  Created by Semen Belokovsky on 25.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import "ChannelMemory.h"

@implementation ChannelMemory

- (id)init
{
	self = [super init];
	if (self) {
		m_channels = [[NSMutableArray alloc] init];
		[m_channels addObject:[NSNumber numberWithFloat:50]];
	}
	return self;
}

- (void)dealloc
{
	[m_channels release];
	[super dealloc];
}

- (NSNumber *)frequencyByChannel:(NSNumber *)channel
{
	if ([channel intValue] < [m_channels count]) {
		return [m_channels objectAtIndex:[channel intValue]];
	}
	return nil;
}

- (void)setFrequency:(NSNumber *)frequency forChannel:(NSNumber *)channel
{
	if ([m_channels count] <= [channel intValue]) {
		for (int i = (int)[m_channels count]; i < [channel intValue]; i++) {
			[m_channels addObject:[NSNumber numberWithInt:0]];
		}
		[m_channels addObject:frequency];
	} else {
		[m_channels setObject:frequency atIndexedSubscript:[channel intValue]];
	}
}

- (void)reset
{
	[m_channels removeAllObjects];
}

@end
