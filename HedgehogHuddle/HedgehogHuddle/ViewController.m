//
//  ViewController.m
//  HedgehogHuddle
//
//  Created by Student on 11/7/13.
//  Copyright (c) 2013 Natasha and Carl. All rights reserved.
//

#import "ViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "TitleScreen.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Testing variables
    SKView *spriteView = (SKView *) self.view;
    //spriteView.showsDrawCount = YES;
    //spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    TitleScreen *title = [[TitleScreen alloc] initWithSize:CGSizeMake(768, 1024)];
    SKView *spriteView = (SKView *) self.view;
    [spriteView presentScene: title];
}

@end
