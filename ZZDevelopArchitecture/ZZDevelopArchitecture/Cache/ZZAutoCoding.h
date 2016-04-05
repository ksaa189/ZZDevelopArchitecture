//
//  ZZAutoCoding.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/10/29.
//  Copyright © 2015年 ZZ. All rights reserved.
//

#import "ZZDevelopPreDefine.h"
#pragma mark -

@interface ZZAutoCoding : NSObject

@end

#pragma mark- category AutoCoding
// copy frome https://github.com/nicklockwood/AutoCoding
// 序列化 2.2
//因为如果使用model做存储，需要把model中的属性做coding，这个就是能够自动进行coding
@interface NSObject (AutoCoding) <NSSecureCoding>

//coding

+ (NSDictionary *)codableProperties;
- (void)setWithCoder:(NSCoder *)aDecoder;

//property access

- (NSDictionary *)codableProperties;
- (NSDictionary *)dictionaryRepresentation;

//loading / saving
+ (instancetype)objectWithContentsOfFile:(NSString *)path;
- (BOOL)writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile;

@end
