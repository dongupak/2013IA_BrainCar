//
//  GameLayer.m
//  Brain Car
//
//  Created by apple03 on 13. 5. 10..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "SceneManager.h"

#define RED     1
#define YELLOW  2
#define BLACK   3
#define GREEN   4

enum{
    kTagSignal = 1000,
    kTagHome,
    kTagRed,
    kTagYellow,
    kTagBlack,
    kTagGreen,
    kTagRedSelect,
    kTagYellowSelect,
    kTagBlackSelect,
    kTagGreenSelect,
    kTagBreak1,
    kTagBreak2,
    kTagBreak3,
    kTagBackground,
    kTagMessage,
    kTagLifeItem,
    kTagFuelItem,
};

@implementation GameLayer

@synthesize red, yellow, black, green;
@synthesize red_s, yellow_s, black_s, green_s;
@synthesize item_life, item_fuel;
@synthesize scoreLabel, lifeLabel;
@synthesize message, pauseSprite;

-(id)init{
    if( (self = [super initWithColor:ccc4(255, 255, 255, 255)]) ){
        
        size = [[CCDirector sharedDirector]winSize];
        
        self.message = [MessageNode node];
		[self addChild:self.message z:201 tag:kTagMessage];
        
        itemNode = [CCNode node];
        signalNode = [CCNode node];
        pauseNode = [CCNode node];
        
        [self addChild:itemNode z:201];
        [self addChild:signalNode z:201];
        [self addChild:pauseNode z:210];
        
        randomSignal = 0;
        level = 1;
        count = 0;
        userCount = 0;
        computerCount = 0;
        life = 3;
        fuel = 90;
        myTurn = NO;
        
        gameOn = YES;
        actionOn = NO;

        self.isTouchEnabled = YES;
        
        appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
        appDelegate.score = 0;
        appDelegate.distance = 0;
        
        [self playAudio];
        [self createEnergyBar];
        [self makingBackground];
        [self makingButton];
        [self makingSprite];
        [self makingLabel];
        
        [audio playEffect:@"countdown.mp3"];
        [self performSelector:@selector(readyGame) withObject:nil afterDelay:0.19f];
    }
    return self;
}

-(void)readyGame{
    CCSprite *startImage1 = [CCSprite spriteWithFile:@"start_3.png"];
    CCSprite *startImage2 = [CCSprite spriteWithFile:@"start_2.png"];
    CCSprite *startImage3 = [CCSprite spriteWithFile:@"start_1.png"];
    CCSprite *startImage4 = [CCSprite spriteWithFile:@"start_go.png"];
    
    startImage1.opacity = 0;
    startImage2.opacity = 0;
    startImage3.opacity = 0;
    startImage4.opacity = 0;
    
    startImage1.position = ccp(size.width/2.0, size.height/2.0);
    startImage2.position = ccp(size.width/2.0, size.height/2.0);
    startImage3.position = ccp(size.width/2.0, size.height/2.0);
    startImage4.position = ccp(size.width/2.0, size.height/2.0);
    
    [self addChild:startImage1 z:209];
    [self addChild:startImage2 z:209];
    [self addChild:startImage3 z:209];
    [self addChild:startImage4 z:209];
    
    id opacityUp = [CCFadeTo actionWithDuration:0.5 opacity:255];
    id opacityDown = [CCFadeTo actionWithDuration:0.5 opacity:0];
    
    id scaleUp = [CCScaleTo actionWithDuration:1.0 scale:1.3];
    
    id opacityAction = [CCSequence actions:opacityUp, opacityDown, nil];
    id spawnAction = [CCSpawn actions:opacityAction, scaleUp, nil];
    
    id delayAction1 = [CCDelayTime actionWithDuration:1.0];
    id delayAction2 = [CCDelayTime actionWithDuration:2.0];
    id delayAction3 = [CCDelayTime actionWithDuration:3.0];
    
    [startImage1 runAction:spawnAction];
    [startImage2 runAction:[CCSequence actions:delayAction1, [spawnAction copy], nil]];
    [startImage3 runAction:[CCSequence actions:delayAction2, [spawnAction copy], nil]];
    [startImage4 runAction:[CCSequence actions:delayAction3, [spawnAction copy], nil]];
    
    [self performSelector:@selector(endReady) withObject:nil afterDelay:4.0];
}

-(void)endReady{
    [self makingSignal];
    [self performSelector:@selector(startGame) withObject:nil afterDelay:1.5];
    
    [self schedule:@selector(randItem) interval:7.0];
    [self schedule:@selector(gameTimer) interval:1/60];
}

-(void)pauseScene{
    self.isTouchEnabled = NO;
    [[CCDirector sharedDirector] pause];
    
    CCSprite *pauseBackground = [CCSprite spriteWithFile:@"pause_bg.png"];
    pauseBackground.position = ccp(size.width/2.0, size.height/2.0);
    [pauseNode addChild:pauseBackground];
    
    CCMenuItem *resumeLabel = [CCMenuItemFont itemWithString:@"Resume"
                                                      target:self
                                                    selector:@selector(pauseCheck:)];
    resumeLabel.tag = 1000;
    
    CCMenuItem *homeLabel = [CCMenuItemFont itemWithString:@"Home"
                                                      target:self
                                                  selector:@selector(pauseCheck:)];
    homeLabel.tag = 1001;
    CCMenu *menu = [CCMenu menuWithItems:resumeLabel, homeLabel, nil];
    menu.position = ccp(size.width/2.0, size.height/2.0);
    [menu alignItemsVerticallyWithPadding:20.0];
    
    [pauseNode addChild:menu z:2];
    
    CCSprite *pauseBg = [CCSprite spriteWithFile:@"pause_stop_0.png"];
    pauseBg.position = ccp(size.width*0.94/2.0, size.height*1.1/2.0);
    [pauseNode addChild:pauseBg z:1];
}

-(void)pauseCheck:(CCMenuItem *)sender{
    if(sender.tag == 1000){
        self.isTouchEnabled = YES;
        [[CCDirector sharedDirector] resume];
        [pauseNode removeAllChildrenWithCleanup:YES];
    }
    else if(sender.tag == 1001){
        [[CCDirector sharedDirector] resume];
        [SceneManager goMenu];
    }
}

-(void)correctCheck{
    for(int i = 0; i < level; i++){
        if(gameArrayComputer[i] == gameArrayUser[i]){
            count++;
            appDelegate.score += 10;
            NSString *str = [[NSString alloc] initWithFormat:@"%d",appDelegate.score];
            [self.scoreLabel setString:str];
        }
        else{
            break;
        }
    }
    
    if(count == level){
        [audio playEffect:@"correct_sound.wav"];
        [message showMessage:CORRECT_MESSAGE];
        
        count = 0;
        level++;
        
        NSString *str = [[NSString alloc] initWithFormat:@"Stage : %d", level];
        [self.lifeLabel setString:str];
    }
    else{
        [message showMessage:WRONG_MESSAGE];
        
        count = 0;
        life--;
        
        [self lifeCheck:NO];
        
        if(life == 0){
            [self performSelector:@selector(goGameOver)
                       withObject:nil
                       afterDelay:1.0f];
            [self unscheduleAllSelectors];
            [audio stopBackgroundMusic];
        }
    }
    
    for(int i = 0; i < level; i++){
        gameArrayUser[i] = 0;
        gameArrayComputer[i] = 20;
    }
}

-(void)lifeCheck:(BOOL)item{
    if(item == NO){
        switch (life) {
            case 2:
                break1.opacity = 200;
                [audio playEffect:@"break1.mp3"];
                break;
            case 1:
                break1.opacity = 0;
                break2.opacity = 200;
                [audio playEffect:@"break1.mp3"];
                break;
            case 0:
                break2.opacity = 0;
                break3.opacity = 200;
                [audio playEffect:@"break2.mp3"];
                break;
            default:
                break;
        }
    }
    else if(item == YES){
        switch (life) {
            case 3:
                break1.opacity = 0;
                break;
            case 2:
                break1.opacity = 200;
                break2.opacity = 0;
                break;
            default:
                break;
        }
    }
}

-(void)createEnergyBar
{
    CCSprite *ptEnergyEmpty = [CCSprite spriteWithFile:@"fuel_empty.png"];
    ptEnergyEmpty.anchorPoint = ccp(0.5, 0.5);
    ptEnergyEmpty.position = ccp(size.width*3.0/5.0, size.height*2.0/21.0);
    [self addChild:ptEnergyEmpty z:205];
    
    ptEnergyWarn = [CCSprite spriteWithFile:@"fuel_warning.png"];
    ptEnergyWarn.anchorPoint = ccp(0.5, 0.5);
    ptEnergyWarn.position = ccp(size.width*5.75/10.0, size.height*2.1/21.0);
    ptEnergyWarn.opacity = 0;
    [self addChild:ptEnergyWarn z:204];
    
    CCSprite *ptEnergyFull = [CCSprite spriteWithFile:@"fuel_full.png"];
    
    ptEnergy = [CCProgressTimer progressWithSprite:ptEnergyFull];
    ptEnergy.type = kCCProgressTimerTypeBar;
    ptEnergy.midpoint = ccp(0, 0.5);
    ptEnergy.barChangeRate = ccp(1, 0);
    ptEnergy.anchorPoint = ccp(0.5, 0.5);
    ptEnergy.position = ccp(size.width*3.0/5.0, size.height*2.0/21.0);
    ptEnergy.percentage = 100;
    [self addChild:ptEnergy z:206];
}

-(void)updateEnergyBar
{
    ptEnergy.percentage = fuel;
    
    id blinkAction = [CCBlink actionWithDuration:20.0 blinks:40.0];
    
    if(fuel <= 35){
        if (actionOn == NO){
            ptEnergyWarn.opacity = 255;
            [blinkAction setTag:230];
            [ptEnergy runAction:blinkAction];
            [ptEnergyWarn runAction:[blinkAction copy]];
            actionOn = YES;
            [audio stopBackgroundMusic];
            [audio playBackgroundMusic:@"ding.mp3" loop:YES];
        }
    }
    else if(fuel > 35){
        ptEnergy.opacity = 0;
        ptEnergy.opacity = 255;
        ptEnergyWarn.opacity = 255;
        ptEnergyWarn.opacity = 0;
        if (actionOn == YES){
            [ptEnergy stopAllActions];
            [ptEnergyWarn stopAllActions];
            actionOn = NO;
            [audio stopBackgroundMusic];
            [audio playBackgroundMusic:@"main_bgm2.mp3" loop:YES];
        }
    }
}


-(void)randItem{
    NSInteger itemRand = arc4random() % 4 + 3;
    
    [self performSelector:@selector(makingItem) withObject:nil afterDelay:itemRand];
}

-(void)makingItem{
    NSInteger itemNum = arc4random() % 2;
    
    id lifeMove = [CCMoveTo actionWithDuration:1.7 position:ccp(-100, size.height/4.0)];
    id lifeScale = [CCScaleBy actionWithDuration:1.0 scale:1.7];
    id fuelMove = [CCMoveTo actionWithDuration:1.7 position:ccp(size.width + 100, size.height/4.0)];
    id fuelScale = [CCScaleBy actionWithDuration:1.0 scale:1.7];
    
    id lifeAction = [CCSpawn actions:lifeMove, lifeScale, nil];
    id fuelAction = [CCSpawn actions:fuelMove, fuelScale, nil];
    
    item_life = [CCSprite spriteWithFile:@"item_life.png"];
    item_fuel = [CCSprite spriteWithFile:@"item_fuel.png"];
    
    item_life.position = ccp(size.width*2.0/6.0, size.height/2.0);
    item_fuel.position = ccp(size.width*4.0/6.0, size.height/2.0);
    
    switch (itemNum) {
        case 0:
            [itemNode addChild:item_life z:0 tag:kTagLifeItem];
            [item_life runAction:lifeAction];
            break;
        case 1:
            [itemNode addChild:item_fuel z:0 tag:kTagFuelItem];
            [item_fuel runAction:fuelAction];
            break;
    }
}

-(void)makingBackground{
    bgSprite = [CCSprite spriteWithFile:@"main_bg_1.png"];
    [self addChild:bgSprite z:200];
    
    CCAnimation *animation = [[CCAnimation alloc] init];
    
    for (int i=1; i<4; i++) {
        NSString *str = [NSString stringWithFormat:@"main_bg_%d.png",i];
       [animation addSpriteFrameWithFilename:str];
    }
    [animation setDelayPerUnit:0.1];
    
    CCAnimate *ani = [CCAnimate actionWithAnimation:animation];
    ani = [CCRepeatForever actionWithAction:ani];
    [bgSprite runAction:ani];
    
    CCSprite *carSprite = [CCSprite spriteWithFile:@"main_car_bg.png"];
    carSprite.position = ccp(size.width/2.0, size.height/2.0);
    [self addChild:carSprite z:203];
}

-(void)makingSprite{
    break1 = [CCSprite spriteWithFile:@"break_1.png"];
    break2 = [CCSprite spriteWithFile:@"break_2.png"];
    break3 = [CCSprite spriteWithFile:@"break_3.png"];
    
    scoreSprite = [CCSprite spriteWithFile:@"score.png"];
    scoreSprite.position = ccp(size.width * 12.0 / 15.0, size.height * 18.5 / 20.0);
    [self addChild:scoreSprite z:203];
    
    break1.position = ccp(size.width/2.0, size.height/2.0);
    break1.opacity = 0;
    break2.position = ccp(size.width/2.0, size.height/2.0);
    break2.opacity = 0;
    break3.position = ccp(size.width/2.0, size.height/2.0);
    break3.opacity = 0;
    
    bgSprite.position = ccp(size.width/2.0, size.height/2.0);
    
    [self addChild:break1 z:202 tag:kTagBreak1];
    [self addChild:break2 z:202 tag:kTagBreak2];
    [self addChild:break3 z:202 tag:kTagBreak3];
    
    pauseSprite = [CCMenuItemImage itemWithNormalImage:@"pause_bt.png"
                                         selectedImage:@"pause_bt.png"
                                                target:self
                                              selector:@selector(pauseScene)];
    CCMenu *menu = [CCMenu menuWithItems:pauseSprite, nil];
    menu.position = ccp(size.width/20.0, size.height*18.2/20.0);
    [self addChild:menu z:201];
}

-(void)makingLabel{
    CCLabelTTF *label = [[CCLabelTTF alloc] initWithString:@"0" fontName:@"Arial" fontSize:22];
    
    self.scoreLabel = label;
    self.scoreLabel.color = ccBLACK;
    self.scoreLabel.position = ccp(size.width * 13.0 / 15.0, size.height * 18.5 / 20.0);
    [self addChild:self.scoreLabel z:203];
    
    label = [[CCLabelTTF alloc] initWithString:@"Stage : 1" fontName:@"Arial" fontSize:22];
    self.lifeLabel = label;
    self.lifeLabel.color = ccBLACK;
    self.lifeLabel.position = ccp(size.width*3.0/ 15.0, size.height * 18.5 / 20.0);
    [self addChild:self.lifeLabel z:203];
}

-(void)makingButton{
    red = [CCSprite spriteWithFile:@"red_1.png"];
    yellow = [CCSprite spriteWithFile:@"yellow_1.png"];
    black = [CCSprite spriteWithFile:@"black_1.png"];
    green = [CCSprite spriteWithFile:@"green_1.png"];
    
    red_s = [CCSprite spriteWithFile:@"red_2.png"];
    yellow_s = [CCSprite spriteWithFile:@"yellow_2.png"];
    black_s = [CCSprite spriteWithFile:@"black_2.png"];
    green_s = [CCSprite spriteWithFile:@"green_2.png"];
    
    red.position = ccp(size.width*3.0/5.0, size.height/3.0);
    yellow.position = ccp(size.width*3.0/5.0, size.height/3.0);
    black.position = ccp(size.width*3.0/5.0, size.height/3.0);
    green.position = ccp(size.width*3.0/5.0, size.height/3.0);
    
    red.scale = 0.2;
    yellow.scale = 0.2;
    black.scale = 0.2;
    green.scale = 0.2;
    
    red_s.position = ccp(size.width*5.9/20.0, size.height*10.1/14.0);
    yellow_s.position = ccp(size.width*8.9/20.0, size.height*10.1/14.0);
    black_s.position = ccp(size.width*11.9/20.0, size.height*10.1/14.0);
    green_s.position = ccp(size.width*14.8/20.0, size.height*10.1/14.0);
    
    red_s.opacity = 0;
    yellow_s.opacity = 0;
    black_s.opacity = 0;
    green_s.opacity = 0;
    
    [self addChild:red z:201 tag:kTagRed];
    [self addChild:yellow z:201 tag:kTagYellow];
    [self addChild:black z:201 tag:kTagBlack];
    [self addChild:green z:201 tag:kTagGreen];
    
    [self addChild:red_s z:201 tag:kTagRedSelect];
    [self addChild:yellow_s z:201 tag:kTagYellowSelect];
    [self addChild:black_s z:201 tag:kTagBlackSelect];
    [self addChild:green_s z:201 tag:kTagGreenSelect];
}

-(void)makingSignal{
    CCSprite *signal = [CCSprite spriteWithFile:@"signal.png"];
    signal.position = ccp(size.width*11.5/20.0, size.height*4.0/12.0);
    signal.scale = 0.05;
    [signalNode addChild:signal z:200 tag:kTagSignal];
    
    [red runAction:[CCSpawn actions:[CCScaleTo actionWithDuration:1.0 scale:1.0],
                    [CCMoveTo actionWithDuration:1.0 position:ccp(size.width*5.9/20.0, size.height*5.0/7.0)]
                    ,nil]];
    [yellow runAction:[CCSpawn actions:[CCScaleTo actionWithDuration:1.0 scale:1.0],
                       [CCMoveTo actionWithDuration:1.0 position:ccp(size.width*8.9/20.0, size.height*5.0/7.0)]
                       ,nil]];
    [black runAction:[CCSpawn actions:[CCScaleTo actionWithDuration:1.0 scale:1.0],
                      [CCMoveTo actionWithDuration:1.0 position:ccp(size.width*11.9/20.0, size.height*5.0/7.0)]
                      ,nil]];
    [green runAction:[CCSpawn actions:[CCScaleTo actionWithDuration:1.0 scale:1.0],
                      [CCMoveTo actionWithDuration:1.0 position:ccp(size.width*14.9/20.0, size.height*5.0/7.0)]
                      ,nil]];
    
    id signalScale2 = [CCScaleTo actionWithDuration:1.0 scale:1.05];
    id signalMove = [CCMoveTo actionWithDuration:1.0 position:ccp(size.width*2.5/4.0, size.height*3.5/8.0)];
    id signalScale = [CCSpawn actions:signalMove, signalScale2, nil];
    [signal runAction:signalScale];
    
    [self performSelector:@selector(tempCheckGameOn) withObject:nil afterDelay:1.0];
}

-(void)scaleSignal{
    for(CCSprite *tempSignal in [signalNode children]){
        if(tempSignal.position.x == size.width*2.5/4.0){
            id signalScale = [CCScaleTo actionWithDuration:0.4 scale:1.5];
            [tempSignal runAction:signalScale];
        }
    }
    
    [red runAction:[CCSpawn actions:[CCScaleTo actionWithDuration:0.4 scale:1.5],
                    [CCMoveTo actionWithDuration:0.4 position:ccp(size.width*2.5/20.0, size.height*6.2/7.0)]
                    ,nil]];
    [yellow runAction:[CCSpawn actions:[CCScaleTo actionWithDuration:0.4 scale:1.5],
                       [CCMoveTo actionWithDuration:0.4 position:ccp(size.width*6.5/20.0, size.height*6.2/7.0)]
                       ,nil]];
    [black runAction:[CCSpawn actions:[CCScaleTo actionWithDuration:0.4 scale:1.5],
                      [CCMoveTo actionWithDuration:0.4 position:ccp(size.width*11.1/20.0, size.height*6.2/7.0)]
                      ,nil]];
    [green runAction:[CCSpawn actions:[CCScaleTo actionWithDuration:0.4 scale:1.5],
                      [CCMoveTo actionWithDuration:0.4 position:ccp(size.width*15.5/20.0, size.height*6.2/7.0)]
                      ,nil]];
    
    [self performSelector:@selector(removeSignal) withObject:nil afterDelay:0.5];
}

-(void)removeSignal{
    for(CCSprite *tempSignal in [signalNode children]){
        if(tempSignal.scale == 1.5){
            [signalNode removeChild:tempSignal cleanup:YES];
        }
    }
    
    [red runAction:[CCPlace actionWithPosition:ccp(size.width*3.0/5.0, size.height/3.0)]];
    [yellow runAction:[CCPlace actionWithPosition:ccp(size.width*3.0/5.0, size.height/3.0)]];
    [black runAction:[CCPlace actionWithPosition:ccp(size.width*3.0/5.0, size.height/3.0)]];
    [green runAction:[CCPlace actionWithPosition:ccp(size.width*3.0/5.0, size.height/3.0)]];
    
    red.scale = 0.2;
    yellow.scale = 0.2;
    black.scale = 0.2;
    green.scale = 0.2;
    
    [self performSelector:@selector(makingSignal) withObject:nil afterDelay:0.2];
}

-(void)tempCheckGameOn{
    gameOn = YES;
    [self checkGameOn];
}

-(void)checkGameOn{
    if(gameOn == YES){
        [bgSprite pauseSchedulerAndActions];
    }
    else if(gameOn == NO){
        [bgSprite resumeSchedulerAndActions];
        appDelegate.distance += 20;
    }
}

-(void)gameTimer{
    fuel -= 0.029;
    
    if(fuel < 10){
        fuel = 0;
    }
    
    [self updateEnergyBar];
    
    if(myTurn == NO) {
        [self schedule:@selector(startGame) interval:3.0 / (level+1.5) repeat:level+100 delay:1.0];
    }
    
    if(fuel <= 0){
        [audio stopBackgroundMusic];
        [self performSelector:@selector(goGameOver)];
        [self unscheduleAllSelectors];
    }
}

-(void)playAudio{
    audio = [SimpleAudioEngine sharedEngine];
    [audio stopBackgroundMusic];
    [audio playBackgroundMusic:@"main_bgm.mp3"];
}

-(void)startGame{
//    NSLog(@"computerCount : %d\n", computerCount);
//    NSLog(@"level : %d\n", level);
    
    if(gameOn == YES){
        if(computerCount < level){
            randomSignal = arc4random() % 4 + 1;
            //        NSLog(@"randomSignal : %d", randomSignal);
            
            switch (randomSignal) {
                case 1:
                    [red_s runAction:[CCSequence actions:[CCCallFuncN actionWithTarget:self
                                                                              selector:@selector(opacitySpriteUp:)],
                                      [CCDelayTime actionWithDuration:0.2],
                                      [CCCallFuncN actionWithTarget:self
                                                           selector:@selector(opacitySpriteDown:)],nil]];
                    [audio playEffect:@"red.wav"];
                    
                    gameArrayComputer[computerCount] = RED;
                    computerCount++;
                    break;
                case 2:
                    [yellow_s runAction:[CCSequence actions:[CCCallFuncN actionWithTarget:self
                                                                                 selector:@selector(opacitySpriteUp:)],
                                         [CCDelayTime actionWithDuration:0.2],
                                         [CCCallFuncN actionWithTarget:self
                                                              selector:@selector(opacitySpriteDown:)],nil]];
                    [audio playEffect:@"yellow.wav"];
                    
                    gameArrayComputer[computerCount] = YELLOW;
                    computerCount++;
                    break;
                case 3:
                    [black_s runAction:[CCSequence actions:[CCCallFuncN actionWithTarget:self
                                                                                selector:@selector(opacitySpriteUp:)],
                                        [CCDelayTime actionWithDuration:0.2],
                                        [CCCallFuncN actionWithTarget:self
                                                             selector:@selector(opacitySpriteDown:)],nil]];
                    [audio playEffect:@"arrow.wav"];
                    
                    gameArrayComputer[computerCount] = BLACK;
                    computerCount++;
                    break;
                case 4:
                    [green_s runAction:[CCSequence actions:[CCCallFuncN actionWithTarget:self
                                                                                selector:@selector(opacitySpriteUp:)],
                                        [CCDelayTime actionWithDuration:0.2],
                                        [CCCallFuncN actionWithTarget:self
                                                             selector:@selector(opacitySpriteDown:)],nil]];
                    [audio playEffect:@"green.wav"];
                    
                    gameArrayComputer[computerCount] = GREEN;
                    computerCount++;
                    break;
                default:
                    break;
            }
        }

    }
    
    if(computerCount == level){
        myTurn = YES;
    }
}

-(void)opacitySpriteUp:(CCSprite*)sprite{
    sprite.opacity = 255;
}
-(void)opacitySpriteDown:(CCSprite*)sprite{
    sprite.opacity = 0;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch*touch=[touches anyObject];
    CGPoint location=[touch locationInView:[touch view]];
    CGPoint convertedLocation=[[CCDirector sharedDirector] convertToGL:location];
    
    if(myTurn == YES){
        if(CGRectContainsPoint([red boundingBox], convertedLocation)){
            [red_s runAction:[CCSequence actions:[CCCallFuncN actionWithTarget:self
                                                                    selector:@selector(opacitySpriteUp:)],
                            [CCDelayTime actionWithDuration:0.2],
                            [CCCallFuncN actionWithTarget:self selector:@selector(opacitySpriteDown:)],nil]];
            
            [audio playEffect:@"red.wav"];
            
            gameArrayUser[userCount] = RED;
            userCount++;
        }
        else if(CGRectContainsPoint([yellow boundingBox], convertedLocation)){
            [yellow_s runAction:[CCSequence actions:[CCCallFuncN actionWithTarget:self
                                                                       selector:@selector(opacitySpriteUp:)],
                               [CCDelayTime actionWithDuration:0.2],
                               [CCCallFuncN actionWithTarget:self selector:@selector(opacitySpriteDown:)],nil]];
            [audio playEffect:@"yellow.wav"];
            
            gameArrayUser[userCount] = YELLOW;
            userCount++;
        }
        else if(CGRectContainsPoint([black boundingBox], convertedLocation)){
            [black_s runAction:[CCSequence actions:[CCCallFuncN actionWithTarget:self
                                                                      selector:@selector(opacitySpriteUp:)],
                              [CCDelayTime actionWithDuration:0.2],
                              [CCCallFuncN actionWithTarget:self selector:@selector(opacitySpriteDown:)],nil]];
            [audio playEffect:@"arrow.wav"];
            
            gameArrayUser[userCount] = BLACK;
            userCount++;
        }
        else if(CGRectContainsPoint([green boundingBox], convertedLocation)){
            [green_s runAction:[CCSequence actions:[CCCallFuncN actionWithTarget:self
                                                                      selector:@selector(opacitySpriteUp:)],
                              [CCDelayTime actionWithDuration:0.2],
                              [CCCallFuncN actionWithTarget:self selector:@selector(opacitySpriteDown:)],nil]];
            [audio playEffect:@"green.wav"];
            
            gameArrayUser[userCount] = GREEN;
            userCount++;
        }
        
        if(userCount == level){
            userCount = 0;
            computerCount = 0;
            myTurn = NO;
            
            gameOn = NO;
            
            [self performSelector:@selector(scaleSignal) withObject:nil afterDelay:0.5];
            [self performSelector:@selector(checkGameOn) withObject:nil afterDelay:0.5];

            [self correctCheck];
        }
    }
    
    for(CCSprite *temp in [itemNode children]){
        if(CGRectContainsPoint([temp boundingBox], convertedLocation)){
            if (temp.tag == kTagLifeItem){
                [audio playEffect:@"Item1.wav"];
                if(life == 3){
                    life = 3;
                }
                else{
                    life += 1;
                    [self lifeCheck:YES];
                }
                [message showMessage:LIFE_PLUS_MESSAGE atPosition:convertedLocation];
                [itemNode removeChild:temp cleanup:YES];
            }
            else if(temp.tag == kTagFuelItem){
                [audio playEffect:@"Item1.wav"];
                fuel += 17;
                
                if(fuel > 90){
                    fuel = 90;
                }
                [message showMessage:ITEM_PLUS_MESSAGE atPosition:convertedLocation];
                [itemNode removeChild:temp cleanup:YES];
            }
        }
    }
}






-(void)subScore{
    //GKScore는 Leaderboard에 점수를 나타낸다.
    //"JMPoint"는 게임센터에서 설정한 Leaderboard ID이다.
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:@"JHPoint"] autorelease];
    scoreReporter.value = appDelegate.score;
    
    
    //서버에 스코어(점수)를 보낸다.
    //에러가 발생하는 경우는 1.값을 설정하지 않았거나, 2.플레이어가 인증되지 않았거나, 3.통신에 문제가 있을경우
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if(error!=nil) {
            NSLog(@"스코어 보내기 실패!");
        } else {
            NSLog(@"스코어 보내기 성공!");
        }
    }];
}

-(void)showLeaderboard{
    //Leaderboard 나타내기
    
    //Leaderboard를 넣어줄 뷰를 생성
    backView = [[UIViewController alloc] init];
    
    //리더보드 뷰컨트롤러를 생성
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if(leaderboardController != nil)
    {
        leaderboardController.leaderboardDelegate = self;
        
        //openGLView를 backView로 바꿔야 cocos2d에서 Gamecenter Leaderboard가 나온다.
        [(CCGLView *)[[CCDirector sharedDirector] view] addSubview:backView.view];
        
        //leaderboard를 backView에 모달뷰(여러 개의 뷰를 전환하기 위한 뷰 관리 방법 중 하나)로 단다.
        [backView presentViewController:leaderboardController animated:YES completion:nil];
    }
    
}

-(void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController{
    //LeaderboardView가 닫힐때
    [backView dismissViewControllerAnimated:YES completion:nil];
    [backView.view removeFromSuperview];
}



-(void)goMenu{
    [SceneManager goMenu];
}

-(void)goGameOver{
    [SceneManager goGameOver];
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

@end
