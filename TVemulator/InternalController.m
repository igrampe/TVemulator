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
			m_state = kTVStateIdle;
			self.screenView.isIdle = YES;
			[m_inputChannelTimer invalidate];
			m_inputChannelTimer = nil;
			m_inputChannel = m_inputChannel*10 + key;
			if (m_inputChannel > 60) {
				m_inputChannel = 60;
			}
			self.screenView.inputChannel = [NSNumber numberWithInt:m_inputChannel];
			[self.screenView showInputChannel];
			[self changeChannel:[NSNumber numberWithInt:m_inputChannel]];
			m_inputChannel = 0;
			m_inputChannelTimer = [NSTimer scheduledTimerWithTimeInterval:2
																   target:self
																 selector:@selector(hideInputChannel)
																 userInfo:nil
																  repeats:NO];
		} else {
			if (m_state == kTVStateIdle) {
				m_state = kTVStateSwitchChannel;
				self.screenView.isIdle = NO;
				[self hideInputChannel];
				[m_inputChannelTimer invalidate];
				m_inputChannelTimer = nil;
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
				m_menuTimer = nil;
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
		switch (m_state) {
			case kTVStateBrightnessSetup: {
				[m_menuTimer invalidate];
				m_menuTimer = nil;
				NSNumber *brightness = [self.settingsMemory settingsValueForKey:kBrightness];
				if ([brightness integerValue] > 0) {
					brightness = [NSNumber numberWithInt:[brightness intValue] - 10];
					[self.settingsMemory setSettingsValue:brightness ForKey:kBrightness];
				}
				self.screenView.menuValue = brightness;
				[self.screenView updateScreen];
				m_menuTimer = [NSTimer scheduledTimerWithTimeInterval:5
															   target:self
															 selector:@selector(hideMenu)
															 userInfo:nil
															  repeats:NO];
			}
				break;
			case kTVStateContrastSetup: {
				[m_menuTimer invalidate];
				m_menuTimer = nil;
				NSNumber *contrast = [self.settingsMemory settingsValueForKey:kContrast];
				if ([contrast integerValue] > 0) {
					contrast = [NSNumber numberWithInt:[contrast intValue] - 10];
					[self.settingsMemory setSettingsValue:contrast ForKey:kContrast];
				}
				self.screenView.menuValue = contrast;
				[self.screenView updateScreen];
				m_menuTimer = [NSTimer scheduledTimerWithTimeInterval:5
															   target:self
															 selector:@selector(hideMenu)
															 userInfo:nil
															  repeats:NO];
			}
				break;
			default:
				break;
		}
	}
	if (key == kRemoteButtonRight) {
		switch (m_state) {
			case kTVStateBrightnessSetup: {
				[m_menuTimer invalidate];
				m_menuTimer = nil;
				NSNumber *brightness = [self.settingsMemory settingsValueForKey:kBrightness];
				if ([brightness integerValue] < 100) {
					brightness = [NSNumber numberWithInt:[brightness intValue] + 10];
					[self.settingsMemory setSettingsValue:brightness ForKey:kBrightness];
				}
				self.screenView.menuValue = brightness;
				[self.screenView updateScreen];
				m_menuTimer = [NSTimer scheduledTimerWithTimeInterval:5
															   target:self
															 selector:@selector(hideMenu)
															 userInfo:nil
															  repeats:NO];
			}
				break;
			case kTVStateContrastSetup: {
				[m_menuTimer invalidate];
				m_menuTimer = nil;
				NSNumber *contrast = [self.settingsMemory settingsValueForKey:kContrast];
				if ([contrast integerValue] < 100) {
					contrast = [NSNumber numberWithInt:[contrast intValue] + 10];
					[self.settingsMemory setSettingsValue:contrast ForKey:kContrast];
				}
				self.screenView.menuValue = contrast;
				[self.screenView updateScreen];
				m_menuTimer = [NSTimer scheduledTimerWithTimeInterval:5
															   target:self
															 selector:@selector(hideMenu)
															 userInfo:nil
															  repeats:NO];
			}
				break;
			default:
				break;
		}
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
		m_signal = nil;
		if ([m_currentFrequency floatValue] > 730) {
			break;
		}
		[self performSelectorOnMainThread:@selector(setupChannel:) withObject:[NSNumber numberWithInt:i] waitUntilDone:YES];
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
		m_currentFrequency = [NSNumber numberWithFloat:
							  ([[self.signalSource highFrequencyForChannel:channel] floatValue] + 0.5)];
	}
}

- (void)hideInputChannel
{
	m_inputChannel = 0;
	[m_inputChannelTimer invalidate];
	m_inputChannelTimer = nil;
	[self.screenView hideInputChannel];
	[self.screenView updateScreen];
}

- (void)hideMenu
{
	m_state = kTVStateIdle;
	[m_menuTimer invalidate];
	m_menuTimer = nil;
	[self.screenView hideMenu];
	[self.screenView updateScreen];
}

- (void)changeChannel:(NSNumber *)channel
{
	m_state = kTVStateIdle;
	m_currentChannel = [channel intValue];
	NSNumber *frequency = [self.channelMemory frequencyByChannel:[NSNumber numberWithInt:m_currentChannel]];
	self.screenView.image = [self.signalSource signalByFrequency:frequency];
	[self.screenView updateScreen];
}

- (void)changeChannelFromInput
{
	m_currentChannel = m_inputChannel;
	NSNumber *frequency = [self.channelMemory frequencyByChannel:[NSNumber numberWithInt:m_currentChannel]];
	self.screenView.image = [self.signalSource signalByFrequency:frequency];
	m_state = kTVStateIdle;
	self.screenView.isIdle = YES;
	[self.screenView updateScreen];
	m_inputChannelTimer = [NSTimer scheduledTimerWithTimeInterval:2
														   target:self
														 selector:@selector(hideInputChannel)
														 userInfo:nil
														  repeats:NO];
}

- (void)showScreen
{
	m_state = kTVStateIdle;
	[self hideInputChannel];
	[self hideMenu];
	[self.screenView updateScreen];
}

@end
