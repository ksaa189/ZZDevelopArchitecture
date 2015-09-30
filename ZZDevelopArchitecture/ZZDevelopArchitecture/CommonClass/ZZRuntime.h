//
//  ZZRuntime.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/7.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface ZZRuntime : NSObject

/**
 * @brief 移魂大法
 * @param clazz 原方法的类
 * @param original 原方法
 * @param replacement 劫持后的方法
 */
+ (void)swizzleInstanceMethodWithClass:(Class)clazz originalSel:(SEL)original replacementSel:(SEL)replacement;

@end

#pragma mark -

#undef	class
#define	class( x )		NSClassFromString(@ #x)

#undef	instance
#define	instance( x )	[[NSClassFromString(@ #x) alloc] init]

#pragma mark -

@interface NSObject (Runtime)

// class
// 应该是获取当前类的所有子类，不是很确定
+ (NSArray *)subClasses;
// 应该是根据协议的名字，获取所有遵循这个协议的类，不是很确定
+ (NSArray *)classesWithProtocol:(NSString *)protocolName;

// method
// 获取当前类的所有函数名
+ (NSArray *)methods;
// 获取当前类所有已prefix来头的函数名
+ (NSArray *)methodsWithPrefix:(NSString *)prefix;
// 获取当前类，直到某个父类为止的所有函数名
+ (NSArray *)methodsUntilClass:(Class)baseClass;
// 获取当前类，直到某个父类为止，并且以prefix开头的所有函数名
+ (NSArray *)methodsWithPrefix:(NSString *)prefix untilClass:(Class)baseClass;
// 将某个方法覆盖成另一个方法
+ (void *)replaceSelector:(SEL)sel1 withSelector:(SEL)sel2;

// property
// 获取当前类的所有属性名
+ (NSArray *)properties;
// 获取当前类，直到某个父类为止的所有属性名
+ (NSArray *)propertiesUntilClass:(Class)baseClass;
// 获取当前类所有已prefix来头的属性名
+ (NSArray *)propertiesWithPrefix:(NSString *)prefix;
// 获取当前类，直到某个父类为止，并且以prefix开头的所有属性名
+ (NSArray *)propertiesWithPrefix:(NSString *)prefix untilClass:(Class)baseClass;



@end