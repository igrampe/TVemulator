//
//  SignalSource.h
//  TVemulator
//
//  Created by Semen Belokovsky on 25.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignalSource : NSObject

- (NSImage *)signalByFrequency:(NSNumber *)frequency;

@end