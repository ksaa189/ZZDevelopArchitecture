//
//  ZZUserDefaults.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/18.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "ZZDevelopPredefine.h"
#import "ZZCacheProtocol.h"

@interface XYUserDefaults : NSObject <ZZCacheProtocol> __AS_SINGLETON

@end

@interface NSObject(XYUserDefaults)

// for key value

+ (id)userDefaultsRead:(NSString *)key;
- (id)userDefaultsRead:(NSString *)key;

+ (void)userDefaultsWrite:(id)value forKey:(NSString *)key;
- (void)userDefaultsWrite:(id)value forKey:(NSString *)key;

+ (void)userDefaultsRemove:(NSString *)key;
- (void)userDefaultsRemove:(NSString *)key;

// for object

+ (id)readObject;
+ (id)readObjectForKey:(NSString *)key;

+ (void)saveObject:(id)obj;
+ (void)saveObject:(id)obj forKey:(NSString *)key;

+ (void)removeObject;
+ (void)removeObjectForKey:(NSString *)key;

@end