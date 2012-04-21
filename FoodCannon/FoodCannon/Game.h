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
    double gameTime, score;
    bool isPaused;
    
    CCLabelTTF *scoreLabel;
    
    // World fixtures
    b2Vec2 gravity;
    b2World *_world;
    b2Body *_groundBody;
    b2Fixture *_bottomFixture;
    
    // ball
    b2FixtureDef cat1ShapeDef;
    b2Fixture *_cat1Fixture;
    
    }

// Add after @interface
@property(nonatomic,retain) AdWhirlView *adWhirlView;
@property(nonatomic) enum GameStatePP state;

-(void)didScore;
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
