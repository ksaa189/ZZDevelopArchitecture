//
//  ZZThread.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/22.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "ZZDevelopPreDefine.h"

#pragma mark -

// 提交
#define dispatch_submit \
});

// 主队列
#define dispatch_foreground   \
dispatch_async( dispatch_get_main_queue(), ^{

#define dispatch_after_foreground( __seconds ) \
dispatch_after( [ZZGCD seconds:__seconds], dispatch_get_main_queue(), ^{

// 后台并行队列
#define dispatch_background_concurrent    \
dispatch_async( [ZZGCD sharedInstance].backConcurrentQueue, ^{

#define dispatch_after_background_concurrent( __seconds ) \
dispatch_after( [ZZGCD seconds:__seconds], [ZZGCD sharedInstance].backConcurrentQueue, ^{

// barrier
#define dispatch_barrier_background_concurrent    \
dispatch_barrier_async( [ZZGCD sharedInstance].backConcurrentQueue, ^{

// 后台串行队列
#define dispatch_background_serial        \
dispatch_async( [ZZGCD sharedInstance].backSerialQueue, ^{

#define dispatch_after_background_serial( __seconds ) \
dispatch_after( [ZZGCD seconds:__seconds], [ZZGCD sharedInstance].backSerialQueue, ^{

// 写的文件用的串行队列
#define dispatch_background_writeFile     \
dispatch_async( [ZZGCD sharedInstance].writeFileQueue, ^{

#pragma mark -

@interface ZZGCD : NSObject __AS_SINGLETON

// dispatch_get_main_queue()
@property (nonatomic, strong, readonly) dispatch_queue_t foreQueue;
// "com.ZZ.backSerialQueue", DISPATCH_QUEUE_SERIAL
@property (nonatomic, strong, readonly) dispatch_queue_t backSerialQueue;
// "com.ZZ.backConcurrentQueue", DISPATCH_QUEUE_SERIAL
@property (nonatomic, strong, readonly) dispatch_queue_t backConcurrentQueue;
// 写文件用 "com.ZZ.writeFileQueue", DISPATCH_QUEUE_SERIAL
@property (nonatomic, strong, readonly) dispatch_queue_t writeFileQueue;

@end