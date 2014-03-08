//
//  TitleScreen.m
//  HedgehogHuddle
//
//  Created by Student on 11/7/13.
//  Copyright (c) 2013 Natasha and Carl. All rights reserved.
//

#import "TitleScreen.h"
#import "GameScreen.h"

@interface TitleScreen ()

@property BOOL contentCreated;

@end


@implementation TitleScreen{
    SKSpriteNode *title;
    CGRect screenRect;
    float _screenHeight;
    float _screenWidth;
}

-(void)didMoveToView:(SKView *)view{
    if(!self.contentCreated){
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

-(void)createSceneContents{
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    // Add a background image
    SKSpriteNode *titleBG = [[SKSpriteNode alloc] initWithImageNamed:@"titleScreen.png"];
    titleBG.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:titleBG];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // Transition to the next screne
    // Animation: vertical doors opening
    SKScene *gameScene = [[GameScreen alloc] initWithSize:self.size];
    SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
    [self.view presentScene:gameScene transition:doors];
}


@end
