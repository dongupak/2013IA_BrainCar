//
//  HowtoLayer.h
//  Brain Car
//
//  Created by apple03 on 13. 5. 10..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HowtoLayer : CCLayer {
    CCSprite *howto;
}

-(void)goMenu;

+(CCScene *) scene;

@end
