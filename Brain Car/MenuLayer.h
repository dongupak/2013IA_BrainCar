//
//  MenuLayer.h
//  Brain Car
//
//  Created by apple03 on 13. 5. 10..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface MenuLayer : CCLayer <GKLeaderboardViewControllerDelegate> {
    CCMenuItem *playMenuItem;
    CCMenuItem *howtoMenuItem;
    CCMenuItem *creditMenuItem;
    CCMenuItem *rankingMenuItem;
    
    CCSprite *subject;
    
    SimpleAudioEngine *audio;
    
    UIViewController *backView_1;
    
    UIWindow *window;
    UIView *landscapeView;
    
    CGSize size;
}

@property (nonatomic, retain) CCMenuItem *playMenuItem;
@property (nonatomic, retain) CCMenuItem *howtoMenuItem;
@property (nonatomic, retain) CCMenuItem *creditMenuItem;
@property (nonatomic, retain) CCMenuItem *rankingMenuItem;
@property (nonatomic, retain) UIViewController *backView_1;

-(void)makingBGM;
-(void)makingBackground;
-(void)makingButton;

-(void)runningAction;

-(void)goGame;
-(void)goCredit;
-(void)goHowto;

-(void)showLeaderboard;

+(CCScene *) scene;

@end
