//
//  UIAcionSheet+ZZ.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/4.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIActionSheet_block_self_index)(UIActionSheet *actionSheet, NSInteger btnIndex);
typedef void(^UIActionSheet_block_self)(UIActionSheet *actionSheet);

@interface UIActionSheet (ZZ) <UIActionSheetDelegate>

- (void)handlerClickedButton:(UIActionSheet_block_self_index)aBlock;
- (void)handlerCancel:(UIActionSheet_block_self)aBlock;
- (void)handlerWillPresent:(UIActionSheet_block_self)aBlock;
- (void)handlerDidPresent:(UIActionSheet_block_self)aBlock;
- (void)handlerWillDismiss:(UIActionSheet_block_self)aBlock;
- (void)handlerDidDismiss:(UIActionSheet_block_self_index)aBlock;

@end