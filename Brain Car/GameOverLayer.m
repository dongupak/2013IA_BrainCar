//
//  GameOverLayer.m
//  Brain Car
//
//  Created by apple03 on 13. 5. 10..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
#import "SceneManager.h"


@implementation GameOverLayer

-(id)init{
    if( (self = [super init]) ){
        appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
        
        totalScore = appDelegate.score;
        totalDistance = appDelegate.distance;
        
        size = [[CCDirector sharedDirector] winSize];
        
        [self createLabel];
        [self createBackground];
        [self createMenu];
        [self createAction];
    }
    
    return self;
}

-(void)createBackground{
    CCSprite *bgSprite = [CCSprite spriteWithFile:@"gameover_score.png"];
    
    bgSprite.position = ccp(size.width / 2.0, size.height*3.0 / 8.0);
    bgSprite.scale = 1.3;
    
    [self addChild:bgSprite z:200];
}

-(void)createAction{
    CCSprite *bgSprite = [CCSprite spriteWithFile:@"ambulance_1.png"];
    bgSprite.flipX = YES;
    bgSprite.position = ccp(-100,size.height*4.0/5.0);
    [self addChild:bgSprite z:201];
    
    CCSprite *gameOver = [CCSprite spriteWithFile:@"gameover.png"];
    gameOver.position = ccp(-400,size.height*4.0/5.0);
    [self addChild:gameOver z:200];
    
    CCAnimation *animation = [[CCAnimation alloc] init];
    
    for (int i=1; i<4; i++) {
        NSString *str = [NSString stringWithFormat:@"ambulance_%d.png",i];
        [animation addSpriteFrameWithFilename:str];
    }
    [animation setDelayPerUnit:0.1];
    
    CCAnimate *ani = [CCAnimate actionWithAnimation:animation];
    ani = [CCRepeatForever actionWithAction:ani];
    [bgSprite runAction:ani];
    
    id move = [CCMoveTo actionWithDuration:3.0f position:ccp(size.width+200,size.height*4.0/5.0)];
    id move2 = [CCMoveTo actionWithDuration:2.5f position:ccp(size.width/2.0,size.height*4.0/5.0)];
    [bgSprite runAction:move];
    [gameOver runAction:move2];
}

-(void)createLabel{
    NSString *str = [[NSString alloc] initWithFormat:@"YourScore : %d", totalScore];
    CCLabelTTF *score = [CCLabelTTF labelWithString:str
                                           fontName:@"Marker felt"
                                           fontSize:25];
    score.position = ccp(size.width/2.0, size.height *3.0/6.0);
    [self addChild:score z:201];
    
    str = [[NSString alloc] initWithFormat:@"YourDistance : %.2f", totalDistance];
    CCLabelTTF *distance = [CCLabelTTF labelWithString:str
                                              fontName:@"Marker felt"
                                              fontSize:25];
    distance.position = ccp(size.width/2.0, size.height *2.0/6.0);
    [self addChild:distance z:201];

}

-(void)createMenu{
    CCMenuItem *home = [CCMenuItemImage itemWithNormalImage:@"menu_bt_1.png"
                                              selectedImage:@"menu_bt_2.png"
                                                     target:self
                                                   selector:@selector(goMenu)];
    CCMenuItem *replay = [CCMenuItemImage itemWithNormalImage:@"repaly_bt_1.png"
                                                selectedImage:@"repaly_bt_2.png"
                                                       target:self
                                                     selector:@selector(goGame)];
    
    CCMenu *menu = [CCMenu menuWithItems:home, replay, nil];
    menu.position = ccp(size.width/2.0, size.height*1.0/5.0);
    [menu alignItemsHorizontallyWithPadding:50];
    [self addChild:menu z:201];
}


-(void)goGame{
    [SceneManager goGame];
}

-(void)goMenu{
    [SceneManager goMenu];
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverLayer *layer = [GameOverLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

@end
