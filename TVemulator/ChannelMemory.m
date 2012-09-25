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
	}
	return self;
}

- (void)dealloc
{
	[m_channels release];
	[super dealloc];
}

- (NSNumber *)frequencyByChannel:(int)channel
{
	return [m_channels objectAtIndex:channel];
}

- (void)setFrequency:(NSNumber *)frequency forChannel:(int)channel
{
	[m_channels setObject:frequency atIndexedSubscript:channel];
}

- (void)reset
{
	for (NSNumber *i in m_channels) {
		i = [NSNumber numberWithInt:0];
	}
}

@end
