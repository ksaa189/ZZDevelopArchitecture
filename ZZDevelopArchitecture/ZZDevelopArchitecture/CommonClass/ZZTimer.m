//
//  ZZTimer.m
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/22.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "ZZTimer.h"
//#import "NSDictionary+ZZ.h"
#import "NSArray+ZZ.h"
#import "NSObject+ZZ.h"


void (*ZZTimer_action)(id, SEL, id, NSTimeInterval) = (void (*)(id, SEL, id, NSTimeInterval))objc_msgSend;

#pragma mark - ZZTimer
@interface ZZTimer ()

@property (nonatomic, weak) id target;                  //
@property (nonatomic, assign) SEL selector;             //
@property (nonatomic, copy) NSString *name;
//@property (nonatomic, assign) id sender;                // 来源
@property (nonatomic, assign) NSTimeInterval duration;  // 持续时间

@property (nonatomic ,assign) NSTimeInterval start_at;  // 开始时间

@property (nonatomic, copy) ZZTimer_block block;

- (void)handleTimer;

- (void)stop;

@end

@implementation ZZTimer

- (void)stop
{
    if (_timer.isValid)
        [_timer invalidate];
}
- (void)handleTimer
{
    NSTimeInterval ti = [[NSDate date] timeIntervalSince1970] - _start_at;
    
    if (_block)
    {
        _block(self, ti);
        return;
    }
    
    ZZTimer_action(_target, _selector, self, ti);
}

@end

@implementation NSTimer (ZZExtension)

- (void)pauseTimer {
     [self setFireDate:[NSDate distantFuture]];
}
- (void)continueTimer {
     [self setFireDate:[NSDate date]];
}

@end

#pragma mark - ZZTimerContainer
@interface ZZTimerContainer : NSObject

@property (nonatomic, strong) ZZTimer *timer;

-(instancetype) initWithZZTimer:(ZZTimer *)timer;

@end

@implementation ZZTimerContainer

-(instancetype) initWithZZTimer:(ZZTimer *)timer
{
    self = [super init];
    if (self)
    {
        _timer = timer;
    }
    return self;
}

- (void)dealloc
{
    [_timer stop];
}

@end
#pragma mark - NSObject(ZZTimer)
@implementation NSObject(ZZTimer)

@dynamic ZZtimers;

- (NSMutableDictionary *)ZZtimers
{
    /*
    id object = [self uZZ_getAssociatedObjectForKey:NSObject_ZZTimers];
    
    if (nil == object)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
        [self uZZ_retainAssociatedObject:dic forKey:NSObject_ZZTimers];
        return dic;
    }
    
    return object;
     */
    return nil;
}

-(NSTimer *) timer:(NSTimeInterval)interval name:(NSString *)name
{
    return [self timer:interval repeat:NO name:name];
}


-(NSTimer *)timer:(NSTimeInterval)interval repeat:(BOOL)repeat name:(NSString *)name
{
    NSAssert(name.length > 1, @"name 不能为空");
    
    NSMutableDictionary *timers = self.ZZtimers;
    ZZTimer *timer2 = timers[name];
    
    if (timer2)
    {
        [self cancelTimer:name];
    }
    
    SEL aSel = NSSelectorFromString([NSString stringWithFormat:@"%@TimerHandle:duration:", name]);
    
    NSAssert([self respondsToSelector:aSel], @"selector 必须存在");
    
    NSDate *date = [NSDate date];
    ZZTimer *timer = [[ZZTimer alloc] init];
    timer.name = name;
    timer.start_at = [date timeIntervalSince1970];
    timer.target = self;
    timer.selector = aSel;
    timer.duration = 0;
    timer.timer = [[NSTimer alloc] initWithFireDate:date interval:interval target:timer selector:@selector(handleTimer) userInfo:nil repeats:repeat];
    [[NSRunLoop mainRunLoop] addTimer:timer.timer forMode:NSRunLoopCommonModes];
    
    ZZTimerContainer *container = [[ZZTimerContainer alloc] initWithZZTimer:timer];
    
    [timers setObject:container forKey:name];
    
    return timer.timer;
}

-(NSTimer *) timer:(NSTimeInterval)interval repeat:(BOOL)repeat name:(NSString *)name block:(ZZTimer_block)block
{
    NSString *timerName = (name == nil) ? @"" : name;
    
    NSMutableDictionary *timers = self.ZZtimers;
    [self cancelTimer:timerName];
    
    NSDate *date = [NSDate date];
    ZZTimer *timer = [[ZZTimer alloc] init];
    timer.name = timerName;
    timer.start_at = [date timeIntervalSince1970];
    timer.duration = 0;
    timer.block = block;
    timer.timer = [[NSTimer alloc] initWithFireDate:date interval:interval target:timer selector:@selector(handleTimer) userInfo:nil repeats:repeat];
    [[NSRunLoop mainRunLoop] addTimer:timer.timer forMode:NSRunLoopCommonModes];
    
    ZZTimerContainer *container = [[ZZTimerContainer alloc] initWithZZTimer:timer];
    
    [timers setObject:container forKey:timerName];
    
    return timer.timer;
}

- (void)cancelTimer:(NSString *)name
{
    NSString *timerName = (name == nil) ? @"" : name;
    
    NSMutableDictionary *timers = self.ZZtimers;
    ZZTimerContainer *timer2 = timers[timerName];
    
    if (timer2)
    {
        [timer2.timer stop];
        [timers removeObjectForKey:timerName];
    }
}

- (void)cancelAllTimer
{
    NSMutableDictionary *timers = self.ZZtimers;
    [timers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [(ZZTimer *)obj stop];
    }];
    
    [timers removeAllObjects];
}

@end

#pragma mark - ZZTicker

@interface ZZTicker()
{
    
}

@property (nonatomic, strong) NSMutableArray *receivers;

@end

@implementation ZZTicker __DEF_SINGLETON

- (instancetype)init
{
    self = [super init];
    if (self) {
        _interval = 1.0 / 8.0;
        _receivers = [NSMutableArray nonRetainingArray];
    }
    return self;
}

- (void)addReceiver:(NSObject *)obj
{
    if ( NO == [_receivers containsObject:obj] )
    {
        [_receivers addObject:obj];
        
        if ( nil == _timer )
        {
            _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(performTick)];
            [_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            
            _timestamp = [NSDate timeIntervalSinceReferenceDate];
        }
    }
}

- (void)removeReceiver:(NSObject *)obj
{
    [_receivers removeObject:obj];
    
    if ( 0 == _receivers.count )
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)performTick
{
    NSTimeInterval tick = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsed = tick - _timestamp;
    
    if ( elapsed >= _interval )
    {
        NSArray * array = [NSArray arrayWithArray:_receivers];
        
        for ( NSObject * obj in array )
        {
            if ( [obj respondsToSelector:@selector(handleTick:)] )
            {
                [obj handleTick:elapsed];
            }
        }
        
        _timestamp = tick;
    }
}

@end

@implementation NSObject(ZZTicker)

- (void)observeTick
{
    [[ZZTicker sharedInstance] addReceiver:self];
}

- (void)unobserveTick
{
    [[ZZTicker sharedInstance] removeReceiver:self];
}

- (void)handleTick:(NSTimeInterval)elapsed
{
}

@end
