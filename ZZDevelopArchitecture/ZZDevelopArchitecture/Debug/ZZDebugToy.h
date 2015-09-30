//
//  ZZDebugToy.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/8.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "ZZDevelopPreDefine.h"

#pragma mark - ZZDebugToy
// 这是个debug的玩具类
@interface ZZDebugToy : NSObject

// 当被观察的对象释放的时候打印一段String
+ (void)hookObject:(id)anObject whenDeallocLogString:(NSString *)string;

/**
 * @brief 提取视图层次结构的方法
 * @param aView 要提取的视图
 * @param indent 层次 请给0值
 * @param outstring 保存层次的字符串
 */
+ (void)dumpView:(UIView *)aView atIndent:(int)indent into:(NSMutableString *)outstring;
// 打印视图层次结构
+ (NSString *)displayViews:(UIView *)aView;

@end

#pragma mark - ZZDebug
#undef	PRINT_CALLSTACK
#define PRINT_CALLSTACK( __n )	[ZZDebug printCallstack:__n];
// 断点
#undef	BREAK_POINT
#define BREAK_POINT()			[ZZDebug breakPoint];

#undef	BREAK_POINT_IF
#define BREAK_POINT_IF( __x )	if ( __x ) { [ZZDebug breakPoint]; }

#undef	BB
#define BB						[ZZDebug breakPoint];

// 这个类名字需要在想下
@interface ZZDebug : NSObject __AS_SINGLETON
//根据断点 获取调用栈
+ (NSArray *)callstack:(NSUInteger)depth;
//根据断点 打印调用栈
+ (void)printCallstack:(NSUInteger)depth;
// 代码添加断点
+ (void)breakPoint;

// memory
- (void)allocAllMemory;
- (void)freeAllMemory;
- (void)allocMemory:(NSInteger)MB;
- (void)freeLastMemory;

@end;


#pragma mark - BorderView
#if (1 == __ZZ_DEBUG_SHOWBORDER__)
// uiview点击时 加边框
@interface UIWindow(ZZDebug)
@end


@interface BorderView : UIView
- (void)startAnimation;
@end
#endif
