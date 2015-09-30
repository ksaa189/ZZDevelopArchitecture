//
//  NSNumber+ZZ.m
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/2.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "NSNumber+ZZ.h"
#import "NSDate+ZZ.h"

@implementation NSNumber (ZZ)

@dynamic dateValue;

- (NSDate *)dateValue
{
    return [NSDate dateWithTimeIntervalSince1970:self.doubleValue];
}

- (NSString *)stringWithDateFormat:(NSString *)format
{
#if 0
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString * result = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self doubleValue]]];
    [dateFormatter release];
    
    return result;
    
#else
    // thanks @lancy, changed: "NSDate depend on NSNumber" to "NSNumber depend on NSDate"
    return [[NSDate dateWithTimeIntervalSince1970:[self doubleValue]] stringWithDateFormat:format];
#endif
}

@end
