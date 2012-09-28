//
//  SignalSource.m
//  TVemulator
//
//  Created by Semen Belokovsky on 25.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import "SignalSource.h"

@implementation SignalSource

- (id)init
{
	self = [super init];
	if (self) {
		m_data = [[NSMutableArray alloc] init];
		m_imageData = [[NSMutableArray alloc] init];
		[self readFrequencesInfoFromFile];
	}
	return self;
}

- (void)dealloc
{
	[m_data release];
	[m_imageData release];
	[super dealloc];
}

- (void)readFrequencesInfoFromFile
{
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"channels" ofType:@"txt"];
	NSString *dataString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	NSArray *channelsStrings = [dataString componentsSeparatedByString:@"\n"];
	for (int i = 0; i < [channelsStrings count]; i++) {
		NSString *channelString = [channelsStrings objectAtIndex:i];
		NSArray *channelAttributes = [channelString componentsSeparatedByString:@","];
		NSImage *image = [NSImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
		[image setSize:NSMakeSize(460, 257)];
		NSDictionary *dict = [NSDictionary dictionaryWithObjects:
							  [NSArray arrayWithObjects:
							   [NSNumber numberWithDouble:[(NSString *)[channelAttributes objectAtIndex:0] doubleValue]],
							   [NSNumber numberWithDouble:[(NSString *)[channelAttributes objectAtIndex:1] doubleValue]],
							   [channelAttributes objectAtIndex:2],
							   image,
							   nil]
														 forKeys:
							  [NSArray arrayWithObjects:
							   @"low",
							   @"high",
							   @"name",
							   @"image",
							   nil]];
		[m_data addObject:dict];
	}
}

- (NSImage *)signalByFrequency:(NSNumber *)frequency
{
	for (int i = 0; i < [m_data count]; i++) {
		NSDictionary *dict = [m_data objectAtIndex:i];
		if (([frequency doubleValue] <= [[dict objectForKey:@"high"] doubleValue]) &&
			([frequency doubleValue] >= [[dict objectForKey:@"low"] doubleValue])) {
			NSImage *image = [[m_data objectAtIndex:i] objectForKey:@"image"];
			return image;
		}
	}
	return nil;
}

- (NSNumber *)highFrequencyForChannel:(NSNumber *)channel
{
	if ([m_data count] > [channel intValue]) {
		NSNumber *frequency = [[m_data objectAtIndex:[channel intValue]] objectForKey:@"high"];
		return frequency;
	}
	return [NSNumber numberWithFloat:730];
}

- (NSNumber *)lowFrequencyForChannel:(NSNumber *)channel
{
	if ([m_data count] > [channel intValue]) {
		return [[m_data objectAtIndex:[channel intValue]] objectForKey:@"low"];
	}
	return nil;
}

@end
