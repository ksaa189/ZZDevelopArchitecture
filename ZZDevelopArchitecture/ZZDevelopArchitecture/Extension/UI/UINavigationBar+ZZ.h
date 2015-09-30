//
//  UINavigationBar+ZZ.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/4.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (ZZ)


// NavigationBar 变色 透明 尺寸 等方法 copy from https://github.com/ltebean/LTNavigationBar
- (void)setBackgroundColor:(UIColor *)backgroundColor;
- (void)setContentAlpha:(CGFloat)alpha;
- (void)setTranslationY:(CGFloat)translationY;
- (void)reset;

@end
