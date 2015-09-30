//
//  ZZAOP.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/8.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "ZZDevelopPreDefine.h"

typedef void(^ZZAOP_block)(NSInvocation *invocation);

@interface ZZAOP : NSObject
//某个类 执行某个方法之前 添加截获BLOCK
+ (NSString *)interceptClass:(Class)aClass beforeExecutingSelector:(SEL)selector usingBlock:(ZZAOP_block)block;
//某个类 执行某个方法之后 添加截获BLOCK
+ (NSString *)interceptClass:(Class)aClass afterExecutingSelector:(SEL)selector usingBlock:(ZZAOP_block)block;
//某个类 执行某个方法之中 添加截获BLOCK
+ (NSString *)interceptClass:(Class)aClass insteadExecutingSelector:(SEL)selector usingBlock:(ZZAOP_block)block;
//移除截获者，需要一定的格式(class | method) 具体参见实现
+ (void)removeInterceptorWithIdentifier:(NSString *)identifier;

@end
