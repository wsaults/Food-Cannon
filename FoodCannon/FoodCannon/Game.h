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
    int score, numberOfObjects, fSize;
    double gameTime;
    bool isPaused;
    
    CCLabelTTF *scoreLabel;
    
    // World fixtures
    b2Vec2 gravity;
    b2World *_world;
    b2Body *_groundBody;
    b2Fixture *_bottomFixture;
    
    // Top sprite
    CCSprite *_topSprite;
    b2FixtureDef topShapeDef;
    b2Body *_topBody;
    b2Fixture *_topSpriteFixture;
    
    // Bottom sprite
    CCSprite *_bottomSprite;
    b2FixtureDef bottomShapeDef;
    b2Body *_bottomBody;
    b2Fixture *_bottomSpriteFixture;
    
    // ball
    b2FixtureDef ballShapeDef;
    b2Fixture *_ballFixture;
    b2Body *_ballBody;
    
    b2MouseJoint *_mouseJoint;
    
    // Contact Listener
    MyContactListener *_contactListener;
    
    }

// Add after @interface
@property(nonatomic,retain) AdWhirlView *adWhirlView;
@property(nonatomic) enum GameStatePP state;
@property (nonatomic, assign) CCTexture2D *texture;


-(void)didScore;
-(void)pauseGame;
-(void)resumeGame;
-(void)startGame;
-(void)initializeGame;
-(void)mainMenu;
-(void)gameOver;
-(void)playAgain;

-(void)createObject;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
