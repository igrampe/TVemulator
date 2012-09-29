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
			if (m_state != kTVStateOff) {
				[m_menuTimer invalidate];
				m_menuTimer = nil;
				[m_inputChannelTimer invalidate];
				m_inputChannelTimer = nil;
				[m_setupChannelTimer invalidate];
				m_setupChannelTimer = nil;
				m_currentChannel = m_currentChannel + 1;
				if (m_currentChannel > 60) {
					m_currentChannel = 0;
				}
				[self.screenView hideMenu];
				self.screenView.isIdle = YES;
				self.screenView.inputChannel = [NSNumber numberWithInt:m_currentChannel];
				[self.screenView showInputChannel];
				[self changeChannel:[NSNumber numberWithInt:m_currentChannel]];
				[self.screenView updateScreen];
				m_inputChannelTimer = [NSTimer scheduledTimerWithTimeInterval:2
																	   target:self
																	 selector:@selector(hideInputChannel)
																	 userInfo:nil
																	  repeats:NO];
			}
			break;
		case kTVControlsButtonDown:
			if (m_state != kTVStateOff) {
				[m_menuTimer invalidate];
				m_menuTimer = nil;
				[m_inputChannelTimer invalidate];
				m_inputChannelTimer = nil;
				[m_setupChannelTimer invalidate];
				m_setupChannelTimer = nil;
				m_currentChannel = m_currentChannel - 1;
				if (m_currentChannel < 0) {
					m_currentChannel = 60;
				}
				[self.screenView hideMenu];
				self.screenView.isIdle = YES;
				self.screenView.inputChannel = [NSNumber numberWithInt:m_currentChannel];
				[self.screenView showInputChannel];
				[self changeChannel:[NSNumber numberWithInt:m_currentChannel]];
				[self.screenView updateScreen];
				m_inputChannelTimer = [NSTimer scheduledTimerWithTimeInterval:2
																	   target:self
																	 selector:@selector(hideInputChannel)
																	 userInfo:nil
																	  repeats:NO];
			}
			break;
		case kTVControlsButtonReset:
			if (m_state != kTVStateOff) {
				[self reset];
			}
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
			if (m_state == kTVStateIdle ||
				m_state == kTVStateBrightnessSetup ||
				m_state == kTVStateContrastSetup ||
				m_state == kTVStateVolumeSetup) {
				
				[self hideMenu];
				[m_menuTimer invalidate];
				m_menuTimer = nil;
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
				m_state = kTVStateContrastSetup;
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
				m_state = kTVStateIdle;
				[self hideMenu];
				break;
			case kTVStateVolumeSetup:
				[m_menuTimer invalidate];
				m_menuTimer = nil;
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
					brightness = [NSNumber numberWithInt:[brightness intValue] - 5];
					[self.settingsMemory setSettingsValue:brightness ForKey:kBrightness];
				}
				self.screenView.menuValue = brightness;
				[self.screenView setBrightness:[brightness floatValue]];
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
					contrast = [NSNumber numberWithInt:[contrast intValue] - 5];
					[self.settingsMemory setSettingsValue:contrast ForKey:kContrast];
				}
				self.screenView.menuValue = contrast;
				[self.screenView setContrast:[contrast floatValue]];
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
					brightness = [NSNumber numberWithInt:[brightness intValue] + 5];
					[self.settingsMemory setSettingsValue:brightness ForKey:kBrightness];
				}
				self.screenView.menuValue = brightness;
				[self.screenView setBrightness:[brightness floatValue]];
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
					contrast = [NSNumber numberWithInt:[contrast intValue] + 5];
					[self.settingsMemory setSettingsValue:contrast ForKey:kContrast];
				}
				self.screenView.menuValue = contrast;
				[self.screenView setContrast:[contrast floatValue]];
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
		if (m_state != kTVStateOff) {
			[m_menuTimer invalidate];
			m_menuTimer = nil;
			[m_inputChannelTimer invalidate];
			m_inputChannelTimer = nil;
			[m_setupChannelTimer invalidate];
			m_setupChannelTimer = nil;
			m_currentChannel = m_currentChannel + 1;
			if (m_currentChannel > 60) {
				m_currentChannel = 0;
			}
			[self.screenView hideMenu];
			self.screenView.isIdle = YES;
			self.screenView.inputChannel = [NSNumber numberWithInt:m_currentChannel];
			[self.screenView showInputChannel];
			[self changeChannel:[NSNumber numberWithInt:m_currentChannel]];
			[self.screenView updateScreen];
			m_inputChannelTimer = [NSTimer scheduledTimerWithTimeInterval:2
																   target:self
																 selector:@selector(hideInputChannel)
																 userInfo:nil
																  repeats:NO];
		}
	}
	if (key == kRemoteButtonProgramDown) {
		if (m_state != kTVStateOff) {
			[m_menuTimer invalidate];
			m_menuTimer = nil;
			[m_inputChannelTimer invalidate];
			m_inputChannelTimer = nil;
			[m_setupChannelTimer invalidate];
			m_setupChannelTimer = nil;
			m_currentChannel = m_currentChannel - 1;
			if (m_currentChannel < 0) {
				m_currentChannel = 60;
			}
			[self.screenView hideMenu];
			self.screenView.isIdle = YES;
			self.screenView.inputChannel = [NSNumber numberWithInt:m_currentChannel];
			[self.screenView showInputChannel];
			[self changeChannel:[NSNumber numberWithInt:m_currentChannel]];
			[self.screenView updateScreen];
			m_inputChannelTimer = [NSTimer scheduledTimerWithTimeInterval:2
																   target:self
																 selector:@selector(hideInputChannel)
																 userInfo:nil
																  repeats:NO];
		}
	}
	if (key == kRemoteButtonVolumeUp) {
		if (m_state == kTVStateIdle || m_state == kTVStateBrightnessSetup || m_state == kTVStateContrastSetup) {
			[m_menuTimer invalidate];
			m_menuTimer = nil;
			m_state = kTVStateVolumeSetup;
			self.screenView.menuString = MVOLUME;
			self.screenView.menuValue = [self.settingsMemory settingsValueForKey:kVolume];
			[self.screenView showMenu];
			[self.screenView updateScreen];
			[m_menuTimer invalidate];
			m_menuTimer = nil;
			m_menuTimer = [NSTimer scheduledTimerWithTimeInterval:5
														   target:self
														 selector:@selector(hideMenu)
														 userInfo:nil
														  repeats:NO];
		}
		if (m_state == kTVStateVolumeSetup) {
			[m_menuTimer invalidate];
			m_menuTimer = nil;
			float volume = [[self.settingsMemory settingsValueForKey:kVolume] floatValue] + 5;
			if (volume > 100) {
				volume = 100;
			}
			[self.settingsMemory setSettingsValue:[NSNumber numberWithFloat:volume] ForKey:kVolume];
			self.screenView.menuValue = [self.settingsMemory settingsValueForKey:kVolume];
			[self.screenView showMenu];
			[self.screenView updateScreen];
			[m_menuTimer invalidate];
			m_menuTimer = nil;
			m_menuTimer = [NSTimer scheduledTimerWithTimeInterval:5
														   target:self
														 selector:@selector(hideMenu)
														 userInfo:nil
														  repeats:NO];
		}
	}
	if (key == kRemoteButtonVolumeDown) {
		if (m_state == kTVStateIdle || m_state == kTVStateBrightnessSetup || m_state == kTVStateContrastSetup) {
			[m_menuTimer invalidate];
			m_menuTimer = nil;
			m_state = kTVStateVolumeSetup;
			self.screenView.menuString = MVOLUME;
			self.screenView.menuValue = [self.settingsMemory settingsValueForKey:kVolume];
			[self.screenView showMenu];
			[self.screenView updateScreen];
			[m_menuTimer invalidate];
			m_menuTimer = nil;
			m_menuTimer = [NSTimer scheduledTimerWithTimeInterval:5
														   target:self
														 selector:@selector(hideMenu)
														 userInfo:nil
														  repeats:NO];
		}
		if (m_state == kTVStateVolumeSetup) {
			[m_menuTimer invalidate];
			m_menuTimer = nil;
			float volume = [[self.settingsMemory settingsValueForKey:kVolume] floatValue] - 5;
			if (volume < 0) {
				volume = 0;
			}
			[self.settingsMemory setSettingsValue:[NSNumber numberWithFloat:volume] ForKey:kVolume];
			self.screenView.menuValue = [self.settingsMemory settingsValueForKey:kVolume];
			[self.screenView showMenu];
			[self.screenView updateScreen];
			[m_menuTimer invalidate];
			m_menuTimer = nil;
			m_menuTimer = [NSTimer scheduledTimerWithTimeInterval:5
														   target:self
														 selector:@selector(hideMenu)
														 userInfo:nil
														  repeats:NO];
		}
	}
	
}

- (void)switchOn
{
	m_state = kTVStateOn;
	[self.screenView switchOn];
	
	[m_sound play];
	[self changeChannel:0];
	m_state = kTVStateIdle;
	[self.screenView setBrightness:[[self.settingsMemory settingsValueForKey:kBrightness] floatValue]];
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
	[m_menuTimer invalidate];
	m_menuTimer = nil;
	[m_inputChannelTimer invalidate];
	m_inputChannelTimer = nil;
	[m_setupChannelTimer invalidate];
	m_setupChannelTimer = nil;
	m_state = kTVStateChannelSetup;
	[self.channelMemory reset];
	self.screenView.image = nil;
	[self.screenView updateScreen];
	m_currentFrequency = 0.0;
	m_signal = nil;
	m_currentChannel = 0;
	[self setupCurrentChannel];
}

- (void)setupCurrentChannel
{
	[m_setupChannelTimer invalidate];
	m_setupChannelTimer = nil;
	if (m_currentChannel >= 60 || (m_currentFrequency >= 730)) {
		m_state = kTVStateIdle;
		self.screenView.isIdle = YES;
		m_currentChannel = 0;
		[self changeChannel:[NSNumber numberWithInt:m_currentChannel]];
		self.screenView.inputChannel = [NSNumber numberWithInt:m_currentChannel];
		[self.screenView hideMenu];
		[self.screenView updateScreen];
		m_inputChannelTimer = [NSTimer scheduledTimerWithTimeInterval:2
															   target:self
															 selector:@selector(hideInputChannel)
															 userInfo:nil
															  repeats:NO];
		NSLog(@"Setup was completed!");
		return;
	}
	NSLog(@"setup channel %d with frequency %4.1f",m_currentChannel, m_currentFrequency);
	
	[self changeChannel:[NSNumber numberWithInt:m_currentChannel]];
	m_state = kTVStateChannelSetup;
	self.screenView.isIdle = YES;
	self.screenView.inputChannel = [NSNumber numberWithInt:m_currentChannel];
	[self.screenView showInputChannel];
	
	self.screenView.menuString = [NSString stringWithFormat:@"Setting channel %d", m_currentChannel];
	self.screenView.menuValue = [NSNumber numberWithFloat:m_currentFrequency / 730.0 * 100];
	[self.screenView showMenu];
	
	m_signal = [self.signalSource signalByFrequency:[NSNumber numberWithFloat:m_currentFrequency]];
	self.screenView.image = m_signal;
	[self.screenView updateScreen];
	
	if (!m_signal) {
		m_currentFrequency += 1;
		m_setupChannelTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setupCurrentChannel) userInfo:nil repeats:NO];
	} else {
		[self.channelMemory setFrequency:[NSNumber numberWithFloat:m_currentFrequency] forChannel:[NSNumber numberWithInt:m_currentChannel]];
		m_currentFrequency = m_currentFrequency + 5;
		m_currentChannel = m_currentChannel + 1;
		m_setupChannelTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(setupCurrentChannel) userInfo:nil repeats:NO];
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
