//
//  HowtoLayer.m
//  Brain Car
//
//  Created by apple03 on 13. 5. 10..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import "HowtoLayer.h"
#import "SceneManager.h"

@implementation HowtoLayer

-(id)init{
    if( (self = [super init]) ){
        CGSize size = [[CCDirector sharedDirector]winSize];
        
        self.isTouchEnabled = YES;
        
        CCMenuItem *goHome = [CCMenuItemImage itemWithNormalImage:@"back_button.png"
                                                    selectedImage:@"back_button_click.png"
                                                           target:self
                                                         selector:@selector(goMenu)];
        CCMenu *menu = [CCMenu menuWithItems:goHome, nil];
        
        menu.position = ccp(size.width/2.0, size.height*9.0/10.0);
        [self addChild:menu z:101];
        
        howto = [CCSprite spriteWithFile:@"howto.png"];
        howto.anchorPoint = CGPointZero;
        howto.position = CGPointZero;

        [self addChild:howto z:100];
        
    }
    
    return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGSize size = [[CCDirector sharedDirector]winSize];
    
    UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
    
    id move = [CCMoveBy actionWithDuration:1.0f position:ccp(-size.width,0)];
    
    if(convertedLocation.x > size.width/2.0){
        if(howto.position.x == 0){
            [howto runAction:move];
        }
    }
    else{
        if(howto.position.x == -size.width){
            [howto runAction:[[move copy] reverse]];
        }
    }
}

-(void)goMenu{
    [SceneManager goMenu];
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HowtoLayer *layer = [HowtoLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

@end
