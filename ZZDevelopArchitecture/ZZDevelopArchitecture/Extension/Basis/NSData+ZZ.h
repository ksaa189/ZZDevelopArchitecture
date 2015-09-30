//
//  NSData+ZZ.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/2.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ZZ)

//把NSData转化成 MD5加密的 NSData
@property (nonatomic, readonly, strong) NSData *MD5Data;
//把NSData转化成 MD5加密的 NSString
@property (nonatomic, readonly, copy) NSString *MD5String;
//把NSData转化成 SHA1加密的 NSData
@property (nonatomic, readonly, strong) NSData *SHA1Data;
//把NSData转化成 SHA1加密的 NSString
@property (nonatomic, readonly, copy) NSString *SHA1String;
//把NSData转化成 BASE64Encrypted加密的 NSString
@property (nonatomic, readonly, copy) NSString *BASE64Encrypted;

@end
