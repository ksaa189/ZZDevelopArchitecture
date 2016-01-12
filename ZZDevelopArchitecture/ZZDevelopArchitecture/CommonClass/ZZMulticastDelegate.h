//
//  ZZMulticastDelegate.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 16/1/12.
//  Copyright © 2016年 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZZMulticastDelegateEnumerator;

/**
 * This class provides multicast delegate functionality. That is:
 * - it provides a means for managing a list of delegates
 * - any method invocations to an instance of this class are automatically forwarded to all delegates
 *
 * For example:
 *
 * // Make this method call on every added delegate (there may be several)
 * [multicastDelegate cog:self didFindThing:thing];
 *
 * This allows multiple delegates to be added to an xmpp stream or any xmpp module,
 * which in turn makes development easier as there can be proper separation of logically different code sections.
 *
 * In addition, this makes module development easier,
 * as multiple delegates can be handled in the same manner as the traditional single delegate paradigm.
 *
 * This class also provides proper support for GCD queues.
 * So each delegate specifies which queue they would like their delegate invocations to be dispatched onto.
 *
 * All delegate dispatching is done asynchronously (which is a critically important architectural design).
 **/


//这个类是解决delegate不能添加多个的情况，可以添加进队列中然后进行管理
//
@interface ZZMulticastDelegate : NSObject
//添加一个delegate到队列中
- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;
//移除一个delegate从队列中
- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;
//这个函数好像没意义啊
- (void)removeDelegate:(id)delegate;
//移除所有delegate
- (void)removeAllDelegates;
//管理的delegate数量
- (NSUInteger)count;
//某个类的的delegate数量
- (NSUInteger)countOfClass:(Class)aClass;
//delegate响应sel的数量
- (NSUInteger)countForSelector:(SEL)aSelector;
//计数器
- (ZZMulticastDelegateEnumerator *)delegateEnumerator;

@end


@interface ZZMulticastDelegateEnumerator : NSObject
//
- (NSUInteger)count;
- (NSUInteger)countOfClass:(Class)aClass;
- (NSUInteger)countForSelector:(SEL)aSelector;

- (BOOL)getNextDelegate:(id *)delPtr delegateQueue:(dispatch_queue_t *)dqPtr;
- (BOOL)getNextDelegate:(id *)delPtr delegateQueue:(dispatch_queue_t *)dqPtr ofClass:(Class)aClass;
- (BOOL)getNextDelegate:(id *)delPtr delegateQueue:(dispatch_queue_t *)dqPtr forSelector:(SEL)aSelector;

@end

