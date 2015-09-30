//
//  ZZFlyweightTransmit.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/19.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>

// 解决a知道b,b不知道a, b传数据给a的情况

@interface NSObject (ZZFlyweightTransmit)
@property (nonatomic, strong) id flyweightData;
- (void)receiveObject:(void(^)(id object))aBlock withIdentifier:(NSString *)identifier;
- (void)sendObject:(id)anObject withIdentifier:(NSString *)identifier;
- (void)handlerEventWithBlock:(id)aBlock withIdentifier:(NSString *)identifier;
- (id)blockForEventWithIdentifier:(NSString *)identifier;
@end

#pragma mark-
@protocol ZZFlyweightTransmit <NSObject>

@property (nonatomic, strong) id flyweightData;

// 传递一个数据
- (void)receiveObject:(void(^)(id object))aBlock withIdentifier:(NSString *)identifier;
- (void)sendObject:(id)anObject withIdentifier:(NSString *)identifier;

// 设置一个block作为回调
- (void)handlerEventWithBlock:(id)aBlock withIdentifier:(NSString *)identifier;
- (id)blockForEventWithIdentifier:(NSString *)identifier;

@end
