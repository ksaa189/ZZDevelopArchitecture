//
//  UIWebView+ZZ.m
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/31.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "UIWebView+ZZ.h"

@implementation UIWebView (ZZ)


- (void)clean:(BOOL)isCleanCache
{
    [self loadHTMLString:@"" baseURL:nil];
    [self stopLoading];
    self.delegate = nil;
    if (isCleanCache)
    {
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [[NSURLCache sharedURLCache] setDiskCapacity:0];
        [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    }
}


- (NSString*)innerHTML
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
}

- (NSString*)userAgent
{
    return [self stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];;
}

@end
