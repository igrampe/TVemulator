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
	//m_sound = [NSSound soundNamed:@"MacStartUp"];
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
			[m_inputChannelTimer invalidate];
			m_inputChannel = m_currentChannel * 10 + key;
			self.screenView.inputChannel = [NSNumber numberWithInt:m_inputChannel];
			[self.screenView showInputChannel];
			m_state = kTVStateIdle;
			[self changeChannel:[NSNumber numberWithInt:m_inputChannel]];
			m_inputChannel = 0;
			m_inputChannelTimer = [NSTimer scheduledTimerWithTimeInterval:2
																   target:self
																 selector:@selector(hideInputChannel)
																 userInfo:nil
																  repeats:NO];
		} else {
			m_state = kTVStateSwitchChannel;
			m_inputChannel = key;
			self.screenView.inputChannel = [NSNumber numberWithInt:m_inputChannel];
			[self.screenView showInputChannel];
			m_inputChannelTimer = [NSTimer scheduledTimerWithTimeInterval:2
																   target:self
																 selector:@selector(changeChannelFromInput)
																 userInfo:nil
																  repeats:NO];
		}
	}
	if (key == kRemoteButtonMenu) {
		switch (m_state) {
			case kTVStateIdle:
				m_state = kTVStateBrightnessSetup;
				self.screenView.menuString = MBRIGHTNESS;
				self.screenView.menuValue = [self.settingsMemory settingsValueForKey:kBrightness];
				[self.screenView showMenu];
				[self.screenView updateScreen];
				m_menuTimer = [NSTimer scheduledTimerWithTimeInterval:5
															   target:self
															 selector:@selector(hideMenu)
															 userInfo:nil
															  repeats:NO];
				break;
			case kTVStateBrightnessSetup:
				self.screenView.menuString = MCONTRAST;
				self.screenView.menuValue = [self.settingsMemory settingsValueForKey:kContrast];
				[self.screenView updateScreen];
				[m_menuTimer invalidate];
				m_menuTimer = [NSTimer scheduledTimerWithTimeInterval:5
															   target:self
															 selector:@selector(hideMenu)
															 userInfo:nil
															  repeats:NO];
				break;
			case kTVStateContrastSetup:
				break;
			default:
				break;
		}
	}
	if (key == kRemoteButtonLeft) {
	
	}
	if (key == kRemoteButtonRight) {
		
	}
	if (key == kRemoteButtonProgramUp) {
		
	}
	if (key == kRemoteButtonProgramDown) {
		
	}
	if (key == kRemoteButtonVolumeUp) {
		
	}
	if (key == kRemoteButtonVolumeDown) {
		
	}
	
}

- (void)switchOn
{
	m_state = kTVStateOn;
	[self.screenView switchOn];
	
	[m_sound play];
	[self changeChannel:0];
	m_state = kTVStateIdle;
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
	self.screenView.image = nil;
	[self.screenView updateScreen];
	m_currentFrequency = [NSNumber numberWithFloat:0.0];
	for (int i = 0; i < 2; i++) {
		if ([m_currentFrequency floatValue] > 730) {
			break;
		}
		[self setupChannel:[NSNumber numberWithInt:i]];
	}
}

- (void)setupChannel:(NSNumber *)channel
{
	if (!m_signal && ([m_currentFrequency floatValue] < 730)) {
		m_currentFrequency = [NSNumber numberWithFloat:([m_currentFrequency floatValue] + 0.5)];
		m_signal = [self.signalSource signalByFrequency:m_currentFrequency];
		self.screenView.image = m_signal;
		[self.screenView updateScreen];
		[self performSelector:@selector(setupChannel:) withObject:channel afterDelay:1];
	} else {
		[self.channelMemory setFrequency:m_currentFrequency forChannel:channel];
	}
}

- (void)hideInputChannel
{
	[m_inputChannelTimer invalidate];
	[self.screenView hideInputChannel];
	[self.screenView updateScreen];
}

- (void)hideMenu
{
	[m_menuTimer invalidate];
	[self.screenView hideMenu];
	[self.screenView updateScreen];
}

- (void)changeChannel:(NSNumber *)channel
{
	m_currentChannel = [channel intValue];
	NSNumber *frequency = [self.channelMemory frequencyByChannel:[NSNumber numberWithInt:m_currentChannel]];
	self.screenView.image = [self.signalSource signalByFrequency:frequency];
	[self showScreen];
}

- (void)changeChannelFromInput
{
	m_currentChannel = m_inputChannel;
	NSNumber *frequency = [self.channelMemory frequencyByChannel:[NSNumber numberWithInt:m_currentChannel]];
	self.screenView.image = [self.signalSource signalByFrequency:frequency];
	[self showScreen];
}

- (void)showScreen
{
	m_state = kTVStateIdle;
	[self hideInputChannel];
	[self hideMenu];
	[self.screenView updateScreen];
}

@end
