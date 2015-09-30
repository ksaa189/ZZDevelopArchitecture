//
//  UITable.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/4.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (ZZ)

// 子类需要重新此方法
+ (CGFloat)heightForRowWithData:(id)aData;

- (void)layoutSubviewsWithDic:(NSMutableDictionary *)dic;

@end

@interface UITableView (XY)

- (void)reloadData:(BOOL)animated;

@end
