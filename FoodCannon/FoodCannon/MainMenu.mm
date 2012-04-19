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
        CGSize s = [[CCDirector sharedDirector] winSize];
        
        // Play UTVCA Games intro
        CCSprite *logo = [CCSprite spriteWithFile:@"logo.png"];
        logo.position = ccp(s.width/2, s.height/1.7);
        logo.opacity = 0;
        [self addChild:logo];
        [logo runAction:[CCSequence actions:
                         [CCFadeIn actionWithDuration:4],
                         [CCDelayTime actionWithDuration:1],
                         [CCFadeOut actionWithDuration:1.5], 
                         [CCCallFunc actionWithTarget:self selector:@selector(finish)], nil]];
        
        CCLabelTTF *utvcaGame = [CCLabelTTF labelWithString:@"G A M E S" fontName:@"Thonburi" fontSize:32];
        utvcaGame.position = ccp(s.width/2, s.height/3);
        utvcaGame.opacity = 0;
        [self addChild:utvcaGame];
        [utvcaGame runAction:[CCSequence actions:
                              [CCDelayTime actionWithDuration:1],
                              [CCFadeIn actionWithDuration:3],
                              [CCDelayTime actionWithDuration:.5],
                              [CCFadeOut actionWithDuration:1.5], 
                              [CCCallFunc actionWithTarget:self selector:@selector(finish)], nil]];
         
                            
        
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        // Create the HighScore label in the top right corner
        int fSize = 24;
        CCLabelTTF *highScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"High Score: %d", [delegate getHighScore]] fontName:@"SF_Cartoonist_Hand_Bold.ttf" fontSize:fSize];
        highScore.anchorPoint = ccp(1,1);
        highScore.position = ccp(s.width,s.height);
        [self addChild:highScore];
        
        // Add Play button
        
        /*
         * Group the next two buttons in a menu
         */
        // Add Leaderboard button
        // Add Achievements button
        
        // Add Store button
        
        // Add BG
        
    }
    return self;
}

- (void)intro 
{
    
}

- (void)playGame
{
    [[CCDirector sharedDirector] replaceScene:[Game scene]];
}

//- (void)showLeaderboard
//{
//    [delegate showLeaderboard];
//}
//
//- (void)showAchievements
//{
//    [delegate showAchievements];
//}

- (void)finish {
    
}

- (void)dealloc
{
    CCLOG(@"dealloc: %@", self);
    [super dealloc];
}

@end
