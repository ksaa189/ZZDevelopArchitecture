//
//  ZZRequestHelper.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/26.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "MKNetworkKit.h"

//////////////////        MKNetworkOperation (XY)        ////////////////////
typedef MKNetworkOperation HttpRequest;
typedef void(^RequestHelper_normalRequestSucceedBlock)(HttpRequest *op);
typedef void(^RequestHelper_normalRequestFailedBlock)(HttpRequest *op, NSError* err);

typedef void(^RequestHelper_downloadRequestSucceedBlock)(HttpRequest *op);
typedef void(^RequestHelper_downloadRequestFailedBlock)(HttpRequest *op, NSError* err);
typedef void(^RequestHelper_downloadRequestProgressBlock)(double progress);

@interface RequestHelper : MKNetworkEngine

typedef enum {
    requestHelper_get = 1,
    requestHelper_post,
    requestHelper_put,
    requestHelper_del,
} HTTPMethod;

@property (nonatomic, assign) BOOL freezable;
@property (nonatomic, assign) BOOL forceReload;
//
+ (id)defaultSettings;

- (HttpRequest *)get:(NSString *)path;
- (HttpRequest *)get:(NSString *)path
              params:(id)anObject;

- (HttpRequest *)post:(NSString *)path
               params:(id)anObject;

- (HttpRequest *)request:(NSString *)path
                  params:(id)anObject
                  method:(HTTPMethod)httpMethod;
// cancel
- (void)cancelRequestWithString:(NSString*)string;

- (id)submit:(HttpRequest *)op;

//////////////////        Image        ////////////////////
#pragma mark- Image
// 设置图片缓存引擎
#define XY_setupWebImageEngine [UIImageView setDefaultEngine:[RequestHelper webImageEngine]];
+ (id)webImageEngine;

// 子类需要重新写, 暂时废弃
//+(NSString *) generateAccessTokenWithObject:(id)anObject;
@end

#pragma mark -  MKNetworkOperation (XY)
@interface MKNetworkOperation (XY)
//上传文件
- (id)uploadFiles:(NSDictionary *)name_path;
//请求成功或者失败的回调
- (id)succeed:(RequestHelper_normalRequestSucceedBlock)blockS
       failed:(RequestHelper_normalRequestFailedBlock)blockF;
//把请求添加到队列中
- (id)submitInQueue:(RequestHelper *)requests;
@end

#pragma mark - download
@class DownloadHelper;
@class Downloader;

@interface Downloader : HttpRequest

@property (nonatomic, copy) NSString *toFile;
//把请求添加到队列中
- (id)submitInQueue:(DownloadHelper *)requests;
- (id)progress:(RequestHelper_downloadRequestProgressBlock)blockP;

// 请重载此方法实现自己的通用解析方法
- (id)succeed:(RequestHelper_downloadRequestSucceedBlock)blockS
       failed:(RequestHelper_downloadRequestFailedBlock)blockF;
@end

@interface DownloadHelper : MKNetworkEngine
+ (id)defaultSettings;      // 参考

// 下载前,请先执行此方法;
- (void)setup;

- (Downloader *)download:(NSString *)remoteURL
                      to:(NSString*)filePath
                  params:(id)anObject
        breakpointResume:(BOOL)isResume;
//取消所有下载
- (void)cancelAllDownloads;
- (void)cancelDownloadWithString:(NSString *)string;

- (NSArray *)allDownloads;
- (Downloader *)getADownloadWithString:(NSString *)string;

- (void)emptyTempFile;

- (id)submit:(Downloader *)op;

#pragma mark- todo ,数量控制
// 定义队列最大并发数量, 默认为wifi下 6, 2g/3g下 2
//@property (nonatomic, assign) int maxOperationCount;
@end

