//
//  InternalController.m
//  TVemulator
//
//  Created by Semen Belokovsky on 25.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import "InternalController.h"

@implementation InternalController

- (void)start
{
	self.channelMemory = [[ChannelMemory alloc] init];
	self.settingsMemory = [[SettingsMemory alloc] init];
	self.signalSource = [[SignalSource alloc] init];
	self.remoteController.delegate = self;
	self.controls.delegate = self;
	m_state = 0;
	m_currentChannel = 0;
	m_sound = [NSSound soundNamed:@"MacStartUp"];
}

- (void)dealloc
{
	self.channelMemory = nil;
	self.settingsMemory = nil;
	self.signalSource = nil;
	[super dealloc];
}

#pragma mark - TVControlsDelegate

- (void)panelButtonWithKeyPressed:(TVControlsButtonKey)key
{
	NSLog(@"TVControls button pressed with key %d",key);
	switch (key) {
		case kTVControlsButtonPower:
			if (m_state == kTVStateOff) {
				[self switchOn];
			} else {
				[self switchOff];
			}
			break;
		case kTVControlsButtonUp:
			break;
		case kTVControlsButtonDown:
			break;
		case kTVControlsButtonReset:
			[self reset];
			break;
		default:
			break;
	}
}

#pragma mark - RemoteControllerDelegate

- (void)remoteButtonWithKeyPressed:(RemoteButtonKey)key
{
	if (key <= kRemoteButton9) {
		if (m_state == kTVStateSwitchChannel) {
			m_inputChannel = m_currentChannel * 10 + key;
			m_state = kTVStateIdle;
			[self hideInputChannel];
		} else {
			m_state = kTVStateSwitchChannel;
			m_inputChannel = key;
			[self showInputChannel];
		}
	} else {
		
	}
}

- (void)switchOn
{
	m_state = kTVStateOn;
	[self.screenView switchOn];
	
	[m_sound play];
	[self changeChannel:0];
	[self showScreen];
}

- (void)switchOff
{
	[m_sound stop];
	m_state = kTVStateOff;
	[self.screenView switchOff];
}

- (void)reset
{
	m_state = kTVStateChannelSetup;
	[self.channelMemory reset];
	
}

- (void)showInputChannel
{
	
}

- (void)hideInputChannel
{
	
}

- (void)showMenu
{
	
}

- (void)hideMenu
{
	
}

- (void)changeChannel:(int)channel
{
	m_currentChannel = channel;
	self.screenView.image = [self.signalSource signalByFrequency:[self.channelMemory frequencyByChannel:m_currentChannel]];
	[self showScreen];
}

- (void)showScreen
{
	[self hideInputChannel];
	[self hideMenu];
	[self.screenView updateScreen];
}

@end
