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
    
#pragma mark - Lets make a world
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    // Create a world
    gravity = b2Vec2(0.0f, 0.0f);
    bool doSleep = true;
    _world = new b2World(gravity, doSleep);
    
    // Create edges around the entire screen
    b2BodyDef groundBodyDef;
    
    // Right bounds
    groundBodyDef.position.Set(0,0);
    _groundBody = _world->CreateBody(&groundBodyDef);
    b2PolygonShape groundBox;
    b2FixtureDef groundBoxDef;
    groundBoxDef.shape = &groundBox;
    
    // Bottom bounds
    groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(winSize.width/PTM_RATIO,0));
    _bottomFixture = _groundBody->CreateFixture(&groundBoxDef);
    
    // Left bounds
    groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(0, winSize.height/PTM_RATIO));
    _groundBody->CreateFixture(&groundBoxDef);
    
    // Top bounds
    groundBox.SetAsEdge(b2Vec2(0, winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO, 
                                                                    winSize.height/PTM_RATIO));
    _groundBody->CreateFixture(&groundBoxDef);
    groundBox.SetAsEdge(b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO), 
                        b2Vec2(winSize.width/PTM_RATIO, 0));
    _groundBody->CreateFixture(&groundBoxDef);
    
    
#pragma mark - Lets make a ball
    // Create sprite and add it to the layer
    CCSprite *ball = [CCSprite spriteWithFile:@"Ball.png" 
                                         rect:CGRectMake(0, 0, 52, 52)];
    ball.position = ccp(100, 100);
    ball.tag = 1;
    [self addChild:ball];
    
    // Create ball body 
    b2BodyDef cat1BodyDef;
    cat1BodyDef.type = b2_dynamicBody;
    cat1BodyDef.position.Set(100/PTM_RATIO, 100/PTM_RATIO);
    cat1BodyDef.userData = ball;
    b2Body * cat1Body = _world->CreateBody(&cat1BodyDef);
    
    // Create circle shape
    b2CircleShape circle;
    circle.m_radius = 26.0/PTM_RATIO;
    
    // Create shape definition and add to body
    cat1ShapeDef.shape = &circle;
    cat1ShapeDef.density = 1.0f;
    cat1ShapeDef.friction = 0.001f;
    cat1ShapeDef.restitution = 1.0f;
    _cat1Fixture = cat1Body->CreateFixture(&cat1ShapeDef);
    
    b2Vec2 force = b2Vec2(10, 10);
    cat1Body->ApplyLinearImpulse(force, cat1BodyDef.position);
    // end ball

    
    
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