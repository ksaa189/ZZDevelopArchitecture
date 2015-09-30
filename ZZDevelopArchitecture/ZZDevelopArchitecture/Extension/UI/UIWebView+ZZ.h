//
//  UIWebView+ZZ.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/31.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (ZZ)

// 清理网页,如果isCleanCache = YES, 就连NSURLCache,Disk,Memory也清理
- (void)clean:(BOOL)isCleanCache;

// 获取当前webview页面的innerhtml
- (NSString*)innerHTML;

// 获取当前webview页面的userAgent
- (NSString*)userAgent;

@end
