//
//  GameOverLayer.h
//  Brain Car
//
//  Created by apple03 on 13. 5. 10..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AppDelegate.h"

@interface GameOverLayer : CCLayer {
    AppController *appDelegate;
    
    CGSize size;
    
    NSInteger totalScore;
    float totalDistance;
}

-(void)goGame;
-(void)goMenu;

-(void)createMenu;
-(void)createLabel;
-(void)createAction;

+(CCScene *) scene;

@end
