/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import "MessageNode.h"

@implementation MessageNode

@synthesize lifePlus, correct, itemPlus, wrong;

-(id) init
{	
	CGSize windowSize = [[CCDirector sharedDirector] winSize];
	const float X_POSITION_OF_MESSAGE = windowSize.width/2.0;
	const float Y_POSITION_OF_MESSAGE = windowSize.height*3.0/4.0;
	CGPoint pos = CGPointMake(X_POSITION_OF_MESSAGE, Y_POSITION_OF_MESSAGE);
	
	self = [super init];
	
	if (self)
	{
		// 현재 노드에 miss, perfect, correct 스프라이트 노드를 자식 노드로 추가 
		lifePlus = [CCSprite spriteWithFile:@"lifePlus.png"];
        lifePlus.scale = 1.2;
		[self addChild:lifePlus];
		
		correct = [CCSprite spriteWithFile:@"correctMessage.png"];
        correct.scale = 1.3;
		[self addChild:correct];

		itemPlus = [CCSprite spriteWithFile:@"fuelPlus.png"];
        itemPlus.scale = 1.2;
		[self addChild:itemPlus];
        
        wrong = [CCSprite spriteWithFile:@"wrongMessage.png"];
        wrong.scale = 1.3;
		[self addChild:wrong];
		
		for (CCSprite *sprite in [self children]) {
			// 각각의 노드에 대한 위치는 화면의 중앙 상단으로 한다
			sprite.position = pos;
			// 스프라이트는 처음에는 숨겨둔다
			sprite.visible = NO;
		}
	}
	
	return self;
}

// showMessage 메소드는 int를 매개변수로 받아서 각 스프라이트를 지역변수 sprite에 할당함.
-(void)showMessage:(int)message
{
	CGSize windowSize = [[CCDirector sharedDirector] winSize];
	const float X_POSITION_OF_MESSAGE = windowSize.width/2.0;
	const float Y_POSITION_OF_MESSAGE = windowSize.height/3.0;
	CGPoint pos = CGPointMake(X_POSITION_OF_MESSAGE, Y_POSITION_OF_MESSAGE);
	
	[self showMessage:message atPosition:pos];
}

-(void)showMessage:(int)message atPosition:(CGPoint)pos
{
	CCSprite *sprite		= nil;
	id		action			= nil;

	// 메시지 종류에 따라 서로 다른 메시지 액션
	switch ( message ) 
    {
		case LIFE_PLUS_MESSAGE:
			sprite = lifePlus;
			sprite.visible = YES;
			[sprite setPosition:pos];
			// 순차적인 액션을 보여줌, life Minus인 경우
			// 화면의 아래쪽으로 떨어진다..
			action = [CCSequence actions:
					  [CCFadeTo actionWithDuration:0.8 opacity:250],
					  [CCDelayTime actionWithDuration:1.2], 
					  [CCFadeTo actionWithDuration:0.01 opacity:0],
					  nil];
			break;
		case CORRECT_MESSAGE:
			sprite = correct;
			sprite.visible = YES;
			[sprite setPosition:pos];
			action = [CCSequence actions:
					  [CCFadeTo actionWithDuration:0.5 opacity:250],
					  [CCDelayTime actionWithDuration:0.9], 
					  [CCMoveTo actionWithDuration:0.2 position:ccp(pos.x, 550)], 
					  [CCFadeTo actionWithDuration:0.01 opacity:0],
					  nil];
			break;
		case ITEM_PLUS_MESSAGE: default:
			sprite = itemPlus;
			sprite.visible = YES;
			[sprite setPosition:pos];
			action = [CCSequence actions:
					  [CCFadeTo actionWithDuration:0.8 opacity:250],
					  [CCDelayTime actionWithDuration:1.2],
					  [CCFadeTo actionWithDuration:0.01 opacity:0],
					  nil];
			// 순차적인 액션을 보여줌
			break;
        case WRONG_MESSAGE:
			sprite = wrong;
			sprite.visible = YES;
			[sprite setPosition:pos];
			action = [CCSequence actions:
					  [CCFadeTo actionWithDuration:0.5 opacity:250],
					  [CCDelayTime actionWithDuration:0.9],
					  [CCMoveTo actionWithDuration:0.2 position:ccp(pos.x, -50)],
					  [CCFadeTo actionWithDuration:0.01 opacity:0],
					  nil];
			break;
	}
	
	// 순차적인 액션을 보여줌
	[sprite runAction:action];
	return;
}

-(id)scaledMoveAction:(CCSprite *)sprite
{
	CGSize	windowSize			= [[CCDirector sharedDirector] winSize];
	float	halfOfWindowWidth	= windowSize.width/2.0f;
	CGPoint targetPoint			= ccp(halfOfWindowWidth,
									windowSize.height+sprite.contentSize.height+30);		
	
	// 두 가지 종류의 spawning action을 만든다
	id move = [CCSpawn actions:	
					 [CCEaseBackIn actionWithAction:
					  [CCMoveTo actionWithDuration:0.4 position:targetPoint]], 
					 [CCEaseBackIn actionWithAction:
					  [CCScaleTo actionWithDuration:0.4 scale:0.4f]],
					 nil] ;

	return move;
}

//- (void) dealloc
//{
//	[combo2 release];
//	[combo3 release];
//	[comboCombo release];
//	[lifeMinus release];
//	[itemPlus release];
//	[super dealloc];
//}

@end
