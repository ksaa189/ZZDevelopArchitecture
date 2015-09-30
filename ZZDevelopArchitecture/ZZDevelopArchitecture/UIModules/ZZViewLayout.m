//
//  ZZViewLayout.m
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/7.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "ZZViewLayout.h"

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

typedef NS_ENUM(NSUInteger, ZZViewFrameBuilderEdge) {
    ZZViewFrameBuilderEdgeTop,
    ZZViewFrameBuilderEdgeBottom,
    ZZViewFrameBuilderEdgeLeft,
    ZZViewFrameBuilderEdgeRight,
};

static inline CGRect ZZRectInsets(CGRect rect, CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
{
    return UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(top, left, bottom, right));
}

static inline CGRect ZZRectWithSize(CGRect rect, CGFloat width, CGFloat height) {
    rect.size.width = width;
    rect.size.height = height;
    
    return rect;
}

static inline CGRect ZZRectFromSize(CGFloat width, CGFloat height)
{
    return ZZRectWithSize(CGRectZero, width, height);
}


static inline CGRect ZZRectWithWidth(CGRect rect, CGFloat width) {
    rect.size.width = width;
    
    return rect;
}

static inline CGRect ZZRectWithHeight(CGRect rect, CGFloat height)
{
    rect.size.height = height;
    
    return rect;
}

static inline CGRect ZZRectWithOrigin(CGRect rect, CGFloat x, CGFloat y)
{
    rect.origin.x = x;
    rect.origin.y = y;
    
    return rect;
}

static inline CGRect ZZRectWithX(CGRect rect, CGFloat x)
{
    rect.origin.x = x;
    
    return rect;
}

static inline CGRect ZZRectWithY(CGRect rect, CGFloat y)
{
    rect.origin.y = y;
    
    return rect;
}

static inline CGPoint ZZPointWithOffset(CGPoint p, CGFloat dx, CGFloat dy)
{
    return CGPointMake(p.x + dx, p.y + dy);
}

static inline CGPoint ZZPointCenterInSize(CGSize s)
{
    return CGPointMake(roundf(s.width / 2), roundf(s.height / 2));
}

static inline CGPoint ZZPointIntegral(CGPoint point)
{
    point.x = floorf(point.x);
    point.y = floorf(point.y);
    return point;
}

static inline CGPoint ZZRectCenter(CGRect rect)
{
    return ZZPointIntegral((CGPoint){
        .x = CGRectGetMidX(rect),
        .y = CGRectGetMidY(rect)
    });
}

static inline CGRect ZZRectMove(CGRect rect, CGFloat dx, CGFloat dy)
{
    rect.origin.x += dx;
    rect.origin.y += dy;
    
    return rect;
}

static inline CGSize ZZEdgeInsetsInsetSize(CGSize size, UIEdgeInsets insets)
{
    size.width  -= (insets.left + insets.right);
    size.height -= (insets.top  + insets.bottom);
    
    return size;
}

static inline UIEdgeInsets ZZEdgeInsetsUnion(UIEdgeInsets insets1, UIEdgeInsets insets2)
{
    insets1.top    += insets2.top;
    insets1.left   += insets2.left;
    insets1.bottom += insets2.bottom;
    insets1.right  += insets2.right;
    
    return insets1;
}

#pragma mark- ZZViewFrameBuilder
@interface ZZViewFrameBuilder ()

@property (nonatomic) CGRect frame;

@end

@implementation ZZViewFrameBuilder

- (id)initWithView:(UIView *)view
{
    self = [super init];
    if (self)
    {
        _view = view;
        _frame = view.frame;
        _automaticallyCommitChanges = YES;
    }
    
    return self;
}

+ (ZZViewFrameBuilder *)frameBuilderForView:(UIView *)view
{
    return [[[self class] alloc] initWithView:view];
}

#pragma mark - Properties

- (void)setFrame:(CGRect)frame
{
    _frame = frame;
    
    if (self.automaticallyCommitChanges)
    {
        [self commit];
    }
}

#pragma mark - Impl

- (void)commit
{
    self.view.frame = self.frame;
}

- (void)reset
{
    self.frame = self.view.frame;
}

- (void)update:(void (^)(ZZViewFrameBuilder *builder))block
{
    [self disableAutoCommit];
    block(self);
    [self commit];
}

- (ZZViewFrameBuilder *)performChangesInGroupWithBlock:(void (^)(void))block
{
    BOOL automaticCommitEnabled = self.automaticallyCommitChanges;
    
    self.automaticallyCommitChanges = NO;
    block();
    self.automaticallyCommitChanges = automaticCommitEnabled;
    
    if (self.automaticallyCommitChanges)
    {
        [self commit];
    }
    
    return self;
}

#pragma mark - Configure

- (ZZViewFrameBuilder *)enableAutoCommit
{
    self.automaticallyCommitChanges = YES;
    
    return self;
}

- (ZZViewFrameBuilder *)disableAutoCommit
{
    self.automaticallyCommitChanges = NO;
    
    return self;
}

#pragma mark - Move

- (ZZViewFrameBuilder *)setX:(CGFloat)x
{
    self.frame = ZZRectWithX(self.frame, x);
    
    return self;
}

- (ZZViewFrameBuilder *)setY:(CGFloat)y
{
    self.frame = ZZRectWithY(self.frame, y);
    
    return self;
}

- (ZZViewFrameBuilder *)setOriginWithX:(CGFloat)x y:(CGFloat)y
{
    return [self performChangesInGroupWithBlock:^{
        [[self setX:x] setY:y];
    }];
}

- (ZZViewFrameBuilder *)moveWithOffsetX:(CGFloat)offsetX
{
    self.frame = ZZRectWithX(self.frame, self.frame.origin.x + offsetX);
    
    return self;
}

- (ZZViewFrameBuilder *)moveWithOffsetY:(CGFloat)offsetY
{
    self.frame = ZZRectWithY(self.frame, self.frame.origin.y + offsetY);
    
    return self;
}

- (ZZViewFrameBuilder *)moveWithOffsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY
{
    return [self performChangesInGroupWithBlock:^{
        [[self moveWithOffsetX:offsetX] moveWithOffsetY:offsetY];
    }];
}

- (ZZViewFrameBuilder *)centerInSuperview
{
    return [self performChangesInGroupWithBlock:^{
        [[self centerHorizontallyInSuperview] centerVerticallyInSuperview];
    }];
}

- (ZZViewFrameBuilder *)centerHorizontallyInSuperview
{
    if (!self.view.superview)
    {
        return self;
    }
    
    self.frame = ZZRectWithX(self.frame, roundf((self.view.superview.bounds.size.width - self.frame.size.width) / 2));
    
    return self;
}

- (ZZViewFrameBuilder *)centerVerticallyInSuperview
{
    if (!self.view.superview)
    {
        return self;
    }
    
    self.frame = ZZRectWithY(self.frame, roundf((self.view.superview.bounds.size.height - self.frame.size.height) / 2));
    
    return self;
}

- (ZZViewFrameBuilder *)alignToTopInSuperviewWithInset:(CGFloat)inset
{
    [self alignToTopInSuperviewWithInsets:UIEdgeInsetsMake(inset, 0.0f, 0.0f, 0.0f)];
    
    return self;
}

- (ZZViewFrameBuilder *)alignToBottomInSuperviewWithInset:(CGFloat)inset
{
    [self alignToBottomInSuperviewWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];
    
    return self;
}

- (ZZViewFrameBuilder *)alignLeftInSuperviewWithInset:(CGFloat)inset
{
    [self alignLeftInSuperviewWithInsets:UIEdgeInsetsMake(0.0f, inset, 0.0f, 0.0f)];
    
    return self;
    
}

- (ZZViewFrameBuilder *)alignRightInSuperviewWithInset:(CGFloat)inset
{
    [self alignRightInSuperviewWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, inset)];
    
    return self;
}

- (ZZViewFrameBuilder *)alignToTopInSuperviewWithInsets:(UIEdgeInsets)insets
{
    self.frame = ZZRectWithOrigin(self.frame,
                                  self.frame.origin.x + insets.left - insets.right,
                                  insets.top - insets.bottom);
    
    return self;
}

- (ZZViewFrameBuilder *)alignToBottomInSuperviewWithInsets:(UIEdgeInsets)insets
{
    self.frame = ZZRectWithOrigin(self.frame,
                                  self.frame.origin.x + insets.left - insets.right,
                                  self.view.superview.bounds.size.height - self.frame.size.height + insets.top - insets.bottom);
    
    return self;
}

- (ZZViewFrameBuilder *)alignLeftInSuperviewWithInsets:(UIEdgeInsets)insets
{
    self.frame = ZZRectWithOrigin(self.frame,
                                  insets.left - insets.right,
                                  self.frame.origin.y + insets.top - insets.bottom);
    
    return self;
}

- (ZZViewFrameBuilder *)alignRightInSuperviewWithInsets:(UIEdgeInsets)insets
{
    self.frame = ZZRectWithOrigin(self.frame,
                                  self.view.superview.bounds.size.width - self.frame.size.width + insets.left - insets.right,
                                  self.frame.origin.y + insets.top - insets.bottom);
    
    return self;
}

- (ZZViewFrameBuilder *)alignToView:(UIView *)view edge:(ZZViewFrameBuilderEdge)edge offset:(CGFloat)offset
{
    CGRect viewFrame = [view.superview convertRect:view.frame toView:self.view.superview];
    
    switch (edge)
    {
        case ZZViewFrameBuilderEdgeTop:
            self.frame = ZZRectWithY(self.frame, viewFrame.origin.y - offset - self.frame.size.height);
            break;
        case ZZViewFrameBuilderEdgeBottom:
            self.frame = ZZRectWithY(self.frame, CGRectGetMaxY(viewFrame) + offset);
            break;
        case ZZViewFrameBuilderEdgeLeft:
            self.frame = ZZRectWithX(self.frame, viewFrame.origin.x - offset - self.frame.size.width);
            break;
        case ZZViewFrameBuilderEdgeRight:
            self.frame = ZZRectWithX(self.frame, CGRectGetMaxX(viewFrame) + offset);
            break;
        default:
            break;
    }
    
    return self;
}

- (ZZViewFrameBuilder *)alignToTopOfView:(UIView *)view offset:(CGFloat)offset
{
    return [self alignToView:view edge:ZZViewFrameBuilderEdgeTop offset:offset];
}

- (ZZViewFrameBuilder *)alignToBottomOfView:(UIView *)view offset:(CGFloat)offset
{
    return [self alignToView:view edge:ZZViewFrameBuilderEdgeBottom offset:offset];
}

- (ZZViewFrameBuilder *)alignLeftOfView:(UIView *)view offset:(CGFloat)offset
{
    return [self alignToView:view edge:ZZViewFrameBuilderEdgeLeft offset:offset];
}

- (ZZViewFrameBuilder *)alignRightOfView:(UIView *)view offset:(CGFloat)offset
{
    return [self alignToView:view edge:ZZViewFrameBuilderEdgeRight offset:offset];
}

+ (void)alignViews:(NSArray *)views direction:(ZZViewFrameBuilderDirection)direction spacing:(CGFloat)spacing {
    return [self alignViews:views direction:direction spacingWithBlock:^CGFloat(UIView *firstView, UIView *secondView) {
        return spacing;
    }];;
}

+ (void)alignViews:(NSArray *)views direction:(ZZViewFrameBuilderDirection)direction spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block
{
    UIView *previousView = nil;
    for (UIView *view in views)
    {
        if (previousView)
        {
            CGFloat spacing = block != nil ? block(previousView, view) : 0.0f;
            
            switch (direction)
            {
                case ZZViewFrameBuilderDirectionRight:
                    [[[self class] frameBuilderForView:view] alignRightOfView:previousView offset:spacing];
                    break;
                case ZZViewFrameBuilderDirectionLeft:
                    [[[self class] frameBuilderForView:view] alignLeftOfView:previousView offset:spacing];
                    break;
                case ZZViewFrameBuilderDirectionUp:
                    [[[self class] frameBuilderForView:view] alignToTopOfView:previousView offset:spacing];
                    break;
                case ZZViewFrameBuilderDirectionDown:
                    [[[self class] frameBuilderForView:view] alignToBottomOfView:previousView offset:spacing];
                    break;
                default:
                    break;
            }
        }
        
        previousView = view;
    }
}

+ (void)alignViewsVertically:(NSArray *)views spacing:(CGFloat)spacing
{
    [self alignViewsVertically:views spacingWithBlock:^CGFloat(UIView *firstView, UIView *secondView) {
        return spacing;
    }];
}

+ (void)alignViewsVertically:(NSArray *)views spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block
{
    [self alignViews:views direction:ZZViewFrameBuilderDirectionDown spacingWithBlock:block];
}

+ (void)alignViewsHorizontally:(NSArray *)views spacing:(CGFloat)spacing
{
    [self alignViewsHorizontally:views spacingWithBlock:^CGFloat(UIView *firstView, UIView *secondView) {
        return spacing;
    }];
}

+ (void)alignViewsHorizontally:(NSArray *)views spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block
{
    [self alignViews:views direction:ZZViewFrameBuilderDirectionRight spacingWithBlock:block];
}

+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views spacing:(CGFloat)spacing
{
    return [self heightForViewsAlignedVertically:views constrainedToWidth:0.0f spacing:spacing];
}

+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block
{
    return [self heightForViewsAlignedVertically:views constrainedToWidth:0.0f spacingWithBlock:block];
}

+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views constrainedToWidth:(CGFloat)constrainedWidth spacing:(CGFloat)spacing
{
    return [self heightForViewsAlignedVertically:views constrainedToWidth:constrainedWidth spacingWithBlock:^CGFloat(UIView *firstView, UIView *secondView) {
        return spacing;
    }];
}

+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views constrainedToWidth:(CGFloat)constrainedWidth spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block
{
    CGFloat height = 0.0f;
    
    UIView *previousView = nil;
    for (UIView *view in views)
    {
        if (constrainedWidth > FLT_EPSILON)
        {
            height += [view sizeThatFits:CGSizeMake(constrainedWidth, CGFLOAT_MAX)].height;
        }
        else
        {
            height += view.bounds.size.height;
        }
        
        if (previousView)
        {
            height += block != nil ? block(previousView, view) : 0.0f;
        }
        
        previousView = view;
    }
    
    return height;
}

#pragma mark - Resize

- (ZZViewFrameBuilder *)setWidth:(CGFloat)width
{
    self.frame = ZZRectWithWidth(self.frame, width);
    
    return self;
}

- (ZZViewFrameBuilder *)setHeight:(CGFloat)height
{
    self.frame = ZZRectWithHeight(self.frame, height);
    
    return self;
}

- (ZZViewFrameBuilder *)setSize:(CGSize)size
{
    self.frame = ZZRectWithSize(self.frame, size.width, size.height);
    
    return self;
}

- (ZZViewFrameBuilder *)setSizeWithWidth:(CGFloat)width height:(CGFloat)height
{
    return [self performChangesInGroupWithBlock:^{
        [[self setWidth:width] setHeight:height];
    }];
}

- (ZZViewFrameBuilder *)setSizeToFitWidth
{
    CGRect frame = self.frame;
    frame.size.width = [self.view sizeThatFits:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)].width;
    self.frame = frame;
    
    return self;
}

- (ZZViewFrameBuilder *)setSizeToFitHeight
{
    CGRect frame = self.frame;
    frame.size.height = [self.view sizeThatFits:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)].height;
    self.frame = frame;
    
    return self;
}

- (ZZViewFrameBuilder *)setSizeToFit
{
    CGSize size = [self.view sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    
    CGRect frame = self.frame;
    frame.size.height = size.height;
    frame.size.width = size.width;
    self.frame = frame;
    
    return self;
}

+ (void)sizeToFitViews:(NSArray *)views
{
    for (UIView *view in views)
    {
        [view sizeToFit];
    }
}

@end
@implementation UIView (uZZ_frameBuilder)

- (ZZViewFrameBuilder *)uZZ_frameBuilder
{
    return [ZZViewFrameBuilder frameBuilderForView:self];
}

@end

@implementation UIView (uZZ_positioning)

@dynamic uZZ_x;
@dynamic uZZ_y;
@dynamic uZZ_width;
@dynamic uZZ_height;
@dynamic uZZ_origin;
@dynamic uZZ_size;

// Setters
- (void)setUZZ_x:(CGFloat)x
{
    CGRect r        = self.frame;
    r.origin.x      = x;
    self.frame      = r;
}

- (void)setUZZ_y:(CGFloat)y
{
    CGRect r        = self.frame;
    r.origin.y      = y;
    self.frame      = r;
}

- (void)setUZZ_width:(CGFloat)width
{
    CGRect r        = self.frame;
    r.size.width    = width;
    self.frame      = r;
}

- (void)setUZZ_height:(CGFloat)height
{
    CGRect r        = self.frame;
    r.size.height   = height;
    self.frame      = r;
}

- (void)setUZZ_origin:(CGPoint)origin
{
    self.uZZ_x          = origin.x;
    self.uZZ_y          = origin.y;
}

- (void)setUZZ_size:(CGSize)size
{
    self.uZZ_width      = size.width;
    self.uZZ_height     = size.height;
}

- (void)setUZZ_right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (void)setUZZ_bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)setUZZ_centerX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (void)setUZZ_centerY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

// Getters
- (CGFloat)uZZ_x
{
    return self.frame.origin.x;
}

- (CGFloat)uZZ_y
{
    return self.frame.origin.y;
}

- (CGFloat)uZZ_width
{
    return self.frame.size.width;
}

- (CGFloat)uZZ_height
{
    return self.frame.size.height;
}

- (CGPoint)uZZ_origin
{
    return CGPointMake(self.uZZ_x, self.uZZ_y);
}

- (CGSize)uZZ_size
{
    return CGSizeMake(self.uZZ_width, self.uZZ_height);
}

- (CGFloat)uZZ_right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)uZZ_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)uZZ_centerX
{
    return self.center.x;
}

- (CGFloat)uZZ_centerY
{
    return self.center.y;
}

- (UIView *)uZZ_lastSubviewOnX
{
    if (self.subviews.count > 0)
    {
        UIView *outView = self.subviews[0];
        
        for(UIView *v in self.subviews)
        {
            if(v.uZZ_x > outView.uZZ_x)
                outView = v;
        }
        
        return outView;
    }
    
    return nil;
}

- (UIView *)uZZ_lastSubviewOnY
{
    if(self.subviews.count > 0)
    {
        UIView *outView = self.subviews[0];
        
        for(UIView *v in self.subviews)
        {
            if(v.uZZ_y > outView.uZZ_y)
                outView = v;
        }
        
        return outView;
    }
    
    return nil;
}

@end