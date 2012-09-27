//
//  ChannelMemory.h
//  TVemulator
//
//  Created by Semen Belokovsky on 25.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelMemory : NSObject {
	NSMutableArray *m_channels;
}

@property (nonatomic, retain) NSMutableArray *channels;

- (NSNumber *)frequencyByChannel:(NSNumber *)channel;
- (void)setFrequency:(NSNumber *)frequency forChannel:(NSNumber *)channel;
- (void)reset;

@end
