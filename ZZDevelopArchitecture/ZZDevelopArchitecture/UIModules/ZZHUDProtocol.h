//
//  ZZHUDProtocol.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/7.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#ifndef ZZDevelopArchitecture_ZZHUDProtocol_h
#define ZZDevelopArchitecture_ZZHUDProtocol_h

#import <Foundation/Foundation.h>

@protocol ZZHUDProtocol <NSObject>

@optional
- (void)showErrorViewWithParameter:(id)param;
- (void)closeErrorView;

- (void)showZeroDataViewWithParameter:(id)param;
- (void)closeZeroDataView;

- (void)showLoadingDataViewWithParameter:(id)param;
- (void)closeLoadingDataView;

@end


#endif
