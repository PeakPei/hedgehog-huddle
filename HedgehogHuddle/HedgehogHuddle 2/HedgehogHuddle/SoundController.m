//
//  SoundController.m
//  HedgehogHuddle
//
//  Created by Student on 11/14/13.
//  Copyright (c) 2013 Natasha and Carl. All rights reserved.
//

#import "SoundController.h"
#import <AVFoundation/AVFoundation.h>

static NSString* const kSoundWin = @"winSound";
static NSString* const kSoundLose = @"loseSound";
static NSString* const kSoundHit = @"hitSound";
static NSString* const kSoundTimeRunningOut = @"timeRunningOutSound";

@implementation SoundController{
    AVAudioPlayer *_soundDictionary;
     AVAudioPlayer *_hitPlayer;
    float _volume;
}

-(BOOL)isHitPlaying{
    
    return _hitPlayer.playing;
}

- (void)preloadAllSounds{
    _volume = 0.0;
    [self playSound: kSoundWin];
}

// For wav only
-(void) playSound:(NSString *)fileName{
    NSString *soundPath =[[NSBundle mainBundle] pathForResource:fileName ofType:@"wav"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    NSError *error;
    
    _soundDictionary = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    _soundDictionary.currentTime = 0;
    _soundDictionary.volume = _volume;
    [_soundDictionary play];
}

// For wav only
-(void) playHitSound{
    NSString *soundPath =[[NSBundle mainBundle] pathForResource: kSoundHit ofType:@"wav"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    NSError *error;
    
    _hitPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    _hitPlayer.currentTime = 0;
    _volume = 0.5;
    _hitPlayer.volume = _volume;
    [_hitPlayer play];
}

-(void)playHit{
    _volume = 0.6;
    [self playSound: kSoundHit];
    [self performSelector:@selector(playSound:) withObject: kSoundHit];
}

-(void)playWin{
    _volume = 0.6;
    [self playSound: kSoundWin];
    [self performSelector:@selector(playSound:) withObject: kSoundWin];
}

-(void)playLose{
    _volume = 0.6;
    [self playSound: kSoundLose];
    [self performSelector:@selector(playSound:) withObject: kSoundLose];
}

-(void)playTimeRunningOut{
    _volume = 0.6;
    [self playSound: kSoundTimeRunningOut];
    [self performSelector:@selector(playSound:) withObject: kSoundTimeRunningOut];
}



@end
