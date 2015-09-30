//
//  ZZViewControllerManager.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/7.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZDevelopPreDefine.h"

typedef UIViewController *  (^ZZViewControllerManager_createVC_block) (void);

@interface ZZViewControllerManager : UIViewController __AS_SINGLETON

@property (nonatomic, strong, readonly) NSMutableDictionary *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, copy) NSString *selectedKey;
@property (nonatomic, copy) NSString *firstKey;

//@property (nonatomic, strong, readonly) NSMutableDictionary *viewControllerSetupBlocks;     // 创建viewControllers的block

@property (nonatomic, strong, readonly) UIView *contentView; // 子视图控制器显示的view


- (void)addAViewController:(ZZViewControllerManager_createVC_block)block key:(NSString *)key;

- (void)clean;

@end


#pragma mark - category
@interface UIViewController (ZZViewControllerManager)

@property (nonatomic, weak, readonly) ZZViewControllerManager *uZZ_viewControllerManager;

@end