//
//  RemoteController.h
//  TVemulator
//
//  Created by Semen Belokovsky on 25.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
	kRemoteButton0 = 0,
	kRemoteButton1,
	kRemoteButton2,
	kRemoteButton3,
	kRemoteButton4,
	kRemoteButton5,
	kRemoteButton6,
	kRemoteButton7,
	kRemoteButton8,
	kRemoteButton9,
	kRemoteButtonProgramUp,
	kRemoteButtonProgramDown,
	kRemoteButtonVolumeUp,
	kRemoteButtonVolumeDown,
	kRemoteButtonMenu,
	kRemoteButtonLeft,
	kRemoteButtonRight,
} RemoteButtonKey;

@protocol RemoteControllerDelegate <NSObject>

- (void)remoteButtonWithKeyPressed:(RemoteButtonKey)key;

@end

@interface RemoteController : NSObject

@property (nonatomic, retain) IBOutlet NSPanel *panel;

@property (nonatomic, retain) IBOutlet NSButton *button0;
@property (nonatomic, retain) IBOutlet NSButton *button1;
@property (nonatomic, retain) IBOutlet NSButton *button2;
@property (nonatomic, retain) IBOutlet NSButton *button3;
@property (nonatomic, retain) IBOutlet NSButton *button4;
@property (nonatomic, retain) IBOutlet NSButton *button5;
@property (nonatomic, retain) IBOutlet NSButton *button6;
@property (nonatomic, retain) IBOutlet NSButton *button7;
@property (nonatomic, retain) IBOutlet NSButton *button8;
@property (nonatomic, retain) IBOutlet NSButton *button9;

@property (nonatomic, assign) id<RemoteControllerDelegate> delegate;

- (IBAction)buttonPressed:(id)sender;

@end
