//
//  AppDelegate.h
//  Brain Car
//
//  Created by apple03 on 13. 5. 10..
//  Copyright __MyCompanyName__ 2013년. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_;     // weak ref
    
    SimpleAudioEngine *audio;
    
    NSInteger score;
    float distance;
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (readwrite) NSInteger score;
@property (readwrite) float distance;

@end
