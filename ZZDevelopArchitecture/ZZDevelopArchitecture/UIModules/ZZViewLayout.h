//
//  ZZViewLayout.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/7.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZZViewFrameBuilderDirection) {
    ZZViewFrameBuilderDirectionRight = 0,
    ZZViewFrameBuilderDirectionLeft,
    ZZViewFrameBuilderDirectionUp,
    ZZViewFrameBuilderDirectionDown,
};

@interface ZZViewFrameBuilder : NSObject

@property (nonatomic, assign, readonly) UIView *view;
@property (nonatomic) BOOL automaticallyCommitChanges; // Default is YES

- (id)initWithView:(UIView *)view;

+ (ZZViewFrameBuilder *)frameBuilderForView:(UIView *)view;

- (void)commit;
- (void)reset;
- (void)update:(void (^)(ZZViewFrameBuilder *builder))block;

// Configure
- (ZZViewFrameBuilder *)enableAutoCommit;
- (ZZViewFrameBuilder *)disableAutoCommit;

// Move
- (ZZViewFrameBuilder *)setX:(CGFloat)x;
- (ZZViewFrameBuilder *)setY:(CGFloat)y;
- (ZZViewFrameBuilder *)setOriginWithX:(CGFloat)x y:(CGFloat)y;

- (ZZViewFrameBuilder *)moveWithOffsetX:(CGFloat)offsetX;
- (ZZViewFrameBuilder *)moveWithOffsetY:(CGFloat)offsetY;
- (ZZViewFrameBuilder *)moveWithOffsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY;

- (ZZViewFrameBuilder *)centerInSuperview;
- (ZZViewFrameBuilder *)centerHorizontallyInSuperview;
- (ZZViewFrameBuilder *)centerVerticallyInSuperview;

- (ZZViewFrameBuilder *)alignToTopInSuperviewWithInset:(CGFloat)inset;
- (ZZViewFrameBuilder *)alignToBottomInSuperviewWithInset:(CGFloat)inset;
- (ZZViewFrameBuilder *)alignLeftInSuperviewWithInset:(CGFloat)inset;
- (ZZViewFrameBuilder *)alignRightInSuperviewWithInset:(CGFloat)inset;

- (ZZViewFrameBuilder *)alignToTopInSuperviewWithInsets:(UIEdgeInsets)insets;
- (ZZViewFrameBuilder *)alignToBottomInSuperviewWithInsets:(UIEdgeInsets)insets;
- (ZZViewFrameBuilder *)alignLeftInSuperviewWithInsets:(UIEdgeInsets)insets;
- (ZZViewFrameBuilder *)alignRightInSuperviewWithInsets:(UIEdgeInsets)insets;

- (ZZViewFrameBuilder *)alignToTopOfView:(UIView *)view offset:(CGFloat)offset;
- (ZZViewFrameBuilder *)alignToBottomOfView:(UIView *)view offset:(CGFloat)offset;
- (ZZViewFrameBuilder *)alignLeftOfView:(UIView *)view offset:(CGFloat)offset;
- (ZZViewFrameBuilder *)alignRightOfView:(UIView *)view offset:(CGFloat)offset;

+ (void)alignViews:(NSArray *)views direction:(ZZViewFrameBuilderDirection)direction spacing:(CGFloat)spacing;
+ (void)alignViews:(NSArray *)views direction:(ZZViewFrameBuilderDirection)direction spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block;

+ (void)alignViewsVertically:(NSArray *)views spacing:(CGFloat)spacing;
+ (void)alignViewsVertically:(NSArray *)views spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block;
+ (void)alignViewsHorizontally:(NSArray *)views spacing:(CGFloat)spacing;
+ (void)alignViewsHorizontally:(NSArray *)views spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block;

+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views spacing:(CGFloat)spacing;
+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block;

+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views constrainedToWidth:(CGFloat)constrainedWidth spacing:(CGFloat)spacing;
+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views constrainedToWidth:(CGFloat)constrainedWidth spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block;

// Resize
- (ZZViewFrameBuilder *)setWidth:(CGFloat)width;
- (ZZViewFrameBuilder *)setHeight:(CGFloat)height;
- (ZZViewFrameBuilder *)setSize:(CGSize)size;
- (ZZViewFrameBuilder *)setSizeWithWidth:(CGFloat)width height:(CGFloat)height;
- (ZZViewFrameBuilder *)setSizeToFitWidth;
- (ZZViewFrameBuilder *)setSizeToFitHeight;
- (ZZViewFrameBuilder *)setSizeToFit;

+ (void)sizeToFitViews:(NSArray *)views;

@end


@interface UIView (uZZ_frameBuilder)

- (ZZViewFrameBuilder *)uZZ_frameBuilder;

@end


@interface UIView (uZZ_positioning)

@property (nonatomic, assign) CGFloat   uZZ_x;
@property (nonatomic, assign) CGFloat   uZZ_y;
@property (nonatomic, assign) CGFloat   uZZ_width;
@property (nonatomic, assign) CGFloat   uZZ_height;
@property (nonatomic, assign) CGPoint   uZZ_origin;
@property (nonatomic, assign) CGSize    uZZ_size;
@property (nonatomic, assign) CGFloat   uZZ_bottom;
@property (nonatomic, assign) CGFloat   uZZ_right;
@property (nonatomic, assign) CGFloat   uZZ_centerX;
@property (nonatomic, assign) CGFloat   uZZ_centerY;
@property (nonatomic, weak, readonly) UIView *uZZ_lastSubviewOnX;
@property (nonatomic, weak, readonly) UIView *uZZ_lastSubviewOnY;

@end
