//
//  ZZReachability.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/8.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>
#import "ZZDevelopPreDefine.h"

// 通知
extern NSString *const ZZNotification_ReachabilityChanged;

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

typedef NS_ENUM(NSInteger, ZZNetworkStatus) {
    // Apple NetworkStatus Compatible Names.
    ZZNotReachable = 0,
    ZZReachableViaWiFi = 2,
    ZZReachableViaWWAN = 1
};

@class ZZReachability;

typedef void (^ZZNetworkReachable)(ZZReachability * reachability);
typedef void (^ZZNetworkUnreachable)(ZZReachability * reachability);


@interface ZZReachability : NSObject

@property (nonatomic, copy) ZZNetworkReachable    reachableBlock;   //  this is called on a background thread
@property (nonatomic, copy) ZZNetworkUnreachable  unreachableBlock; //  this is called on a background thread

@property (nonatomic, assign) BOOL reachableOnWWAN;


+(instancetype)reachabilityWithHostname:(NSString*)hostname;
// This is identical to the function above, but is here to maintain
//compatibility with Apples original code. (see .m)
+(instancetype)reachabilityWithHostName:(NSString*)hostname;
+(instancetype)reachabilityForInternetConnection;
+(instancetype)reachabilityWithAddress:(void *)hostAddress;
+(instancetype)reachabilityForLocalWiFi;

-(instancetype)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;

-(BOOL)startNotifier;
-(void)stopNotifier;

-(BOOL)isReachable;
-(BOOL)isReachableViaWWAN;
-(BOOL)isReachableViaWiFi;

// WWAN may be available, but not active until a connection has been established.
// WiFi may require a connection for VPN on Demand.
-(BOOL)isConnectionRequired; // Identical DDG variant.
-(BOOL)connectionRequired; // Apple's routine.
// Dynamic, on demand connection?
-(BOOL)isConnectionOnDemand;
// Is user intervention required?
-(BOOL)isInterventionRequired;

-(ZZNetworkStatus)currentReachabilityStatus;
-(SCNetworkReachabilityFlags)reachabilityFlags;
-(NSString*)currentReachabilityString;
-(NSString*)currentReachabilityFlags;

@end