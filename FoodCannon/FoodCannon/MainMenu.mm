//
//  MainMenu.m
//  catnmouse
//
//  Created by William Saults on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "Game.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "Constants.h"
#import "PopUp.h"
#import "CCMenuPopup.h"

@implementation MainMenu

- (id)init 
{
    if((self = [super init])) {
        // Initiliaztion code here.

        delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
    }
    return self;
}

- (void)playGame
{
    [[CCDirector sharedDirector] replaceScene:[Game scene]];
}

- (void)dealloc
{
    CCLOG(@"dealloc: %@", self);
    [super dealloc];
}

@end
