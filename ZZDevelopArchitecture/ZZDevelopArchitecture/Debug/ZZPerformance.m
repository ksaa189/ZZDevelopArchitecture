//
//  ZZPerformance.m
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/7.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//



#import "ZZPerformance.h"

#pragma mark -

@interface ZZPerformance()
{
    
}
@property (nonatomic, strong) NSMutableDictionary *tags;
@end

#pragma mark -

@implementation ZZPerformance __DEF_SINGLETON

- (id)init
{
    self = [super init];
    if ( self )
    {
        _tags = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)enter:(NSString *)tag
{
    NSNumber * time = [NSNumber numberWithDouble:CACurrentMediaTime()];
    NSString * name = [NSString stringWithFormat:@"%@ enter", tag];
    
    [_tags setObject:time forKey:name];
}

- (void)leave:(NSString *)tag
{
    @autoreleasepool
    {
        NSString * name1 = [NSString stringWithFormat:@"%@ enter", tag];
        NSString * name2 = [NSString stringWithFormat:@"%@ leave", tag];
        
        CFTimeInterval time1 = [[_tags objectForKey:name1] doubleValue];
        CFTimeInterval time2 = CACurrentMediaTime();
        
        [_tags removeObjectForKey:name1];
        [_tags removeObjectForKey:name2];
        
        [self recordName:tag andTime:fabs(time2 - time1)];
    }
}

- (void)recordName:(NSString *)name andTime:(NSTimeInterval)time
{
    NSLog( @"Time '%@' = %.0f(ms)", name, time );
}
@end