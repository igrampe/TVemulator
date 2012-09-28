//
//  InputChannelView.h
//  TVemulator
//
//  Created by Semen Belokovsky on 27.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface InputChannelView : NSView

@property (nonatomic, retain) NSNumber *channel;
@property (nonatomic, assign) BOOL isIdle;

@end
