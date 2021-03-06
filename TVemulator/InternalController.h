//
//  InternalController.h
//  TVemulator
//
//  Created by Semen Belokovsky on 25.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RemoteController.h"
#import "ScreenView.h"
#import "TVControls.h"

#import "ChannelMemory.h"
#import "SettingsMemory.h"
#import "SignalSource.h"

typedef enum {
	kTVStateOff = 0,
	kTVStateOn,
	kTVStateIdle,
	kTVStateChannelSetup,
	kTVStateBrightnessSetup,
	kTVStateContrastSetup,
	kTVStateVolumeSetup,
	kTVStateSwitchChannel
}TVSate;

@interface InternalController : NSObject <TVControlsDelegate, RemoteControllerDelegate> {
	TVSate m_state;
	int m_currentChannel;
	int m_inputChannel;
	NSSound *m_sound;
	NSTimer *m_menuTimer;
	NSTimer *m_inputChannelTimer;
	NSTimer *m_setupChannelTimer;
	float m_currentFrequency;
	NSImage *m_signal;
}

@property (nonatomic, retain) IBOutlet RemoteController *remoteController;
@property (nonatomic, retain) IBOutlet ScreenView *screenView;
@property (nonatomic, retain) IBOutlet TVControls *controls;

@property (nonatomic, retain) ChannelMemory *channelMemory;
@property (nonatomic, retain) SettingsMemory *settingsMemory;
@property (nonatomic, retain) SignalSource *signalSource;

- (void)start;

@end
