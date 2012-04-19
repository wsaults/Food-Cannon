//
//  AppDelegate.h
//  FoodCannon
//
//  Created by William Saults on 4/18/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlurryAnalytics.h"
#import "GKWizard.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    
    BOOL hasPlayedBefore;
    NSString *currentSkin;
    int timesPlayed,currentAction;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) RootViewController *viewController;

- (void)finishedWithScore:(double)score;
- (double)getHighScore;
- (void)pause;
- (void)resume;
- (BOOL)isGameScene;
- (NSString *)getCurrentSkin;
- (UIViewController *)getViewController;


@end