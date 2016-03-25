//
//  NSObect+ZZ.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/2.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XY)

#pragma mark - perform

#pragma mark - property
// 属性列表
@property (nonatomic, readonly, strong) NSArray                *attributeList;

#pragma mark - conversion

// 转换成NSIntger
- (NSInteger)asInteger;
// 转换成float
- (float)asFloat;
// 转换成BOOL
- (BOOL)asBool;
// 转换成NSNumber
- (NSNumber *)asNSNumber;
// 转换成NSString
- (NSString *)asNSString;
// 转换成NSDate
- (NSDate *)asNSDate;
// 转换成NSData
- (NSData *)asNSData;	// TODO
// 转换成NSArray
- (NSArray *)asNSArray;

// 转换成NSNutableArray
- (NSMutableArray *)asNSMutableArray;

// 转换成NSDictionary
- (NSDictionary *)asNSDictionary;
// 转换成NSMutableDictionary
- (NSMutableDictionary *)asNSMutableDictionary;

//- (NSArray *)asNSArrayWithClass:(Class)clazz;
//-(NSMutableArray *) asNSMutableArrayWithClass:(Class)clazz;

#pragma mark- copy
- (id)deepCopy1; // 这个其实就是把自己通过NSKeyArchive打包一下

#pragma mark- associated
//通过runtime的方式进行关联，类似key value的形式，具有内存属性（copy，retain，assign）
- (id)getAssociatedObjectForKey:(const char *)key;
- (id)copyAssociatedObject:(id)obj forKey:(const char *)key;
- (id)retainAssociatedObject:(id)obj forKey:(const char *)key;
- (id)assignAssociatedObject:(id)obj forKey:(const char *)key;
- (void)removeAssociatedObjectForKey:(const char *)key;
- (void)removeAllAssociatedObjects;

@end