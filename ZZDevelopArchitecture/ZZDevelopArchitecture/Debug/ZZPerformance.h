//
//  ZZPerformance.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/7.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

// 性能分析
#import <Foundation/Foundation.h>

#import "ZZDevelopPreDefine.h"

#pragma mark - 这些宏是干嘛的没太懂 

#if (1 ==  __XY_PERFORMANCE__)

#define	PERF_TIME( block )			{ _PERF_ENTER(__PRETTY_FUNCTION__, __LINE__); block; _PERF_LEAVE(__PRETTY_FUNCTION__, __LINE__); }
#define	PERF_ENTER_( __tag)         [[XYPerformance sharedInstance] enter:__tag];
#define	PERF_LEAVE_( __tag)         [[XYPerformance sharedInstance] leave:__tag];

#else

#define	PERF_TIME( block )				{ block }
#define	PERF_ENTER_( __tag)
#define	PERF_LEAVE_( __tag)
#endif

#pragma mark -

@interface ZZPerformance : NSObject __AS_SINGLETON
//根据tag 来指定enter和leave的时间，enter和leave的tag要相同
- (void)enter:(NSString *)tag;
//离开的时候会自动打印 tag间隔时间
- (void)leave:(NSString *)tag;

@end
