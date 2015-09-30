//
//  LKDBHelper+ZZ.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/26.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#define XY_LKDBHelper_loadCount 20

#import "LKDBHelper.h"

@interface NSObject(XY_LKDBHelper)

- (void)loadFromDB;

+ (NSString *)primaryKeyAndDESC;

@end

@interface NSArray(XY_LKDBHelper)

- (void)saveAllToDB;
+ (id)loadFromDBWithClass:(Class)modelClass;

@end

