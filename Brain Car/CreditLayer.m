//
//  CreditLayer.m
//  Brain Car
//
//  Created by apple03 on 13. 5. 10..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import "CreditLayer.h"
#import "SceneManager.h"


@implementation CreditLayer

-(id)init{
    if( (self = [super init]) ){
        
        CGSize size = [[CCDirector sharedDirector]winSize];
        
        CCMenuItem *creditBg = [CCMenuItemImage itemWithNormalImage:@"credit.png"
                                                      selectedImage:@"credit.png"
                                                             target:self
                                                           selector:@selector(goMenu)];
        CCMenu *menu = [CCMenu menuWithItems:creditBg, nil];
        menu.position = ccp(size.width/2.0, size.height/2.0);
        [self addChild:menu z:101];
    }
    
    return self;
}

-(void)goMenu{
    [SceneManager goMenu];
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CreditLayer *layer = [CreditLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

@end
