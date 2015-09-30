//
//  NSArray+ZZ.m
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/1.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//
#import "NSArray+ZZ.h"
#import "ZZDevelopPreDefine.h"


DUMMY_CLASS(NSArray_ZZ);//这个有什么用？？

static const void *__XYRetainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
static void __XYReleaseNoOp(CFAllocatorRef allocator, const void *value) { }

@implementation NSArray(ZZ)

- (id)safeObjectAtIndex:(NSInteger)index
{
    if ( index < 0 )
        return nil;
    
    if ( index >= self.count )
        return nil;
    
    return [self objectAtIndex:index];
}

- (NSArray *)safeSubarrayWithRange:(NSRange)range
{
    if ( 0 == self.count )
        return nil;
    
    if ( range.location >= self.count )
        return nil;
    
    if ( range.location + range.length > self.count )
        return nil;
    
    return [self subarrayWithRange:NSMakeRange(range.location, range.length)];
}

- (NSArray *)safeSubarrayFromIndex:(NSUInteger)index
{
    if ( 0 == self.count )
        return [NSArray array];
    
    if ( index >= self.count )
        return [NSArray array];
    
    return [self safeSubarrayWithRange:NSMakeRange(index, self.count - index)];
}

- (NSArray *)safeSubarrayWithCount:(NSUInteger)count
{
    if ( 0 == self.count )
        return [NSArray array];
    
    return [self safeSubarrayWithRange:NSMakeRange(0, count)];
}

- (NSInteger)indexOfString:(NSString *)string
{
    if (string == nil || string.length < 1)
    {
        return NSNotFound;
    }
    if (self.count == 0)
    {
        return NSNotFound;
    }
    
    for (int i = 0; i < self.count; i++)
    {
        if ([string isEqualToString:self[i]])
        {
            return i;
        }
    }
    
    return NSNotFound;
}

@end


#pragma mark -

@implementation NSMutableArray(ZZ)
+ (NSMutableArray *)nonRetainingArray
{
    CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
    callbacks.retain           = __XYRetainNoOp;
    callbacks.release          = __XYReleaseNoOp;
    
    return (__bridge_transfer NSMutableArray *)CFArrayCreateMutable(nil, 0, &callbacks);
}
- (void)safeAddObject:(id)anObject
{
    if ( anObject )
    {
        [self addObject:anObject];
    }
}

@end


