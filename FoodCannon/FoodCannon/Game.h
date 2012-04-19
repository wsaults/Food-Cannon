//
//  Game.h
//  catnmouse
//
//  Created by William Saults on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "MyContactListener.h"

#import "AdWhirlView.h"
#import "AdWhirlDelegateProtocol.h"
#import "AppDelegate.h"
#import "RootViewController.h"

enum GameStatePP {
    kGameStatePlaying,
    kGameStatePaused
};

@class AppDelegate;

@interface Game : CCLayer <CCStandardTouchDelegate, AdWhirlDelegate>{
    
    // Add inside @interface
    RootViewController *viewController;
    AdWhirlView *adWhirlView;
    
    enum GameStatePP _state;
    
    AppDelegate *delegate;
    CGSize s;
    
    }

// Add after @interface
@property(nonatomic,retain) AdWhirlView *adWhirlView;
@property(nonatomic) enum GameStatePP state;

-(void)pauseGame;
-(void)resumeGame;
-(void)startGame;
-(void)initializeGame;
-(void)mainMenu;
-(void)gameOver;
-(void)playAgain;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
