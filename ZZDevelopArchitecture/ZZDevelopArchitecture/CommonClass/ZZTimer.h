//
//  ZZTimer.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/22.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "ZZDevelopPreDefine.h"

#pragma mark - #define

#define TIMER_NAME( __name )					__TEXT( __name )

#undef	ON_TIMER
#define ON_TIMER( __name, __timer, __duration ) \
- (void)__name##TimerHandle:(ZZTimer *)__timer duration:(NSTimeInterval)__duration

#undef	NSObject_ZZTimers
#define NSObject_ZZTimers	"NSObject.ZZTimer.ZZTimers"

@class ZZTimer;
typedef void(^ZZTimer_block)(ZZTimer *timer, NSTimeInterval duration);

#pragma mark - ZZTimer
/**
 * 说明
 * ZZTimer 是每个对象可以拥有多个,建议不要用太多,在对象释放的时候会自动停止
 */
@interface ZZTimer : NSObject

@property (nonatomic, strong) NSTimer *timer;

@end


#pragma mark - ZZTimerContainer


#pragma mark - NSObject(ZZTimer)
@interface NSObject (ZZTimer)

@property (nonatomic, readonly, strong) NSMutableDictionary *ZZtimers;

- (NSTimer *)timer:(NSTimeInterval)interval name:(NSString *)name;
- (NSTimer *)timer:(NSTimeInterval)interval repeat:(BOOL)repeat name:(NSString *)name;

- (NSTimer *)timer:(NSTimeInterval)interval repeat:(BOOL)repeat name:(NSString *)name block:(ZZTimer_block)block;

//- (void)pauseTimer;
//- (void)resumeTimer;

- (void)cancelTimer:(NSString *)name;
- (void)cancelAllTimer;

@end

#pragma mark -
// CADisplayLink
// Ticker


#pragma mark - #define

#undef	ON_TICK
#define ON_TICK( __time ) \
- (void)handleTick:(NSTimeInterval)__time

#pragma mark - ZZTicker
/**
 * 说明
 * ZZTicker 采用用一个CADisplayLink计时, 不用的时候需要手动移除观察
 */
@interface ZZTicker : NSObject __AS_SINGLETON

@property (nonatomic, weak, readonly  ) CADisplayLink  *timer;
@property (nonatomic, assign, readonly) NSTimeInterval timestamp;
@property (nonatomic, assign          ) NSTimeInterval interval;


- (void)addReceiver:(NSObject *)obj;
- (void)removeReceiver:(NSObject *)obj;

@end

#pragma mark - NSObject(ZZTicker)
@interface NSObject(ZZTicker)

- (void)observeTick;
- (void)unobserveTick;
- (void)handleTick:(NSTimeInterval)elapsed;

@end