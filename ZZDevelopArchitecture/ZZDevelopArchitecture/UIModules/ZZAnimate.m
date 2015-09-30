//
//  ZZAnimate.m
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/7.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "ZZAnimate.h"

@implementation ZZAnimate

@end

//////////////////////          ZZAnimateStep        ///////////////////////

@interface ZZAnimateStep ()
- (NSArray*)animateStepArray;
- (ZZAnimateStepBlock)animationStep:(BOOL)animated;
@property (nonatomic, strong) NSMutableArray *consumableSteps;

@end

@implementation ZZAnimateStep

+ (id)delay:(NSTimeInterval)delay
   duration:(NSTimeInterval)duration
     option:(UIViewAnimationOptions)option
    animate:(ZZAnimateStepBlock)step
{
    ZZAnimateStep *anStep = [[ZZAnimateStep alloc] init];
    if (anStep)
    {
        anStep.delay = delay;
        anStep.duration = duration;
        anStep.option = option;
        anStep.step = step;
    }
    return anStep;
}
+ (id)duration:(NSTimeInterval)duration
       animate:(ZZAnimateStepBlock)step
{
    return [self delay:0 duration:duration option:0 animate:step];
}

+ (id)delay:(NSTimeInterval)delay
   duration:(NSTimeInterval)duration
    animate:(ZZAnimateStepBlock)step
{
    return [self delay:delay duration:duration option:0 animate:step];
}

+ (void) runBlock:(ZZAnimateStepBlock)block afterDelay:(NSTimeInterval)delay
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delay), dispatch_get_main_queue(), block);
}

- (NSArray*)animateStepArray
{
    // subclasses must override this!
    // 子类必须实现这个方法
    return [NSArray arrayWithObject:self];
}

- (ZZAnimateStepBlock)animationStep:(BOOL)animated
{
    // override it if needed
    return self.step;
}

- (void)runAnimated:(BOOL)animated
{
    if (self.consumableSteps == nil)
    {
        self.consumableSteps = [[NSMutableArray alloc] initWithArray:[self animateStepArray]];
    }
    if ([self.consumableSteps count] == 0)
    { // recursion anchor
        self.consumableSteps = nil;
        return;
    }
    
    ZZAnimateStepBlock completionStep = ^{
        [self.consumableSteps removeLastObject];
        [self runAnimated:animated]; // recurse!
    };
    
    ZZAnimateStep *curStep = [self.consumableSteps lastObject];
    if (animated && curStep.duration >= 0.02)
    {
        [UIView animateWithDuration:curStep.duration
                              delay:curStep.delay
                            options:curStep.option
                         animations:[curStep animationStep:animated]
                         completion:^(BOOL finished) {
                             if (finished) {
                                 completionStep();
                             }
                         }];
    }
    else
    {
        void (^execution)(void) = ^{
            [curStep animationStep:animated]();
            completionStep();
        };
        
        if (animated && curStep.delay)
        {
            [ZZAnimateStep runBlock:execution afterDelay:curStep.delay];
        }
        else
        {
            execution();
        }
    }
}
- (void)run
{
    [self runAnimated:YES];
}
- (NSString*)description
{
    NSMutableString* result = [[NSMutableString alloc] initWithCapacity:100];
    [result appendString:@"\n["];
    if (self.delay > 0.0)
    {
        [result appendFormat:@"after:%.1f ", self.delay];
    }
    
    if (self.duration > 0.0)
    {
        [result appendFormat:@"for:%.1f ", self.duration];
    }
    
    if (self.option > 0)
    {
        [result appendFormat:@"options:%lu ", self.option];
    }
    
    [result appendFormat:@"animate:%@", self.step];
    [result appendString:@"]"];
    
    return result;
}

@end
#pragma mark - ZZAnimateSerialStep
@implementation ZZAnimateSerialStep
+ (id)animate
{
    return [[self alloc] init];
}
- (id)init
{
    self = [super init];
    if (self)
    {
        _steps = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    return self;
}

- (id)addStep:(ZZAnimateStep *)aStep
{
    if (aStep && self != aStep)
    {
        [(NSMutableArray *)_steps insertObject:aStep atIndex:0];
    }
    
    return self;
}

- (void)setDelay:(NSTimeInterval)delay
{
    NSAssert(NO, @"Setting a delay on a sequence is undefined and therefore disallowed!");
}

- (void)setDuration:(NSTimeInterval)duration
{
    NSAssert(NO, @"Setting a duration on a sequence is undefined and therefore disallowed!");
}
- (NSTimeInterval)duration
{
    NSTimeInterval fullDuration = 0;
    for (ZZAnimateStep *current in self.animateStepArray)
    {
        fullDuration += current.delay;
        fullDuration += current.duration;
    }
    
    return fullDuration+self.delay;
}

- (void)setOptions:(UIViewAnimationOptions)options
{
    NSAssert(NO, @"Setting options on a sequence is undefined and therefore disallowed!");
}

#pragma mark - build the sequence

- (NSArray*)animateStepArray
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:[self.steps count]];
    for (ZZAnimateStep *current in self.steps)
    {
        [array addObjectsFromArray:[current animateStepArray]];
    }
    return array;
}

#pragma mark - pretty-print

- (NSString*)description
{
    NSMutableString *sequenceBody = [NSMutableString stringWithCapacity:100 * [self.steps count]];
    for (ZZAnimateStep *step in self.steps)
    {
        [sequenceBody appendString:[step description]];
    }
    // indent
    [sequenceBody replaceOccurrencesOfString:@"\n"
                                  withString:@"\n  "
                                     options:NSCaseInsensitiveSearch
                                       range:NSMakeRange(0, [sequenceBody length])];
    
    return [NSString stringWithFormat:@"\n(sequence:%@\n)", sequenceBody];
}



@end


#pragma mark - ZZAnimateParallelStep
@implementation ZZAnimateParallelStep
+ (id)animate
{
    return [[self alloc] init];
}
- (id)init
{
    self = [super init];
    if (self)
    {
        _steps = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}
- (id)addStep:(ZZAnimateStep *)aStep{
    if (aStep && self != aStep)
    {
        [(NSMutableArray *)_steps insertObject:aStep atIndex:0];
    }
    return self;
}

- (void) setDelay:(NSTimeInterval)delay {
    NSAssert(NO, @"Setting a delay on a program is undefined and therefore disallowed!");
}

- (void) setDuration:(NSTimeInterval)duration {
    NSAssert(NO, @"Setting a duration on a program is undefined and therefore disallowed!");
}

- (void) setOptions:(UIViewAnimationOptions)options {
    NSAssert(NO, @"Setting options on a program is undefined and therefore disallowed!");
}

#pragma mark - build the sequence

- (NSTimeInterval) longestDuration {
    ZZAnimateStep *longestStep = nil;
    for (ZZAnimateStep *current in self.steps) {
        NSTimeInterval currentDuration = current.delay+current.duration;
        if (currentDuration > longestStep.delay+longestStep.duration) {
            longestStep = current;
        }
    }
    NSAssert(longestStep, @"Program seems to contain no steps.");
    return self.delay + longestStep.delay + longestStep.duration;
}

- (NSArray*) animateStepArray {
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:3];
    // Note: reverse order!
    [array addObject:[ZZAnimateStep delay:[self longestDuration] duration:0 animate:^{}]];
    [array addObject:self];
    [array addObject:[ZZAnimateStep delay:self.delay duration:0 animate:^{}]];
    return array;
}

- (ZZAnimateStepBlock) animationStep:(BOOL)animated {
    ZZAnimateStepBlock programStep = ^{
        for (ZZAnimateStep* current in self.steps) {
            [current runAnimated:animated];
        }
    };
    return [programStep copy];
}

#pragma mark - pretty-print

- (NSString*) description {
    NSMutableString* programBody = [NSMutableString stringWithCapacity:100 * [self.steps count]];
    for (ZZAnimateStep *step in self.steps) {
        [programBody appendString:[step description]];
    }
    // indent
    [programBody replaceOccurrencesOfString:@"\n"
                                 withString:@"\n  "
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, [programBody length])];
    return [NSString stringWithFormat:@"\n(program:%@\n)", programBody];
}
@end
