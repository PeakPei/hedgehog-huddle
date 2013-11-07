//
//  GameScreen.m
//  HedgehogHuddle
//
//  Created by Student on 11/7/13.
//  Copyright (c) 2013 Natasha and Carl. All rights reserved.
//

#import "GameScreen.h"

@interface GameScreen ()

@property BOOL contentCreated;

@end

@implementation GameScreen{
    SKSpriteNode *hh;
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
    
    
    // Add an image
    /*
    SKSpriteNode *hedgehog = [self newSpaceship];
    spaceship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 150);
    [self addChild:spaceship];
     */
}

-(SKSpriteNode *)newSpaceship{
    //hh = [[SKSpriteNode alloc] initWithImageNamed:@"hedgehogRolledUp.png"];
    //hh.size = CGSizeMake(32,64);
    /* A little wiggle never hurt nohog, maybe? Really subtle tho
    SKAction *hover = [SKAction sequence:@[
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:100 y:50.0 duration:1.0],
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:-100 y:-50 duration:1.0]
                                           ]];
    [hh runAction:[SKAction repeatActionForever:hover]];
    */
    
    // Do we want physics?
    /*
    hh.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hull.size];
    hh.physicsBody.dynamic = NO;
    */
    
    return hh;
}


@end
