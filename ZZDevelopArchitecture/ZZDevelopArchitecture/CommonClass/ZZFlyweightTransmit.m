//
//  ZZFlyweightTransmit.m
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/19.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "ZZFlyweightTransmit.h"
#import "ZZDevelopPreDefine.h"

#pragma mark - ZZFlyweightTransmit
#define NSObject_key_flyweightData	"ZZ.NSObject.flyweightData"
#define NSObject_key_objectDic	"ZZ.NSObject.objectDic"
#define NSObject_key_eventBlockDic	"ZZ.NSObject.eventBlockDic"

@implementation NSObject (ZZFlyweightTransmit)

- (id)flyweightData
{
    return objc_getAssociatedObject(self, NSObject_key_flyweightData);
}

- (void)setFlyweightData:(id)flyweightData
{
    [self willChangeValueForKey:@"flyweightData"];
    objc_setAssociatedObject(self, NSObject_key_flyweightData, flyweightData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"flyweightData"];
}


- (void)receiveObject:(void(^)(id object))aBlock withIdentifier:(NSString *)identifier
{
    NSString *key = identifier ?: @"sendObject";
    NSMutableDictionary *dic = objc_getAssociatedObject(self, NSObject_key_objectDic);
    if(dic == nil)
    {
        dic = [NSMutableDictionary dictionaryWithCapacity:4];
        objc_setAssociatedObject(self, NSObject_key_objectDic, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [dic setObject:[aBlock copy] forKey:key];
}

- (void)sendObject:(id)anObject withIdentifier:(NSString *)identifier
{
    NSString *key = identifier ?: @"sendObject";
    NSDictionary *dic = objc_getAssociatedObject(self, NSObject_key_objectDic);
    if(dic == nil)
    {
        return;
    }
    
    void(^aBlock)(id anObject) = [dic objectForKey:key];
    aBlock(anObject);
}

- (void)handlerEventWithBlock:(id)aBlock withIdentifier:(NSString *)identifier
{
    NSString *key = identifier ?: @"handlerEvent";
    NSMutableDictionary *dic = objc_getAssociatedObject(self, NSObject_key_eventBlockDic);
    if(dic == nil)
    {
        dic = [NSMutableDictionary dictionaryWithCapacity:4];
        objc_setAssociatedObject(self, NSObject_key_eventBlockDic, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [dic setObject:[aBlock copy] forKey:key];
}

- (id)blockForEventWithIdentifier:(NSString *)identifier
{
    NSString *key = identifier ?: @"handlerEvent";
    NSDictionary *dic = objc_getAssociatedObject(self, NSObject_key_eventBlockDic);
    if(dic == nil)
        return nil;
    
    return [dic objectForKey:key];
}

@end;
