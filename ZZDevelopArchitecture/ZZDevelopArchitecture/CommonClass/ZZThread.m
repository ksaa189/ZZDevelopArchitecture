//
//  ZZThread.m
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/22.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "ZZThread.h"

#pragma mark -

@interface ZZGCD()

@property (nonatomic, strong) dispatch_queue_t foreQueue;
@property (nonatomic, strong) dispatch_queue_t backSerialQueue;
@property (nonatomic, strong) dispatch_queue_t backConcurrentQueue;
@property (nonatomic, strong) dispatch_queue_t writeFileQueue;

@end

@implementation ZZGCD __DEF_SINGLETON

- (id)init
{
    self = [super init];
    if ( self )
    {
        _foreQueue           = dispatch_get_main_queue();
        _backSerialQueue     = dispatch_queue_create( "com.XY.backSerialQueue", DISPATCH_QUEUE_SERIAL );
        _backConcurrentQueue = dispatch_queue_create( "com.XY.backConcurrentQueue", DISPATCH_QUEUE_CONCURRENT );
        _writeFileQueue      = dispatch_queue_create( "com.XY.writeFileQueue", DISPATCH_QUEUE_SERIAL );
    }
    
    return self;
}

#pragma mark-Foreground


#pragma mark-Background

@end

