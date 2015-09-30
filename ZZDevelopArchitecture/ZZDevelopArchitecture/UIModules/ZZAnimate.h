//
//  ZZAnimate.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/7.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZCommonDefine.h"
#import "ZZCommon.h"

typedef void (^ZZAnimateStepBlock)(void);


@interface ZZAnimate : NSObject

@end
//////////////////////          ZZAnimateStep        ///////////////////////


@interface ZZAnimateStep : NSObject

+ (id)duration:(NSTimeInterval)duration
       animate:(ZZAnimateStepBlock)step;

+ (id)delay:(NSTimeInterval)delay
   duration:(NSTimeInterval)duration
    animate:(ZZAnimateStepBlock)step;

+ (id)delay:(NSTimeInterval)delay
   duration:(NSTimeInterval)duration
     option:(UIViewAnimationOptions)option
    animate:(ZZAnimateStepBlock)step;

@property (nonatomic, assign) NSTimeInterval         delay;
@property (nonatomic, assign) NSTimeInterval         duration;
@property (nonatomic, copy  ) ZZAnimateStepBlock     step;
@property (nonatomic, assign) UIViewAnimationOptions option;


- (void)runAnimated:(BOOL)animated;
- (void)run;

@end
//////////////////////          ZZAnimateSerialStep        ///////////////////////
// 串行 序列  Serial Sequence
@interface ZZAnimateSerialStep : ZZAnimateStep
@property (nonatomic, strong, readonly) NSArray* steps;

+ (id)animate;
- (id)addStep:(ZZAnimateStep *)aStep;

@end
//////////////////////          ZZAnimateParallelStep        ///////////////////////
// 并行 序列 Parallel Spawn
@interface ZZAnimateParallelStep : ZZAnimateStep

@property (nonatomic, strong, readonly) NSArray* steps;

+ (id)animate;
- (id)addStep:(ZZAnimateStep *)aStep;

@end

