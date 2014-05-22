/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import "cocos2d.h"

// 각 메시지의 상수 선언
enum{ 
	LIFE_PLUS_MESSAGE	= 0,
	CORRECT_MESSAGE,
	ITEM_PLUS_MESSAGE,
    WRONG_MESSAGE,
};

// miss, perfect, correct 정보를 보여주는 메시지 노드 
@interface MessageNode : CCNode
{
	// 각각의 정보를 보여주기 위한 스프라이트 노드의 사용 
	CCSprite *lifePlus;		// 표적을 놓친 경우(Life -1)
	CCSprite *correct;	// 두개 맟힐 경우
	CCSprite *itemPlus;
    CCSprite *wrong;
	
	BOOL wrongVisible;
	BOOL correctVisible;
}

@property (nonatomic, retain) CCSprite *lifePlus;
@property (nonatomic, retain) CCSprite *correct;
@property (nonatomic, retain) CCSprite *itemPlus;
@property (nonatomic, retain) CCSprite *wrong;

-(void)showMessage:(int)message;
-(void)showMessage:(int)message atPosition:(CGPoint)position;
-(id)scaledMoveAction:(CCSprite *)sprite;

@end
