//
//  UIWindow+ZZ.m
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/31.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "UIWindow+ZZ.h"

@implementation UIWindow (ZZ)

+ (UIViewController *)KeyWindowTopMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController)
        topController = topController.presentedViewController;
    
    return topController;
}

@end

