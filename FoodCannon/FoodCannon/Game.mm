//
//  Game.m
//  catnmouse
//
//  Created by William Saults on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Game.h"
#import "MainMenu.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "Constants.h"
#import "PopUp.h"
#import "CCMenuPopup.h"

#define PTM_RATIO 32.0

@implementation Game

@synthesize state = _state, adWhirlView;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Game *layer = [Game node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init
{
    if((self = [super init])) {
        // Add at end of init
        self.state = kGameStatePlaying;
    }
    return self;
}

- (void)initializeGame
{
    delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[CCDirector sharedDirector] resume];
    s = [[CCDirector sharedDirector] winSize];
    
        
    [self startGame];
}

- (void)startGame
{    
    // Initilze the gameTime
    gameTime = 0.00f;
    
    // Create the score label in the top left of the screen
    int fSize = 18;
    scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Coins: 0"] 
                                    fontName:@"SF_Cartoonist_Hand_Bold.ttf" 
                                    fontSize:fSize];

    scoreLabel.anchorPoint = ccp(0,1);
    scoreLabel.position = ccp(1,s.height);
    [self addChild:scoreLabel];
    
    [self schedule:@selector(tick:)];
}

- (void)tick:(ccTime)dt
{
    
}

-(void)didScore
{
    score++;
    [scoreLabel setString:[NSString stringWithFormat:@"score:%i",score]];
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

}

- (void)gameOver
{    

}

- (void)pauseGame
{
    
}

- (void)resumeGame
{

}

- (void)mainMenu
{
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[MainMenu node]];
}

-(void)playAgain
{
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[[self class] node]];
}

- (void)onEnterTransitionDidFinish
{
    [[CCTouchDispatcher sharedDispatcher] addStandardDelegate:self priority:0];
    [[[CCDirector sharedDirector] openGLView] setMultipleTouchEnabled:YES];
    [self initializeGame];
}

- (void)onEnter
{
    
    [super onEnter];
}

- (void)onExit
{
    
    [super onExit];
}

- (void)dealloc
{
    
    CCLOG(@"dealloc: %@", self);
    [super dealloc];
}

@end