//
//  GameScreen.m
//  HedgehogHuddle
//
//  Created by Student on 11/7/13.
//  Copyright (c) 2013 Natasha and Carl. All rights reserved.
//
//
//
// Sections in this Class Include:
//      Level Controls
//      Screen Elements
//      Time & Game Mechanics
//      Accel & Physics
//

#import "GameScreen.h"
#import "WinScreen.h"
#import "loseScreen.h"
#import "SoundController.h"
#import <CoreMotion/CoreMotion.h>


// Globals
static const float _holeDiameter = 60;
static const float _bumperDiameter = 30;


@interface GameScreen ()
@property BOOL contentCreated;
@property (nonatomic, strong) NSDictionary *gameData;
@end

@implementation GameScreen{
    SKSpriteNode *_hh;
    CMMotionManager *_motionManager;
    
    NSMutableArray *_walls;
    NSMutableArray *_holes;
    NSMutableArray *_bumpers;
    SKSpriteNode *_finish;
    
    CGFloat _screenHeight;
    CGFloat _screenWidth;
    
    SoundController *_sound;
    
    float _timePerLevel;  // The time limit for each level
    float _timeInLevel;   // The time the player has been in the level
    double _lastTime;
    double _timeSinceLastSecondWentBy;
    SKLabelNode *timer;
    
    int _highScore;
    
    BOOL hit;
    
    BOOL _levelDelete;
    BOOL _lastLevel;
    int _levelCount;
}

-(void)didMoveToView:(SKView *)view{
    if(!self.contentCreated){
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]){
        // Set up scene here
        
        // Screen Dimentions
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        _screenHeight = screenRect.size.height;
        _screenWidth = screenRect.size.width;
        
        // Accelerometer
        _motionManager = [[CMMotionManager alloc] init];
        
        // Screen images arrays
        _walls = [[NSMutableArray alloc] init];
        _holes = [[NSMutableArray alloc] init];
        _bumpers = [[NSMutableArray alloc] init];
        
        //Define your physics body around the screen - used by your hedgehog to not bounce off the screen
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        // Sound
        _sound = [[SoundController alloc] init];
        
        [self startTheGame];
    }
    return self;
}

///////////////////////// Level Controls ///////////////////////////////////////

// Reads in a file based on the level's name
-(void)readFile :(NSString *)levelName{
    // Read values
    NSString *readPath = [[NSBundle mainBundle] pathForResource:levelName ofType:@"plist"];
    self.gameData = [[NSDictionary alloc] initWithContentsOfFile: readPath];
    // Create the walls and such
    // First element in array is the type of object
        // 0 -- Wall
        // 1 -- Finish
        // 2 -- Hole
    for(id key in self.gameData){
        NSArray *temp = (NSArray *)[self.gameData objectForKey:key];
        
        // Cast numbers into usable objects
        NSNumber* n = [temp objectAtIndex:0];
        NSInteger t1 = [temp[1] integerValue];
        NSInteger t2 = [temp[2] integerValue];
        NSInteger t3;
        NSInteger t4;
        
        if([temp count] > 3){
            t3 = [temp[3] integerValue];
            t4 = [temp[4] integerValue];
        }
        
        switch ([n integerValue]) {
            case 0:
                // Wall
                [self createWallAtX:t1 atY:t2 width:t3 height:t4];
                break;
            case 1:
                // Finish
                [self createFinishAtX:t1 atY:t2 width:t3 height:t4];
                break;
            case 2:
                // Hole
                [self createHoleAtX:t1 atY:t2];
                break;
            case 3:
                // Bumper
                [self createBumperAtX:t1 atY:t2];
                break;
            default:
                break;
        }// End of switch
    }// End of for
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
    [self addChild:_hh];
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
    //NSLog(@"levelCount: %d", _levelCount);
    switch (_levelCount) {
        case 0:
            [self runFirstLevel];
            _levelCount++;
            break;
        case 1:
            [self runSecondLevel];
            _levelCount++;
            break;
            case 2:
             [self runThirdLevel];
             _levelCount++;
             break;
            
        default:
            break;
    }
}
// Level 1
-(void)runFirstLevel{
    [self createLevel:31 :NO :NO :120 :120];
    [self readFile:@"Level1"];
}
// Level 2
-(void)runSecondLevel{
    [self createLevel:31 :NO :NO :60 :720];
    [self readFile:@"Level2"];
}
// Level 3
-(void)runThirdLevel{
    [self createLevel:40 :NO :YES :720 :60];
    [self readFile:@"Level3"];
}

///////////////////////// End Level Controls //////////////////////////////////


///////////////////////// Screen Elements //////////////////////////////////////
// The screen
-(void)createSceneContents{
    self.backgroundColor = [SKColor whiteColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    // Add an image
    [self newHedgehog];
}
// Hedgehog
-(SKSpriteNode *)newHedgehog{
    _hh = [[SKSpriteNode alloc] initWithImageNamed:@"hedgehog1.png"];
    _hh.size = CGSizeMake(45,45);
    
    // Physics
    _hh.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_hh.frame.size];
    _hh.physicsBody.dynamic = YES;
    _hh.physicsBody.affectedByGravity = NO;
    _hh.physicsBody.mass = 0.1;
    
    // Create the level
    [self runFirstLevel];
    
    return _hh;
}
// Wall
-(void)createWallAtX:(int)xLoc atY:(int)yLoc width:(float)width height:(float)height{
    // Add a wall at (xLoc, yLoc) that is width by height big
    // Create the wall
    SKSpriteNode *wall = [[SKSpriteNode alloc] initWithColor:[SKColor blueColor] size:CGSizeMake(width, height)];
    wall.position = CGPointMake(xLoc, yLoc);
    
    // Add the physics
    wall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:wall.frame.size];
    wall.physicsBody.dynamic = NO;  // Change to yes if want walls falling
    wall.physicsBody.affectedByGravity = NO;
    wall.physicsBody.mass = 0.1;
    
    [self addChild:wall];

    // Add it to the wall array
    [_walls addObject:wall];
}
// bumper
-(void)createBumperAtX:(int)xLoc atY:(int)yLoc{
    // Add a bumper of standard size to the screen at (xLoc, yLoc)
    // Create a bumper
    SKSpriteNode *bumper = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(_bumperDiameter, _bumperDiameter)];
    bumper.position = CGPointMake(xLoc, yLoc);
    [self addChild:bumper];
    
    // Add it to the bumper array
    [_bumpers addObject:bumper];
}
// Hole
-(void)createHoleAtX:(int)xLoc atY:(int)yLoc{
    // Add a hole of standard size to the screen at (xLoc, yLoc)
    // Create the hole
    // (The hole will be circular once the image is added)
    SKSpriteNode *hole = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(_holeDiameter, _holeDiameter)];
    hole.position = CGPointMake(xLoc, yLoc);
    [self addChild:hole];
    
    // Add it to the hole array
    [_holes addObject:hole];
}
// Finish
-(void)createFinishAtX:(int)xLoc atY:(int)yLoc width:(float)width height:(float)height{
    // Create a finish location at (xLoc, yLoc)
    _finish = [[SKSpriteNode alloc] initWithColor:[SKColor greenColor] size:CGSizeMake(width, height)];
    _finish.position = CGPointMake(xLoc, yLoc);
    [self addChild:_finish];
}
// Text
-(void)createTextNodes{
    // Timer label
    timer = [SKLabelNode labelNodeWithFontNamed:@"Times"];
    
    timer.name = @"Time";
    timer.text = [NSString stringWithFormat:@"Time %f", _timePerLevel - _timeInLevel];
    timer.fontSize = 48.0;
    timer.fontColor = [SKColor redColor];
    
    CGPoint textPosition = CGPointMake(_screenWidth + 100, _screenHeight + 400);
    timer.position = textPosition;
    [self addChild: timer];
}

///////////////////////// End Screen Elements ////////////////////////////////////


//////////////////////// Time & Game Mechanics /////////////////////////////////
// Collision detection
-(void)checkCollisions{
    
    for(SKSpriteNode *wall in _walls)
    {
        if ([_hh intersectsNode:wall]) {
            //[_sound playHit];
            if (! _sound.hitPlaying) {
                [_sound playHitSound];
            }
        }
    }
    
    // Loop through hole and bumper array
    if(_hh != nil){
        hit = NO;
        for(int i = 0; i < [_bumpers count]; i++){
            if(CGRectIntersectsRect(_hh.frame,[(SKSpriteNode *) [_bumpers objectAtIndex:i] frame])){
                // Ball has hit a bumper
                // Bump ball back
                hit = YES;
            }
        }
        for(int i = 0; i < [_holes count]; i++){
            if(CGRectContainsRect([(SKSpriteNode *) [_holes objectAtIndex:i] frame], _hh.frame)){
                // Ball has fallen into a hole
                // lose game
                [self wipeLevel];
                [self changeScreens:2];
            }
        }
    }
    
    if(CGRectIntersectsRect(_hh.frame, _finish.frame) && _levelDelete == NO){
        // Won! (made it to the victory area)
        //NSLog(@"%d", CGRectIntersectsRect(_hh.frame, _finish.frame));
        if(_lastLevel == YES)
        {
            [self wipeLevel];
            [self changeScreens:1];
            return;
        }
        
        [self wipeLevel];
        [self runNextLevel];
    }
}
// Change screens
-(void)changeScreens :(int)nextScreenClass{
    @try {
        // Stop the ball so interference doesn't happen
        [_hh removeFromParent];
        _hh = nil;
        
        // End accelerometer
        [self pauseGame];
        
        // Change to the next screen
        // nextScreenClass
        // 1 -> WinScreen
        // 2 -> LoseScreen
        SKScene *nextScene;
        SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
        if(nextScreenClass == 1){
            nextScene = [[WinScreen alloc] initWithSize:self.size];
        }else if (nextScreenClass == 2){
            nextScene = [[LoseScreen alloc] initWithSize:self.size];
        }
        //NSLog(@"Screen to change: %d", nextScreenClass);
        [self.view presentScene:nextScene transition:doors];
    }
    
    @catch (NSException *exception) {
        //NSLog(@"caught an exception: %@", exception.reason);
        //NSLog(@"next Screen class = %i", nextScreenClass);
        //NSLog(@"_hh = %@", _hh);
        @throw exception;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"loseScreen"]){
        WinScreen *controller = (WinScreen *)segue.destinationViewController;
        controller.gameScore = _timeInLevel;
    }
}
// Time
-(void)updateTime{
    // Increment the time
    _timeInLevel++;
    timer.text = [NSString stringWithFormat:@"Time %f", _timePerLevel - _timeInLevel];
    
    if(_timePerLevel - _timeInLevel == 5){
        // There's only 5 seconds left! Play music
        [_sound playTimeRunningOut];
    } else if(_timePerLevel - _timeInLevel <= 0){
        // Change to lose screen
        [self wipeLevel];
        [self changeScreens:2];
    }
}
// Animate
-(void)update:(NSTimeInterval)currentTime {
    // Change the time
    // calculate deltaTime
    double time = (double)CFAbsoluteTimeGetCurrent();
    float dt = time - _lastTime;
    _lastTime = time;
    
    // A second has gone by
    _timeSinceLastSecondWentBy += dt;
    if(_timeSinceLastSecondWentBy > 1){
        _timeSinceLastSecondWentBy = 0;
        [self updateTime];
    }
    
    /* Called before each frame is rendered */
    [self updateHogPositionFromMotionManager];
}
// Pause
- (void)pauseGame{
    [self stopMonitoringAcceleration];
    
    // Save high score
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger: _highScore forKey:@"highScoreKey"];
}
// Resume
- (void)resumeGame{
    [self startMonitoringAcceleration];
}

- (void)willMoveFromView:(SKView *)view{
    [self pauseGame];
}

- (void)startTheGame{
    //setup to handle accelerometer readings using CoreMotion Framework
    [self startMonitoringAcceleration];
    hit = NO;
    _levelCount = 1;
}

//////////////////////// Time & Game Mechanics /////////////////////////////////


///////////////////////// Accel and Physics ///////////////////////////////

- (void)startMonitoringAcceleration{
    if (_motionManager.accelerometerAvailable) {
        [_motionManager startAccelerometerUpdates];
        //NSLog(@"accelerometer updates on...");
    }
}

- (void)stopMonitoringAcceleration{
    if (_motionManager.accelerometerAvailable && _motionManager.accelerometerActive) {
        [_motionManager stopAccelerometerUpdates];
        //NSLog(@"accelerometer updates off...");
    }
}

- (void)updateHogPositionFromMotionManager{
    // Update the physics
    CMAccelerometerData* data = _motionManager.accelerometerData;
    if(hit == YES){
        [_hh.physicsBody applyImpulse:CGVectorMake(-1 * (30 * data.acceleration.x), -1 *(30 * data.acceleration.y))];
    }else {
        [_hh.physicsBody applyForce:CGVectorMake(100 * data.acceleration.x, 100 * data.acceleration.y)];
    }
    
    // Check collisions
    [self checkCollisions];
}


@end
