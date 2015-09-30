//
//  ZZMemoryCache.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/31.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "ZZDevelopPreDefine.h"
#import "ZZCacheProtocol.h"

@interface ZZMemoryCache : NSObject <ZZCacheProtocol> __AS_SINGLETON

@property (nonatomic, assign) BOOL clearWhenMemoryLow;  // default is YES
@property (nonatomic, assign) NSUInteger maxCacheCount;

@property (nonatomic, assign, readonly) NSUInteger cachedCount;
@property (atomic, strong, readonly) NSMutableArray *cacheKeys;
@property (atomic, strong, readonly) NSMutableDictionary *cacheObjs;


// ZZCacheProtocol 协议方法
- (BOOL)hasObjectForKey:(id)key;

- (id)objectForKey:(id)key;
- (void)setObject:(id)object forKey:(id)key;

- (void)removeObjectForKey:(id)key;
- (void)removeAllObjects;

//

@end