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

@synthesize state = _state, adWhirlView, texture;

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
    
#pragma mark - Bottom body sprite
    // Bottom sprite
    _bottomSprite = [CCSprite spriteWithFile:@"bottomTexture.png"
                     rect:CGRectMake(0, 0, 320, 2.5)];
    _bottomSprite.position = ccp(winSize.width/2, 5);
    _bottomSprite.tag = 2;
    [self addChild:_bottomSprite];
    
    // Create bottom sprite body 
    b2BodyDef bottomBodyDef;
    bottomBodyDef.type = b2_dynamicBody;
    bottomBodyDef.position.Set(winSize.width/2/PTM_RATIO, 5/PTM_RATIO);
    bottomBodyDef.userData = _bottomSprite;
    _bottomBody = _world->CreateBody(&bottomBodyDef);
    
    // Create bottom sprite shape
    b2PolygonShape bottomSpriteShape;
    bottomSpriteShape.SetAsBox(_bottomSprite.contentSize.width/PTM_RATIO/2, 
                         _bottomSprite.contentSize.height/PTM_RATIO/2);
    
    // Create shape definition and add to body
    bottomShapeDef.shape = &bottomSpriteShape;
    bottomShapeDef.density = 0.5f;
    bottomShapeDef.friction = 0.000f;
    bottomShapeDef.restitution = 0.0f;
    _bottomSpriteFixture = _bottomBody->CreateFixture(&bottomShapeDef);
    
    // Restrict paddle along the x axis
    b2PrismaticJointDef jointDef;
    b2Vec2 worldAxis(1.0f, 1.0f);
    jointDef.collideConnected = true;
    jointDef.Initialize(_bottomBody, _groundBody, 
                        _bottomBody->GetWorldCenter(), worldAxis);
    _world->CreateJoint(&jointDef);
    // end bottom sprite
    
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
    
#pragma mark - Create ball code used to be here

    // Create the contact listener
    _contactListener = new MyContactListener();
    _world->SetContactListener(_contactListener);
    
    [self schedule:@selector(tick:)];
}

- (void)tick:(ccTime)dt
{
    if (!isPaused) {
        // The game time.
        // Time remaing = 60 seconds - gameTime
        gameTime += dt;
        
        #pragma mark - Moves the objects around the screen
            // Moves the objects around the screen
            _world->Step(dt, 10, 10);    
            for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {    
                if (b->GetUserData() != NULL) {
                    CCSprite *sprite = (CCSprite *)b->GetUserData();                        
                    sprite.position = ccp(b->GetPosition().x * PTM_RATIO,
                                          b->GetPosition().y * PTM_RATIO);
                    sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
                    
                    if (sprite.tag == 1) {
                        static int maxSpeed = 15;
                        
                        b2Vec2 velocity = b->GetLinearVelocity();
                        float32 speed = velocity.Length();
                        
                        if (speed > maxSpeed) {
                            b->SetLinearDamping(0.5);
                        } else if (speed < maxSpeed) {
                            b->SetLinearDamping(0.0);
                        }
                        
                    }
                }
            }
            
#pragma mark - Destroy sprite.
            std::vector<b2Body *>toDestroy;
            std::vector<MyContact>::iterator pos;
            for(pos = _contactListener->_contacts.begin(); 
                pos != _contactListener->_contacts.end(); ++pos) {
                MyContact contact = *pos;
                
                if ((contact.fixtureA == _bottomFixture && contact.fixtureB == _ballFixture) ||
                    (contact.fixtureA == _ballFixture && contact.fixtureB == _bottomFixture)) {
                    NSLog(@"Ball hit bottom!");
                }
                
                b2Body *bodyA = contact.fixtureA->GetBody();
                b2Body *bodyB = contact.fixtureB->GetBody();
                if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
                    CCSprite *spriteA = (CCSprite *) bodyB->GetUserData();
                    CCSprite *spriteB = (CCSprite *) bodyA->GetUserData();
                    
                    // Sprite A = ball, Sprite B = Block
                    if (spriteA.tag == 1 && spriteB.tag == 2) {
                        if (std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end()) {
                            toDestroy.push_back(bodyB);
                        }
                    }
                    // Sprite B = block, Sprite A = ball
                    else if (spriteA.tag == 2 && spriteB.tag == 1) {
                        if (std::find(toDestroy.begin(), toDestroy.end(), bodyA) == toDestroy.end()) {
                            toDestroy.push_back(bodyA);
                        }
                    }        
                }
            }
        std::vector<b2Body *>::iterator pos2;
        for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
            b2Body *body = *pos2;     
            if (body->GetUserData() != NULL) {
                CCSprite *sprite = (CCSprite *) body->GetUserData();
                [self removeChild:sprite cleanup:YES];
                numberOfObjects--;
                CCLOG(@"Object Destroyed, number of objects is: %d", numberOfObjects);
            }
            _world->DestroyBody(body);
        }
        
        if (numberOfObjects < 1) {
            [self createObject];
        }
        
    }// end if (!isPaused)
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

-(void)createObject
{
    // Create an object here
#pragma mark - Lets make a ball
    // Create sprite and add it to the layer
    CCSprite *ball = [CCSprite spriteWithFile:@"Ball.png" 
                                         rect:CGRectMake(0, 0, 52, 52)];
    ball.position = ccp(100, 100);
    ball.tag = 1;
    [self addChild:ball];
    
    // Create ball body 
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(100/PTM_RATIO, 100/PTM_RATIO);
    ballBodyDef.userData = ball;
    b2Body * ballBody = _world->CreateBody(&ballBodyDef);
    
    // Create circle shape
    b2CircleShape circle;
    circle.m_radius = 26.0/PTM_RATIO;
    
    // Create shape definition and add to body
    ballShapeDef.shape = &circle;
    ballShapeDef.density = 1.0f;
    ballShapeDef.friction = 0.001f;
    ballShapeDef.restitution = 1.0f;
    _ballFixture = ballBody->CreateFixture(&ballShapeDef);
    
    b2Vec2 force = b2Vec2(10, 10);
    ballBody->ApplyLinearImpulse(force, ballBodyDef.position);
    // end ball
    
    numberOfObjects++;
    CCLOG(@"Object created, number of objects is: %d", numberOfObjects);
}

- (void)dealloc
{
    delete _world;
    _groundBody = NULL;
    delete _contactListener;
    CCLOG(@"dealloc: %@", self);
    [super dealloc];
}

@end