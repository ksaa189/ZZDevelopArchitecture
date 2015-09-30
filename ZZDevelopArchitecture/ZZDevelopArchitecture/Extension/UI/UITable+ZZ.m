//
//  UITable.m
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/4.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "UITable+ZZ.h"

@implementation UITableViewCell (ZZ)

+ (CGFloat)heightForRowWithData:(id)aData
{
    if (aData == nil)
    {
        return -1;
    }
    
    return 44;
}

- (void)layoutSubviewsWithDic:(NSMutableDictionary *)dic
{
    
}

@end


@implementation UITableView (XY)

- (void)reloadData:(BOOL)animated
{
    [self reloadData];
    
    if (animated)
    {
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionReveal];
        [animation setSubtype:kCATransitionFromBottom];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setFillMode:kCAFillModeBoth];
        [animation setDuration:.3];
        [[self layer] addAnimation:animation forKey:@"UITableViewReloadDataAnimationKey"];
    }
}

@end