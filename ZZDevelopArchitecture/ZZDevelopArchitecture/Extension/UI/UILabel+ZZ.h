//
//  UILabel+ZZ.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/4.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ZZ)

typedef enum {
    UILabelResizeType_constantHeight = 1,
    UILabelResizeType_constantWidth,
} UILabelResizeType;

// 调整UILabel尺寸
// UILabelResizeType_constantHeight 高度不变
- (void)resize:(UILabelResizeType)type;

// 返回估计的尺寸（根据固定高度，估计宽度）
- (CGSize)estimateUISizeByHeight:(CGFloat)height;
// 返回估计的尺寸（根据固定宽度，估计高度）
- (CGSize)estimateUISizeByWidth:(CGFloat)width;


@end
