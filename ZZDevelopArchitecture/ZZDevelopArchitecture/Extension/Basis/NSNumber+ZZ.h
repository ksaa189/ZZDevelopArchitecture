//
//  NSNumber+ZZ.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/2.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef	__INT
#define __INT( __x )			[NSNumber numberWithInteger:(NSInteger)__x]

#undef	__UINT
#define __UINT( __x )			[NSNumber numberWithUnsignedInt:(NSUInteger)__x]

#undef	__FLOAT
#define	__FLOAT( __x )			[NSNumber numberWithFloat:(float)__x]

#undef	__DOUBLE
#define	__DOUBLE( __x )			[NSNumber numberWithDouble:(double)__x]

#undef	__BOOL
#define __BOOL( __x )			[NSNumber numberWithBool:(BOOL)__x]

@interface NSNumber (ZZ)

@property (nonatomic, readonly, strong) NSDate *dateValue;

- (NSString *)stringWithDateFormat:(NSString *)format;

@end
