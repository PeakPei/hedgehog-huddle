//
//  SoundController.h
//  HedgehogHuddle
//
//  Created by Student on 11/14/13.
//  Copyright (c) 2013 Natasha and Carl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundController : NSObject

@property (nonatomic) BOOL hitPlaying;

-(void)playHit;
-(void)playWin;
-(void)playLose;
-(void)playTimeRunningOut;
-(void)playHitSound;

@end
