//
//  NSDate+ZZ.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/2.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SECOND	(1)
#define MINUTE	(60 * SECOND)
#define HOUR	(60 * MINUTE)
#define DAY		(24 * HOUR)
#define MONTH	(30 * DAY)

static NSArray *ZZ_weekdays = nil;

@interface NSDate (ZZ)

@property (nonatomic, readonly) NSInteger   year;       //NSDate对象的 日历年份
@property (nonatomic, readonly) NSInteger	month;      //NSDate对象的 日历月份
@property (nonatomic, readonly) NSInteger	day;        //NSDate对象的 日历日期
@property (nonatomic, readonly) NSInteger	hour;       //NSDate对象的 日历小时
@property (nonatomic, readonly) NSInteger	minute;     //NSDate对象的 日历分钟
@property (nonatomic, readonly) NSInteger	second;     //NSDate对象的 日历秒
@property (nonatomic, readonly) NSInteger	weekday;    //NSDate对象的 日历周末

@property (nonatomic, readonly) NSString	*stringWeekday;

// @"yyyy-MM-dd HH:mm:ss"
- (NSString *)stringWithDateFormat:(NSString *)format;

// 把NSDate对象和当前时间相比 返回一个间隔的时间说明如：“刚刚”，“1分钟前”，“1小时前等等”
- (NSString *)timeAgo;

// unix 时间戳
+ (long long)timeStamp;

// 系统当前时间
+ (NSDate *)now;

// 返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)dateAfterDay:(int)day;

// 返回距离aDate有多少天
- (NSInteger)distanceInDaysToDate:(NSDate *)aDate;

// UTC时间string缓存
@property (nonatomic, copy, readonly) NSString *stringCache;
// 重置缓存
- (NSString *)resetStringCache;
// 返回当地时区的时间
- (NSDate *)localTime;

/**
 * @brief 返回日期格式器
 * @return dateFormatter yyyy-MM-dd HH:mm:ss. dateFormatterByUTC 返回UTC格式的
 */
+ (NSDateFormatter *)dateFormatter;
+ (NSDateFormatter *)dateFormatterByUTC;
@end
