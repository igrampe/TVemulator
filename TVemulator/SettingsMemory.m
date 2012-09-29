//
//  SettingsMemory.m
//  TVemulator
//
//  Created by Semen Belokovsky on 25.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import "SettingsMemory.h"

@implementation SettingsMemory

- (id)init
{
	self = [super init];
	if (self) {
		m_settings = [[NSMutableDictionary alloc] init];
		[m_settings setValue:[NSNumber numberWithInt:50] forKey:[NSString stringWithFormat:@"%d",kBrightness]];
		[m_settings setValue:[NSNumber numberWithInt:25] forKey:[NSString stringWithFormat:@"%d",kContrast]];
	}
	return self;
}

- (void)dealloc
{
	[m_settings release];
	[super dealloc];
}

- (void)reset
{
	[m_settings setValue:[NSNumber numberWithInt:50] forKey:[NSString stringWithFormat:@"%d",kBrightness]];
	[m_settings setValue:[NSNumber numberWithInt:25] forKey:[NSString stringWithFormat:@"%d",kContrast]];
}

- (NSNumber *)settingsValueForKey:(SettingsKey)key
{
	return [m_settings valueForKey:[NSString stringWithFormat:@"%d",key]];
}

- (void)setSettingsValue:(NSNumber *)value ForKey:(SettingsKey)key
{
	[m_settings setValue:value forKey:[NSString stringWithFormat:@"%d",key]];
}

@end
