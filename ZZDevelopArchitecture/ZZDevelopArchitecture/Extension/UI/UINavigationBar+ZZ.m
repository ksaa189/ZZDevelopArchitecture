//
//  UINavigationBar+ZZ.m
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/4.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "UINavigationBar+ZZ.h"
#import "NSObject+ZZ.h"

@implementation UINavigationBar (ZZ)

- (UIView *)overlay
{
    return [self getAssociatedObjectForKey:"ZZ.navigationBar.overlay"];
}

- (void)setOverlay:(UIView *)overlay
{
    [self retainAssociatedObject:overlay forKey:"ZZ.navigationBar.overlay"];
}

- (UIImage *)emptyImage
{
    return [self getAssociatedObjectForKey:"ZZ.navigationBar.image"];
}

- (void)setEmptyImage:(UIImage *)image
{
    [self retainAssociatedObject:image forKey:"ZZ.navigationBar.image"];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    if (self.overlay == nil)
    {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[UIImage new]];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlay atIndex:0];
    }
    
    self.overlay.backgroundColor = backgroundColor;
}

- (void)setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)setContentAlpha:(CGFloat)alpha
{
    if (self.overlay == nil)
    {
        [self setBackgroundColor:self.barTintColor];
    }
    
    [self setAlpha:alpha forSubviewsOfView:self];
    
    if (alpha == 1)
    {
        if (self.emptyImage == nil)
        {
            self.emptyImage = [UIImage new];
        }
        
        self.backIndicatorImage = self.emptyImage;
    }
}

- (void)setAlpha:(CGFloat)alpha forSubviewsOfView:(UIView *)view
{
    for (UIView *subview in view.subviews)
    {
        if (subview == self.overlay)
        {
            continue;
        }
        subview.alpha = alpha;
        [self setAlpha:alpha forSubviewsOfView:subview];
    }
}

- (void)reset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:nil];
    
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

@end

