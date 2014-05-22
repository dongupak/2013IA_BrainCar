//
//  GameLayer.h
//  Brain Car
//
//  Created by apple03 on 13. 5. 10..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

#import "MessageNode.h"

@interface GameLayer : CCLayerColor <GKLeaderboardViewControllerDelegate> {
    CGSize size;
    
    NSInteger randomSignal;
    NSInteger level;
    NSInteger count;
    NSInteger userCount;
    NSInteger computerCount;
    NSInteger life;
    float fuel;
    
    UIViewController *backView;
    
    BOOL myTurn;
    BOOL gameOn;
    BOOL actionOn;
    
    AppController *appDelegate;
    
    SimpleAudioEngine *audio;
    
    MessageNode *message;
    
    CCProgressTimer *ptEnergy;
    CCSprite *ptEnergyWarn;
    
    CCLabelTTF *scoreLabel;
    CCLabelTTF *lifeLabel;
    
    int gameArrayUser[100];
    int gameArrayComputer[100];
    
    CCNode *itemNode;
    CCNode *signalNode;
    CCNode *pauseNode;
    
    CCSprite *red;
    CCSprite *yellow;
    CCSprite *black;
    CCSprite *green;
    
    CCSprite *item_life;
    CCSprite *item_fuel;
    
    CCSprite *red_s;
    CCSprite *yellow_s;
    CCSprite *black_s;
    CCSprite *green_s;
    
    CCSprite *bgSprite;
    
    CCSprite *scoreSprite;
    
    CCSprite *break1;
    CCSprite *break2;
    CCSprite *break3;
    CCSprite *break4;
    
    CCMenuItem *pauseSprite;
}

@property (nonatomic, retain) CCMenuItem *pauseSprite;
@property (nonatomic, retain) MessageNode *message;

@property (nonatomic, retain) CCSprite *red;
@property (nonatomic, retain) CCSprite *yellow;
@property (nonatomic, retain) CCSprite *black;
@property (nonatomic, retain) CCSprite *green;

@property (nonatomic, retain) CCSprite *red_s;
@property (nonatomic, retain) CCSprite *yellow_s;
@property (nonatomic, retain) CCSprite *black_s;
@property (nonatomic, retain) CCSprite *green_s;

@property (nonatomic, retain) CCSprite *item_life;
@property (nonatomic, retain) CCSprite *item_fuel;

@property (nonatomic, retain) CCLabelTTF *scoreLabel;
@property (nonatomic, retain) CCLabelTTF *lifeLabel;

-(void)goMenu;
-(void)goGameOver;

-(void)readyGame;
-(void)endReady;

-(void)pauseScene;
-(void)pauseCheck:(CCMenuItem *)sender;

-(void)correctCheck;
-(void)lifeCheck:(BOOL)item;

-(void)createEnergyBar;
-(void)updateEnergyBar;

-(void)randItem;
-(void)makingItem;
-(void)makingBackground;
-(void)makingSprite;
-(void)makingLabel;
-(void)makingButton;
-(void)makingSignal;
-(void)scaleSignal;
-(void)removeSignal;
-(void)tempCheckGameOn;
-(void)checkGameOn;
-(void)gameTimer;

-(void)playAudio;

-(void)startGame;
-(void)opacitySpriteUp:(CCSprite*)sprite;
-(void)opacitySpriteDown:(CCSprite*)sprite;

+(CCScene *) scene;

@end
