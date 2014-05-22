//
//  MenuLayer.m
//  Brain Car
//
//  Created by apple03 on 13. 5. 10..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"
#import "SceneManager.h"
#import "AppDelegate.h"

#import "GameLayer.h"
#import "CreditLayer.h"
#import "GameOverLayer.h"
#import "HowtoLayer.h"


@implementation MenuLayer

@synthesize playMenuItem, howtoMenuItem, creditMenuItem, rankingMenuItem, backView_1;

enum{
    kTagMenu = 2000,
    kTagCreditMenu,
    kTagBackground,
};

-(id)init{
    if( (self = [super init]) ){
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        
        [localPlayer authenticateWithCompletionHandler:^(NSError *error){
            if(error == nil)
            {
                NSLog(@"인증 성공!");
            }
            else
            {
                NSLog(@"인증 실패!");
            }
        }];
        
        size = [[CCDirector sharedDirector]winSize];
    
        [self makingBGM];
        [self makingBackground];
        [self makingButton];
        [self runningAction];
    }
    
    return self;
}

-(void)makingBGM{
    audio = [SimpleAudioEngine sharedEngine];
    
    [audio stopBackgroundMusic];
    [audio playBackgroundMusic:@"main_bgm2.mp3" loop:YES];
}

-(void)makingBackground{
    CCSprite *background = [[CCSprite alloc]initWithFile:@"menu_bg.png"];
    background.anchorPoint = CGPointZero;
    [self addChild:background];
    
    subject = [CCSprite spriteWithFile:@"brain_car.png"];
    subject.position = ccp(size.width/4.1, size.height*7.0/9.0);
    [self addChild:subject];
}

-(void)makingButton{
    
    self.playMenuItem = [CCMenuItemImage itemWithNormalImage:@"start_button.png"
                                               selectedImage:@"start_button_click.png"
                                                      target:self
                                                    selector:@selector(goGame)];
    self.playMenuItem.position = ccp(size.width + 100, size.height*15.0/20.0);
    
    self.howtoMenuItem = [CCMenuItemImage itemWithNormalImage:@"howto_button.png"
                                                selectedImage:@"howto_button_click.png"
                                                       target:self
                                                     selector:@selector(goHowto)];
    self.howtoMenuItem.position = ccp(size.width + 100, size.height*11.0/20.0);
    
    self.rankingMenuItem = [CCMenuItemImage itemWithNormalImage:@"rank_button.png"
                                                  selectedImage:@"rank_button_click.png"
                                                         target:self
                                                       selector:@selector(showLeaderboard)];
    self.rankingMenuItem.position = ccp(size.width + 100, size.height*7.0/20.0);
    
    self.creditMenuItem = [CCMenuItemImage itemWithNormalImage:@"credit_button.png"
                                                 selectedImage:@"credit_button_click.png"
                                                        target:self
                                                      selector:@selector(goCredit)];
    creditMenuItem.position = ccp(size.width*2.0/20.0, -100);
    
    
    CCMenu *menu = [CCMenu menuWithItems:playMenuItem, howtoMenuItem, rankingMenuItem, nil];
    
    CCMenu *credit = [CCMenu menuWithItems:creditMenuItem, nil];

    [menu setPosition:ccp(0, 0)];
    [self addChild:menu z:1000 tag:kTagMenu];
    
    [credit setPosition:ccp(0, 0)];
    [self addChild:credit z:1000 tag:kTagCreditMenu];
}

-(void)runningAction{
    id scaleAction1 = [CCScaleTo actionWithDuration:0.5 scale:1.5];
    id scaleAction2 = [CCScaleTo actionWithDuration:0.5 scale:1.0];
    id scaleAction = [CCSequence actions:scaleAction1, scaleAction2, nil];
    
    id delayAction1 = [CCDelayTime actionWithDuration:1.0];
    id delayAction2 = [CCDelayTime actionWithDuration:1.2];
    id delayAction3 = [CCDelayTime actionWithDuration:1.4];
    id delayAction4 = [CCDelayTime actionWithDuration:1.6];
    
    id moveAction1 = [CCMoveTo actionWithDuration:0.2 position:ccp(size.width*15.0/20.0,size.height*15.0/20.0)];
    id moveAction2 = [CCMoveTo actionWithDuration:0.2 position:ccp(size.width*15.0/20.0,size.height*11.0/20.0)];
    id moveAction3 = [CCMoveTo actionWithDuration:0.2 position:ccp(size.width*15.0/20.0,size.height*7.0/20.0)];
    id moveAction4 = [CCMoveTo actionWithDuration:0.2 position:ccp(size.width*2.0/20.0, size.height*3.0/25.0)];
    
    id playAction = [CCSequence actions:delayAction1, moveAction1, nil];
    id howtoAction = [CCSequence actions:delayAction2, moveAction2, nil];
    id rankAction = [CCSequence actions:delayAction3, moveAction3, nil];
    id creditAction = [CCSequence actions:delayAction4, moveAction4, nil];
    
    [subject runAction:scaleAction];
    [self.playMenuItem runAction:playAction];
    [self.howtoMenuItem runAction:howtoAction];
    [self.rankingMenuItem runAction:rankAction];
    [self.creditMenuItem runAction:creditAction];
}



-(void)goGame{
    [audio playEffect:@"button_sound.wav"];
    [SceneManager goGame];
}
    
-(void)goCredit{
    [audio playEffect:@"button_sound.wav"];
    [SceneManager goCredit];
}
-(void)goHowto{
    [audio playEffect:@"button_sound.wav"];
    [SceneManager goHowto];
}

-(void)showLeaderboard{
    [audio playEffect:@"button_sound.wav"];
    //Leaderboard 나타내기
    
    //Leaderboard를 넣어줄 뷰를 생성
    backView_1 = [[UIViewController alloc] init];
    
    landscapeView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 480.0, 320.0)];
    CGAffineTransform tr = landscapeView.transform; // get current transform (portrait)
    tr = CGAffineTransformRotate(tr, (M_PI / 2.0)); // rotate 90 degrees to go landscape
    landscapeView.transform = tr; // set current transform (landscape)
    landscapeView.center = window.center;
    
    //리더보드 뷰컨트롤러를 생성
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if(leaderboardController != nil)
    {
        leaderboardController.leaderboardDelegate = self;
        
        //view를 backView로 바꿔야 cocos2d에서 Gamecenter Leaderboard가 나온다.
        
        [[(CCGLView *)[[CCDirector sharedDirector] view] window] addSubview:backView_1.view];
    
        //leaderboard를 backView에 모달뷰(여러 개의 뷰를 전환하기 위한 뷰 관리 방법 중 하나)로 단다.
        [backView_1 presentViewController:leaderboardController animated:YES completion:nil];
    }
}

-(void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController{
    //LeaderboardView가 닫힐때
    [backView_1 dismissViewControllerAnimated:YES completion:nil];
    [backView_1.view.window removeFromSuperview];
    
    [SceneManager goMenu];
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

@end
