//
//  ZZBaseViewController.m
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/7.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "ZZBaseViewController.h"
#import "ZZCommon.h"
#import "ZZRuntime.h"

#pragma mark - def

#pragma mark - override

#pragma mark - api

#pragma mark - model event
#pragma mark 1 notification
#pragma mark 2 KVO

#pragma mark - view event
#pragma mark 1 target-action
#pragma mark 2 delegate dataSource protocol

#pragma mark - private
#pragma mark - get / set

#pragma mark -
@interface UIViewController (ZZBase_private)

// 某些vc(UITableViewController)加载的时候不执行loadView方法
@property (nonatomic, assign) BOOL isLoadedLoadView;

@end

@implementation UIViewController (ZZBase)

+ (void)load
{
    [ZZRuntime swizzleInstanceMethodWithClass:[UIViewController class] originalSel:@selector(loadView)
                               replacementSel:@selector(zz__loadView)];
    [ZZRuntime swizzleInstanceMethodWithClass:[UIViewController class] originalSel:@selector(viewDidLoad)
                               replacementSel:@selector(zz__viewDidLoad)];
    [ZZRuntime swizzleInstanceMethodWithClass:[UIViewController class] originalSel:NSSelectorFromString(@"dealloc")
                               replacementSel:@selector(zz__dealloc)];
    [ZZRuntime swizzleInstanceMethodWithClass:[UIViewController class] originalSel:@selector(didReceiveMemoryWarning)
                               replacementSel:@selector(zz__didReceiveMemoryWarning)];
}

- (void)zz__loadView
{
    [self zz__loadView];
    
    [self __handleLoadView];
}

- (void)zz__dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    if ([self respondsToSelector:@selector(destroyEvents)])
        [self performSelector:@selector(destroyEvents)];
    
    if ([self respondsToSelector:@selector(destroyViews)])
        [self performSelector:@selector(destroyViews)];
    
    if ([self respondsToSelector:@selector(destroyFields)])
        [self performSelector:@selector(destroyFields)];
    
    [self zz__dealloc];
}

- (void)zz__viewDidLoad
{
    [self __handleLoadView];
    
    if ([self respondsToSelector:@selector(loadData)])
        [self performSelector:@selector(loadData)];
    
    [self zz__viewDidLoad];
}

- (void)zz__didReceiveMemoryWarning
{
    if ([self isViewLoaded] && [self.view window] == nil)
    {
        if ([self respondsToSelector:@selector(cleanData)])
            [self performSelector:@selector(cleanData)];
    }
    
    [self zz__didReceiveMemoryWarning];
}

#pragma mark - private
- (void)__handleLoadView
{
    if (self.isLoadedLoadView)
        return;
    
    self.isLoadedLoadView = YES;
    
    if ([self respondsToSelector:@selector(createFields)])
        [self performSelector:@selector(createFields)];
    
    if ([self respondsToSelector:@selector(createViews)])
        [self performSelector:@selector(createViews)];
    
    if ([self respondsToSelector:@selector(enterBackground)])
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    if ([self respondsToSelector:@selector(enterForeground)])
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    if ([self respondsToSelector:@selector(createEvents)])
        [self performSelector:@selector(createEvents)];
}
@end

@implementation UIViewController(ZZBase_private)

@dynamic isLoadedLoadView;

- (BOOL)isLoadedLoadView
{
    return [objc_getAssociatedObject(self, "VC.isLoadedLoadView") boolValue];
}
- (void)setIsLoadedLoadView:(BOOL)isLoadedLoadView
{
    objc_setAssociatedObject(self, "VC.isLoadedLoadView", @(isLoadedLoadView), OBJC_ASSOCIATION_ASSIGN);
}
@end

