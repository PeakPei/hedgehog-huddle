//
//  LevelController.m
//  HedgehogHuddle
//
//  Created by Student on 12/15/13.
//  Copyright (c) 2013 Natasha and Carl. All rights reserved.
//

#import "LevelController.h"
#import "GameScreen.h"

GameScreen *gameScreen;

@implementation LevelController{
    gameScreen = [[GameScreen]]
}

// Reset stats
-(void)createLevel :(int)timeLimit :(BOOL)lvDel :(BOOL)lastLv :(int)hedgehogStartX :(int)hedgehogStartY{
    // Reset time
    _timePerLevel = timeLimit;
    _timeInLevel = 0;
    [self createTextNodes];
    
    // Level helpers
    _levelDelete = lvDel;
    _lastLevel = lastLv;
    
    // Hedgehog level start
    _hh.position = CGPointMake(hedgehogStartX, hedgehogStartY);
}
// Remove all screen elements
-(void)wipeLevel
{
    //NSLog(@"Deleting Current Level");
    _levelDelete = YES;
    [_holes removeAllObjects];
    [_walls removeAllObjects];
    [self removeAllChildren];
}
// Go to next level
-(void)runNextLevel
{
    switch (_levelCount) {
        case 0:
            [self runFirstLevel];
            _levelCount++;
            break;
        case 1:
            [self runSecondLevel];
            _levelCount++;
            break;
            /*case 2:
             [self runFirstLevel];
             _levelCount++;
             break;*/
            
        default:
            break;
    }
}
// Level 1
-(void)runFirstLevel{
    _levelDelete = NO;
    _lastLevel = NO;
    
    // Start timer
    _timePerLevel = 30.0;
    [self runSecondLevel];
    
    // Read plist for level and put them on screen
    //[self readFile:@"Level1"];
}
// Level 2
-(void)runSecondLevel{
    // Adjust variables
    [self createLevel:30 :NO :NO :60 :720];
    
    // Read plist for level and put them on screen
    [self readFile:@"Level2"];
}
// Level 3
-(void)runThirdLevel{
    // Adjust variables
    [self readFile:@"Level3"];
}

@end
