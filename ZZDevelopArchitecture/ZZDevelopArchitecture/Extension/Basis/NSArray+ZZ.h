//
//  NSArray+ZZ.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/1.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSMutableArray *	(^NSArrayAppendBlock)( id obj );
typedef NSMutableArray *	(^NSMutableArrayAppendBlock)( id obj );

#pragma mark -

@interface NSArray(ZZ)

// 防止读取数组元素越界
- (id)safeObjectAtIndex:(NSInteger)index;
// 防止读取子数组越界 读取range中的子数组
- (NSArray *)safeSubarrayWithRange:(NSRange)range;
// 防止读取子数组越界 读取index之后的子数组 
- (NSArray *)safeSubarrayFromIndex:(NSUInteger)index;
// 防止读取子数组越界 读取前面count数的子数组
- (NSArray *)safeSubarrayWithCount:(NSUInteger)count;
// 查找string在数组中得位置
- (NSInteger)indexOfString:(NSString *)string;

@end

#pragma mark -

@interface NSMutableArray(ZZ)
//框架内部使用 勿动
+ (NSMutableArray *)nonRetainingArray;
// 防止添加的object为空 
- (void)safeAddObject:(id)anObject;

@end