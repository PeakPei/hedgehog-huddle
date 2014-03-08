//
//  WinScreen.m
//  HedgehogHuddle
//
//  Created by Student on 11/14/13.
//  Copyright (c) 2013 Natasha and Carl. All rights reserved.
//

#import "WinScreen.h"
#import "TitleScreen.h"
#import "SoundController.h"

@interface WinScreen ()

@property BOOL contentCreated;

@end


@implementation WinScreen{
    SoundController *_sound;
    CGFloat _screenHeight;
    CGFloat _screenWidth;
    SKLabelNode *score;
    SKLabelNode *highScore;
    int theHighScore;
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
    SKSpriteNode *winBG = [[SKSpriteNode alloc] initWithTexture:
                           [SKTexture textureWithImageNamed:@"win.png"]
                                                          color:[UIColor redColor]
                                                           size:CGSizeMake(_screenWidth * 2.4, _screenHeight * 1.8)];
    winBG.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:winBG];
    
    // Play victory sounds
    [_sound playWin];
    
    // Put scores on screen
    [self createTextNodes];
}

// Text
-(void)createTextNodes{
    // Score label
    score = [SKLabelNode labelNodeWithFontNamed:@"Times"];
    
    score.name = @"Score";
    score.text = [NSString stringWithFormat:@"%d", _gameScore];
    score.fontSize = 70.0;
    score.fontColor = [SKColor blackColor];
    
    CGPoint textPosition = CGPointMake(_screenWidth + 200, _screenHeight + 70);
    score.position = textPosition;
    [self addChild: score];
    
    
    // High score label
    highScore = [SKLabelNode labelNodeWithFontNamed:@"Times"];
    
    // Check for new high score
    [self highScoreChecker];
    
    highScore.name = @"Score";
    highScore.fontSize = 70.0;
    highScore.fontColor = [SKColor blackColor];
    
    textPosition = CGPointMake(_screenWidth + 200, _screenHeight - 140);
    highScore.position = textPosition;
    [self addChild: highScore];
}

-(void)highScoreChecker{
    theHighScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"high_score"];
    if(_gameScore > theHighScore){
            [[NSUserDefaults standardUserDefaults] setInteger:_gameScore forKey:@"high_score"];
            highScore.text = [NSString stringWithFormat:@"%d", _gameScore];
    }else{
            highScore.text = [NSString stringWithFormat:@"%d", theHighScore];
    }
    theHighScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"high_score"];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // Transition to the next screne
    // Animation: vertical doors opening
    SKScene *titleScene = [[TitleScreen alloc] initWithSize:self.size];
    SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
    [self.view presentScene:titleScene transition:doors];
}

@end
