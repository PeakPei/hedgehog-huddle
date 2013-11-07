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
}

-(void)didMoveToView:(SKView *)view{
    if(!self.contentCreated){
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

-(void)createSceneContents{
    self.backgroundColor = [SKColor redColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    // Add a background image
    // Image will have everything already on it,
    // So we won't need multiple layers of images
    /*
     SKSpriteNode *titleBG = [[SKSpriteNode alloc] initWithImageNamed:@"titleScreenBG.png"];
     spaceship.position = CGPointMake(0, 0);  // Create image at the origin
     [self addChild:titleBG];
     */
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // Transition to the next screne
    // Animation: vertical doors opening
    SKScene *gameScene = [[GameScreen alloc] initWithSize:self.size];
    SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
    [self.view presentScene:gameScene transition:doors];
}


@end
