//
//  IntroLayer.h
//  Cocos2dGame
//
//  Created by DongGyu Park on 13. 2. 14..
//  Copyright __MyCompanyName__ 2013년. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import <Foundation/Foundation.h>
#import "cocos2d.h"

// HelloWorldLayer
@interface IntroLayer : CCLayerColor
{
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void) makeTransition:(ccTime)dt;

@end
