//
//  NSString+ZZ.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/2.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark -

@interface NSString (XY)

@property (nonatomic, readonly, strong) NSData *MD5Data;    //转换成MD5Data
@property (nonatomic, readonly, copy) NSString *MD5String;  //转换成MD5String

@property (nonatomic, readonly, strong) NSData *SHA1Data;   //转换成SHA1Data
@property (nonatomic, readonly, copy) NSString *SHA1String; //转换成SHA1Data

@property (nonatomic, readonly, copy) NSString *BASE64Decrypted;    //转换成BASE64Data

@property (nonatomic, readonly, strong) NSData *data;       //转换成NSData

// url相关
//在一个字符串找到所有的URL链接，寻找方法值得学习(应该是这个功能需要验证)
- (NSArray *)allURLs;
//在一个URL后面加参数，参数为NSDictionry形式，默认encoding为YES
- (NSString *)urlByAppendingDict:(NSDictionary *)params;
//在一个URL后面加参数，参数为NSDictionry形式，可选encoding
- (NSString *)urlByAppendingDict:(NSDictionary *)params encoding:(BOOL)encoding;
//在一个URL后面加参数，参数为NSArray形式，默认encoding为YES
- (NSString *)urlByAppendingArray:(NSArray *)params;
//在一个URL后面加参数，参数为NSArray形式，默认encoding为YES
- (NSString *)urlByAppendingArray:(NSArray *)params encoding:(BOOL)encoding;
//在一个URL后面加参数，参数为key value形式
- (NSString *)urlByAppendingKeyValues:(id)first, ...;

//把NSDictionry参数变成url的string形式(%@=%@&%@=%@)
//以下函数功能大致参考 上边函数
+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict;
+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict encoding:(BOOL)encoding;;
+ (NSString *)queryStringFromArray:(NSArray *)array;
+ (NSString *)queryStringFromArray:(NSArray *)array encoding:(BOOL)encoding;;
+ (NSString *)queryStringFromKeyValues:(id)first, ...;

// 将String变成URLEncoding
- (NSString *)URLEncoding;
// 将String变成URLDecoding
- (NSString *)URLDecoding;
// 将NString形式的URL参数串变成NSMutableDictionary形式
- (NSMutableDictionary *)dictionaryFromQueryComponents;

// 去掉首尾的空格和换行
- (NSString *)trim;
// 去掉首尾的 " '
- (NSString *)unwrap;
// 将自身String重复叠加几次
- (NSString *)repeat:(NSUInteger)count;
// 将所有的"//"替换成"/"
- (NSString *)normalize;

// 看当前String是否满足一个正则表达式，expression为一个正则表达式
- (BOOL)match:(NSString *)expression;
// 看当前String是否满足array中得任何一个元素
- (BOOL)matchAnyOf:(NSArray *)array;

- (BOOL)empty;
- (BOOL)notEmpty;

- (BOOL)eq:(NSString *)other;
- (BOOL)equal:(NSString *)other;

- (BOOL)is:(NSString *)other;
- (BOOL)isNot:(NSString *)other;

// 是否在array里, caseInsens 区分大小写
- (BOOL)isValueOf:(NSArray *)array;
- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens;

#pragma mark - bee里的检测
// 是否存在非法字符
- (BOOL)isNormal;
- (BOOL)isTelephone;
- (BOOL)isUserName;
- (BOOL)isChineseUserName;
- (BOOL)isPassword;
- (BOOL)isEmail;
- (BOOL)isUrl;
- (BOOL)isIPAddress;

#pragma mark - 额外的检测
// 包含一个字符和数字
- (BOOL)isHasCharacterAndNumber;
// 昵称
- (BOOL)isNickname;
- (BOOL)isTelephone2;

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset;
- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset;

+ (NSString *)fromResource:(NSString *)resName;

// 中英文混排，获取字符串长度
- (NSInteger)getLength;
- (NSInteger)getLength2;

// Unicode格式的字符串编码转成中文的方法(如\u7E8C)转换成中文,unicode编码以\u开头
- (NSString *)replaceUnicode;

/**
 * 擦除保存的值, 建议敏感信息在不用的是调用此方法擦除.
 * 如果是这样 _text = @"information"的 被分配到data区的无法擦除
 */
- (void)erasure;

// 大写字母 (International Business Machines 变成 IBM)
- (NSString*)stringByInitials;

// 返回显示字串所需要的尺寸
- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font;

- (NSTimeInterval)displayTime;

@end
