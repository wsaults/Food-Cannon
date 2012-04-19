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
        CCLabelTTF *utvcaGame = [CCLabelTTF labelWithString:@"GAMES" fontName:@"Thonburi" fontSize:29];
        utvcaGame.position = ccp(s.width/2, s.height/2);
        utvcaGame.opacity = 0;
        [self addChild:utvcaGame];
        [utvcaGame runAction:[CCSequence actions:
                              [CCFadeIn actionWithDuration:3],
                              [CCFadeOut actionWithDuration:2], 
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
