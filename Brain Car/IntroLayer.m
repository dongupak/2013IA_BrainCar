//
//  IntroLayer.m
//  Cocos2dGame
//
//  Created by DongGyu Park on 13. 2. 14..
//  Copyright __MyCompanyName__ 2013년. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "SceneManager.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(void) onEnter
{
	[super onEnter];

	// ask director for the window size
	CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCSprite *background;
    background = [CCSprite spriteWithFile:@"intro.png"];
    background.position = ccp(size.width/2, size.height/2);
    background.opacity = 0;
    
    // add the label as a child to this Layer
    [self addChild:background];
    
    id actionIntro = [CCFadeTo actionWithDuration:3.0 opacity:255];
    id actionIntro2 = [CCFadeTo actionWithDuration:3.0 opacity:0];
    id actionIntroTotal = [CCSequence actions:actionIntro, actionIntro2, nil];
    [background runAction:actionIntroTotal];
    
    // In one second transition to the new scene
    [self scheduleOnce:@selector(makeTransition:) delay:6.5];
}

-(void) makeTransition:(ccTime)dt
{
	[SceneManager goMenu];
}
@end
