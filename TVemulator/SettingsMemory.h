//
//  SettingsMemory.h
//  TVemulator
//
//  Created by Semen Belokovsky on 25.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	kBrightness = 0,
	kContrast
} SettingsKey;

@interface SettingsMemory : NSObject {
	NSMutableDictionary *m_settings;
}

- (void)reset;
- (NSNumber *)settingsValueForKey:(SettingsKey)key;
- (void)setSettingsValue:(NSNumber *)value ForKey:(SettingsKey)key;

@end
