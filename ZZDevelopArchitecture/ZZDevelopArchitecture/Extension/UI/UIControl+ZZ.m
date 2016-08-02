//
//  UIControl+ZZ.m
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/4.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "UIControl+ZZ.h"
#import "ZZDevelopPreDefine.h"
#import "NSObject+ZZ.h"

#undef	UIControl_key_events
#define UIControl_key_events	"UIControl.events"

static NSDictionary *ZZ_DicControlEventString = nil;
static NSDictionary *ZZ_DicControlStringEvent = nil;


@implementation UIControl (ZZ)

+ (void)load
{
    ZZ_DicControlEventString = @{@(UIControlEventTouchDown): @"UIControlEventTouchDown",
                                 @(UIControlEventTouchDownRepeat): @"UIControlEventTouchDownRepeat",
                                 @(UIControlEventTouchDragInside): @"UIControlEventTouchDragInside",
                                 @(UIControlEventTouchDragOutside): @"UIControlEventTouchDragOutside",
                                 @(UIControlEventTouchDragEnter): @"UIControlEventTouchDragEnter",
                                 @(UIControlEventTouchDragExit): @"UIControlEventTouchDragExit",
                                 @(UIControlEventTouchUpInside): @"UIControlEventTouchUpInside",
                                 @(UIControlEventTouchUpOutside): @"UIControlEventTouchUpOutside",
                                 @(UIControlEventTouchCancel): @"UIControlEventTouchCancel",
                                 @(UIControlEventValueChanged): @"UIControlEventValueChanged",
                                 @(UIControlEventEditingDidBegin): @"UIControlEventEditingDidBegin",
                                 @(UIControlEventEditingChanged): @"UIControlEventEditingChanged",
                                 @(UIControlEventEditingDidEnd): @"UIControlEventEditingDidEnd",
                                 @(UIControlEventEditingDidEndOnExit): @"UIControlEventEditingDidEndOnExit",
                                 @(UIControlEventAllTouchEvents): @"UIControlEventAllTouchEvents",
                                 @(UIControlEventAllEditingEvents): @"UIControlEventAllEditingEvents",
                                 @(UIControlEventApplicationReserved): @"UIControlEventApplicationReserved",
                                 @(UIControlEventSystemReserved): @"UIControlEventSystemReserved",
                                 @(UIControlEventAllEvents): @"UIControlEventAllEvents"
                                 };
    
    ZZ_DicControlStringEvent = @{@"UIControlEventTouchDown": @(UIControlEventTouchDown),
                                 @"UIControlEventTouchDownRepeat": @(UIControlEventTouchDownRepeat),
                                 @"UIControlEventTouchDragInside": @(UIControlEventTouchDragInside),
                                 @"UIControlEventTouchDragOutside": @(UIControlEventTouchDragOutside),
                                 @"UIControlEventTouchDragEnter": @(UIControlEventTouchDragEnter),
                                 @"UIControlEventTouchDragExit": @(UIControlEventTouchDragExit),
                                 @"UIControlEventTouchUpInside": @(UIControlEventTouchUpInside),
                                 @"UIControlEventTouchUpOutside": @(UIControlEventTouchUpOutside),
                                 @"UIControlEventTouchCancel": @(UIControlEventTouchCancel),
                                 @"UIControlEventValueChanged": @(UIControlEventValueChanged),
                                 @"UIControlEventEditingDidBegin": @(UIControlEventEditingDidBegin),
                                 @"UIControlEventEditingChanged": @(UIControlEventEditingChanged),
                                 @"UIControlEventEditingDidEnd": @(UIControlEventEditingDidEnd),
                                 @"UIControlEventEditingDidEndOnExit": @(UIControlEventEditingDidEndOnExit),
                                 @"UIControlEventAllTouchEvents": @(UIControlEventAllTouchEvents),
                                 @"UIControlEventAllEditingEvents": @(UIControlEventAllEditingEvents),
                                 @"UIControlEventApplicationReserved": @(UIControlEventApplicationReserved),
                                 @"UIControlEventSystemReserved": @(UIControlEventSystemReserved),
                                 @"UIControlEventAllEvents": @(UIControlEventAllEvents)
                                 };
}

- (void)dealloc
{
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, UIControl_key_events);
    if (opreations)
    {
        [opreations enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self removeHandlerForEvent:[UIControl eventWithName:key]];
        }];
        [self assignAssociatedObject:nil forKey:UIControl_key_events];
    }
}

- (void)removeHandlerForEvent:(UIControlEvents)event
{
    
    NSString *methodName = [UIControl eventName:event];
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, UIControl_key_events);
    
    if(opreations == nil)
    {
        opreations = [NSMutableDictionary dictionaryWithCapacity:2];
        [self retainAssociatedObject:opreations forKey:UIControl_key_events];
    }
    
    [opreations removeObjectForKey:methodName];
    [self removeTarget:self action:NSSelectorFromString(methodName) forControlEvents:event];
}

- (void)handleControlEvent:(UIControlEvents)event withBlock:(void(^)(id sender))block {
    
    NSString *methodName = [UIControl eventName:event];
    
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, UIControl_key_events);
    
    if(opreations == nil)
    {
        opreations = [NSMutableDictionary dictionaryWithCapacity:2];
        [self retainAssociatedObject:opreations forKey:UIControl_key_events];
    }
    
    [opreations setObject:[block copy] forKey:methodName];
    [self addTarget:self action:NSSelectorFromString(methodName) forControlEvents:event];
}


- (void)UIControlEventTouchDown{[self callActionBlock:UIControlEventTouchDown];}
- (void)UIControlEventTouchDownRepeat{[self callActionBlock:UIControlEventTouchDownRepeat];}
- (void)UIControlEventTouchDragInside{[self callActionBlock:UIControlEventTouchDragInside];}
- (void)UIControlEventTouchDragOutside{[self callActionBlock:UIControlEventTouchDragOutside];}
- (void)UIControlEventTouchDragEnter{[self callActionBlock:UIControlEventTouchDragEnter];}
- (void)UIControlEventTouchDragExit{[self callActionBlock:UIControlEventTouchDragExit];}
- (void)UIControlEventTouchUpInside{[self callActionBlock:UIControlEventTouchUpInside];}
- (void)UIControlEventTouchUpOutside{[self callActionBlock:UIControlEventTouchUpOutside];}
- (void)UIControlEventTouchCancel{[self callActionBlock:UIControlEventTouchCancel];}
- (void)UIControlEventValueChanged{[self callActionBlock:UIControlEventValueChanged];}
- (void)UIControlEventEditingDidBegin{[self callActionBlock:UIControlEventEditingDidBegin];}
- (void)UIControlEventEditingChanged{[self callActionBlock:UIControlEventEditingChanged];}
- (void)UIControlEventEditingDidEnd{[self callActionBlock:UIControlEventEditingDidEnd];}
- (void)UIControlEventEditingDidEndOnExit{[self callActionBlock:UIControlEventEditingDidEndOnExit];}
- (void)UIControlEventAllTouchEvents{[self callActionBlock:UIControlEventAllTouchEvents];}
- (void)UIControlEventAllEditingEvents{[self callActionBlock:UIControlEventAllEditingEvents];}
- (void)UIControlEventApplicationReserved{[self callActionBlock:UIControlEventApplicationReserved];}
- (void)UIControlEventSystemReserved{[self callActionBlock:UIControlEventSystemReserved];}
- (void)UIControlEventAllEvents{[self callActionBlock:UIControlEventAllEvents];}


- (void)callActionBlock:(UIControlEvents)event
{
    
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, UIControl_key_events);
    
    if(opreations == nil)
        return;
    
    void(^block)(id sender) = [opreations objectForKey:[UIControl eventName:event]];
    
    if (block)
        block(self);
    
}
+ (NSString *)eventName:(UIControlEvents)event
{
    return [ZZ_DicControlEventString objectForKey:@(event)];
}
+ (UIControlEvents)eventWithName:(NSString *)name
{
    return [[ZZ_DicControlStringEvent objectForKey:name] integerValue];
}

@end
