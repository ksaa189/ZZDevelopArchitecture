//
//  ZZDevelopPreDefine.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/1.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#ifndef ZZDevelopArchitecture_ZZDevelopPreDefine_h
#define ZZDevelopArchitecture_ZZDevelopPreDefine_h

// ----------------------------------
// 下面是提供各种编译环境的宏设置
// ----------------------------------

#ifdef DEBUG

#define __ZZ_DEBUG__                             (1)     // 调试
#define __ZZ_PERFORMANCE__                       (1)     // 性能测试
#define __ZZ_UISIGNAL_CALLPATH__                 (1)     // XYUISIGNAL
#define __ZZ_DEBUG_SHOWBORDER__                  (1)     // 点击区域红色边框
#define __ZZ_DEBUG_UNITTESTING__                 (1)     // 单元测试

#else

#define __ZZ_DEBUG__                             (0)
#define __ZZ_PERFORMANCE__                       (0)
#define __ZZ_UISIGNAL_CALLPATH__                 (0)
#define __ZZ_DEBUG_SHOWBORDER__                  (0)
#define __ZZ_DEBUG_UNITTESTING__                 (0)

#endif


// ----------------------------------
// header.h
// ----------------------------------

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import <AVFoundation/AVFoundation.h>
//#import <AVFoundation/AVSpeechSynthesis.h>
//#import <CoreMotion/CoreMotion.h>
//#import <Social/Social.h>
//
#import <objc/runtime.h>
#import <objc/message.h>
//#import <mach/mach.h>
//#import <mach/mach_host.h>
//#import <execinfo.h>
//#import <CommonCrypto/CommonDigest.h>
//#import <CommonCrypto/CommonCryptor.h>
//#import <ifaddrs.h>
//#import <arpa/inet.h>

// ----------------------------------
// Common use macros
// ----------------------------------

#ifndef	IN
#define IN
#endif

#ifndef	OUT
#define OUT
#endif

#ifndef	INOUT
#define INOUT
#endif

#ifndef	UNUSED
#define	UNUSED( __x )		{ id __unused_var__ __attribute__((unused)) = (id)(__x); }
#endif

#ifndef	ALIAS
#define	ALIAS( __a, __b )	__typeof__(__a) __b = __a;
#endif

#ifndef	DEPRECATED
#define	DEPRECATED			__attribute__((deprecated))
#endif

#ifndef	TODO
#define TODO( X )			_Pragma(macro_cstr(message("✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖ TODO: " X)))
#endif

#ifndef	EXTERN_C
#if defined(__cplusplus)
#define EXTERN_C			extern "C"
#else
#define EXTERN_C			extern
#endif
#endif

#ifndef	INLINE
#define	INLINE				__inline__ __attribute__((always_inline))
#endif

// ----------------------------------
// 类定义成单例模式的宏命令
// ----------------------------------
// 单例模式
#undef	__AS_SINGLETON
#define __AS_SINGLETON    \
+ (instancetype)sharedInstance; \
+ (void)purgeSharedInstance;

#undef	__DEF_SINGLETON
#define __DEF_SINGLETON \
static dispatch_once_t __singletonToken;     \
static id __singleton__;    \
+ (instancetype)sharedInstance \
{ \
    dispatch_once( &__singletonToken, ^{ __singleton__ = [[self alloc] init]; } ); \
    return __singleton__; \
}   \
+ (void)purgeSharedInstance \
{   \
    __singleton__ = nil;    \
    __singletonToken = 0; \
}

// ----------------------------------
// 执行一次 的宏命令
// ----------------------------------
#undef	ZZ_ONCE_BEGIN
#define ZZ_ONCE_BEGIN( __name ) \
static dispatch_once_t once_##__name; \
dispatch_once( &once_##__name , ^{

#undef	ZZ_ONCE_END
#define ZZ_ONCE_END		});

// ----------------------------------
// Category
// ----------------------------------
//使用示例:
//UIColor+YYAdd.m
/*
 #import "UIColor+YYAdd.h"
 DUMMY_CLASS(UIColor+YYAdd)
 
 @implementation UIColor(YYAdd)
 ...
 @end
 */

#ifndef DUMMY_CLASS//虚设的类 这是什么意思 ？？？
#define DUMMY_CLASS(UNIQUE_NAME) \
@interface DUMMY_CLASS_##UNIQUE_NAME : NSObject @end \
@implementation DUMMY_CLASS_##UNIQUE_NAME @end
#endif


// ----------------------------------
// 引入宏文件
// ----------------------------------

#import "ZZDevelopMacros.h"

#endif
// ----------------------------------
// ...
// ----------------------------------

