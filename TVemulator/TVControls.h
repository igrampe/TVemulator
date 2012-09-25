//
//  TVControls.h
//  TVemulator
//
//  Created by Semen Belokovsky on 25.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	kTVControlsButtonPower = 0,
	kTVControlsButtonUp,
	kTVControlsButtonDown,
	kTVControlsButtonReset
} TVControlsButtonKey;

@protocol TVControlsDelegate <NSObject>

- (void)panelButtonWithKeyPressed:(TVControlsButtonKey)key;

@end

@interface TVControls : NSObject

@property (nonatomic, retain) IBOutlet NSButton *powerButton;
@property (nonatomic, retain) IBOutlet NSButton *upButton;
@property (nonatomic, retain) IBOutlet NSButton *downButton;
@property (nonatomic, retain) IBOutlet NSButton *resetButton;

@property (nonatomic, assign) id<TVControlsDelegate> delegate;

- (IBAction)buttonPressed:(id)sender;

@end
