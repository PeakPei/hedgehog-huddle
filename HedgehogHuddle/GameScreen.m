//
//  GameScreen.m
//  HedgehogHuddle
//
//  Created by Student on 11/7/13.
//  Copyright (c) 2013 Natasha and Carl. All rights reserved.
//

#import "GameScreen.h"
#import <CoreMotion/CoreMotion.h>

@interface GameScreen ()

@property BOOL contentCreated;

@end

@implementation GameScreen{
    SKSpriteNode *_hh;
    CMMotionManager *_motionManager;
}

-(void)didMoveToView:(SKView *)view{
    if(!self.contentCreated){
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

-(void)createSceneContents{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    _motionManager = [[CMMotionManager alloc] init];
    [self startMonitoringAcceleration];
    
    // Add an image
    
    SKSpriteNode *hedgehog = [self newHedgehog];
    hedgehog.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:hedgehog];
    
    //Define your physics body around the screen - used by your hedgehog to not bounce off the screen
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
}

-(SKSpriteNode *)newHedgehog{
    _hh = [[SKSpriteNode alloc] initWithImageNamed:@"testBall.png"];
    _hh.size = CGSizeMake(64,64);
    //A little wiggle never hurt nohog, maybe? Really subtle tho
    /*
    SKAction *hover = [SKAction sequence:@[
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:100 y:50.0 duration:1.0],
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:-100 y:-50 duration:1.0]
                                           ]];
    [hh runAction:[SKAction repeatActionForever:hover]];
     */
    
    // Do we want physics?
    
    _hh.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_hh.frame.size];
    _hh.physicsBody.dynamic = YES;
    _hh.physicsBody.affectedByGravity = NO;
    _hh.physicsBody.mass = 0.1;
    
    return _hh;
}

-(void)update:(NSTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self updateHogPositionFromMotionManager];
}

- (void)startTheGame
{
    //setup to handle accelerometer readings using CoreMotion Framework
    [self startMonitoringAcceleration];
    
}

- (void)startMonitoringAcceleration
{
    if (_motionManager.accelerometerAvailable) {
        [_motionManager startAccelerometerUpdates];
        NSLog(@"accelerometer updates on...");
    }
}

- (void)stopMonitoringAcceleration
{
    if (_motionManager.accelerometerAvailable && _motionManager.accelerometerActive) {
        [_motionManager stopAccelerometerUpdates];
        NSLog(@"accelerometer updates off...");
    }
}

- (void)updateHogPositionFromMotionManager
{
    CMAccelerometerData* data = _motionManager.accelerometerData;
    /*if (fabs(data.acceleration.x) > 0.1) {
        NSLog(@"x acceleration value = %f",data.acceleration.x);
    }
    if (fabs(data.acceleration.y) > 0.1) {
        NSLog(@"y acceleration value = %f",data.acceleration.y);
    }*/
    
    [_hh.physicsBody applyForce:CGVectorMake(50 * data.acceleration.x, 50 * data.acceleration.y)];
}


@end
