//
//  ZZSystemInfo.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/22.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>

// 系统信息
#import "ZZDevelopPreDefine.h"

#undef Screen_WIDTH
#define Screen_WIDTH   [[UIScreen mainScreen] bounds].size.width
#undef Screen_HEIGHT
#define Screen_HEIGHT  [[UIScreen mainScreen] bounds].size.height

#pragma mark -

#define IOS9_OR_LATER		[[ZZSystemInfo sharedInstance] isOsVersionOrLater:@"9.0"]
#define IOS8_OR_LATER		[[ZZSystemInfo sharedInstance] isOsVersionOrLater:@"8.0"]
#define IOS7_OR_LATER		[[ZZSystemInfo sharedInstance] isOsVersionOrLater:@"7.0"]
#define IOS6_OR_LATER		[[ZZSystemInfo sharedInstance] isOsVersionOrLater:@"6.0"]
#define IOS5_OR_LATER		[[ZZSystemInfo sharedInstance] isOsVersionOrLater:@"5.0"]
#define IOS4_OR_LATER		[[ZZSystemInfo sharedInstance] isOsVersionOrLater:@"4.0"]

#define IOS9_OR_EARLIER		[[ZZSystemInfo sharedInstance] isOsVersionOrEarlier:@"9.0"]
#define IOS8_OR_EARLIER		[[ZZSystemInfo sharedInstance] isOsVersionOrEarlier:@"8.0"]
#define IOS7_OR_EARLIER		[[ZZSystemInfo sharedInstance] isOsVersionOrEarlier:@"7.0"]
#define IOS6_OR_EARLIER		[[ZZSystemInfo sharedInstance] isOsVersionOrEarlier:@"6.0"]
#define IOS5_OR_EARLIER		[[ZZSystemInfo sharedInstance] isOsVersionOrEarlier:@"5.0"]
#define IOS4_OR_EARLIER		[[ZZSystemInfo sharedInstance] isOsVersionOrEarlier:@"4.0"]


@interface ZZSystemInfo : NSObject __AS_SINGLETON

#pragma mark- app,设备相关
//获取设备 ios版本 具体看实现
- (NSString *)osVersion;
//获取bundle中版本号 ，一般是app的版本
- (NSString *)bundleVersion;
//获取bundle shortviersion字段信息，可能是小版本号
- (NSString *)bundleShortVersion;
//获取bundleIdentifier字段 形如com.lekann.WebPlayerKidsIpad2.${PRODUCT_NAME:rfc1034identifier}
- (NSString *)bundleIdentifier;
- (NSString *)urlSchema;
- (NSString *)urlSchemaWithName:(NSString *)name;
// 获取设备名字 @"iPhone", @"iPod touch"
- (NSString *)deviceModel;
- (NSString *)deviceUUID;

// 返回本机ip地址
- (NSString *)localHost;

// 是否越狱
- (BOOL)isJailBroken		NS_AVAILABLE_IOS(4_0);

// 在ip设备上运行
- (BOOL)runningOnPhone;
// 在ipad设备上运行
- (BOOL)runningOnPad;
//获取app的类型 ，如 商业，儿童等 不一定用的到
- (BOOL)requiresPhoneOS;

#pragma mark- 屏幕相关
//获取屏幕Size，用的是系统的方法，不能区分横竖屏不同,但其它判断用到了这个函数
- (CGSize)screenSize;

//下面的函数横竖屏也是生效的
- (BOOL)isScreenPhone;      //如果是iphone
- (BOOL)isScreen320x480;    // 这个是历史了
- (BOOL)isScreen640x960;    // ip4s
- (BOOL)isScreen640x1136;   // ip5 ip5s ip6放大模式
- (BOOL)isScreen750x1334;   // ip6
- (BOOL)isScreen1242x2208;  // ip6p
- (BOOL)isScreen1125x2001;  // ip6p放大模式

- (BOOL)isScreenPad;        //如果是ipad
- (BOOL)isScreen768x1024;   //ipad 1 和ipad 2
- (BOOL)isScreen1536x2048;  //ipad 3 以上

// 是否retina屏
- (BOOL)isRetina;
// 下面是一些 屏幕大小比较，感觉没什么用呢
- (BOOL)isScreenSizeSmallerThan:(CGSize)size;
- (BOOL)isScreenSizeBiggerThan:(CGSize)size;
- (BOOL)isScreenSizeEqualTo:(CGSize)size;

#pragma mark- 版本判断相关
// 系统版本比较,格式上有要求,具体看内部实现
- (BOOL)isOsVersionOrEarlier:(NSString *)ver;
- (BOOL)isOsVersionOrLater:(NSString *)ver;
- (BOOL)isOsVersionEqualTo:(NSString *)ver;

#pragma mark- 第一次启动相关
//根据 user 和event两个参数来判断是否是第一次启动
- (BOOL)isFirstRunWithUser:(NSString *)user event:(NSString *)event;
//根据 user 和event两个参数来判断是否是在当前版本第一次启动
- (BOOL)isFirstRunAtCurrentVersionWithUser:(NSString *)user event:(NSString *)event;
//应该是重置 首次启动信息,具体没太懂,看内部实现
- (void)resetFirstRun:(BOOL)isFirst user:(NSString *)user event:(NSString *)event;

@end
