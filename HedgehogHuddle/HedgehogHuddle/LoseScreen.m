//
//  loseScreen.m
//  HedgehogHuddle
//
//  Created by Student on 11/21/13.
//  Copyright (c) 2013 Natasha and Carl. All rights reserved.
//

#import "LoseScreen.h"
#import "TitleScreen.h"
#import "SoundController.h"

@interface LoseScreen ()

@property BOOL contentCreated;

@end


@implementation LoseScreen{
    SoundController *_sound;
    CGFloat _screenHeight;
    CGFloat _screenWidth;
}

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]){
        // Set up scene here
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        _screenHeight = screenRect.size.height;
        _screenWidth = screenRect.size.width;
    }
    return self;
}

-(void)didMoveToView:(SKView *)view{
    if(!self.contentCreated){
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

-(void)createSceneContents{
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    _sound = [[SoundController alloc] init];
    
    // Add a background image (TBChanged later)
    SKSpriteNode *loseBG = [[SKSpriteNode alloc] initWithTexture:
                            [SKTexture textureWithImageNamed:@"loseScreen.png"]
                                                           color:[UIColor redColor]
                                                            size:CGSizeMake(_screenWidth * 2.4, _screenHeight * 1.8)];
    loseBG.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:loseBG];
    
    // Play victory sounds
    [_sound playLose];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // Transition to the next screne
    // Animation: vertical doors opening
    SKScene *titleScene = [[TitleScreen alloc] initWithSize:self.size];
    SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
    [self.view presentScene:titleScene transition:doors];
}

@end
