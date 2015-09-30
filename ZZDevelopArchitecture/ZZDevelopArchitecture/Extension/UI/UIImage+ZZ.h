//
//  UIImage+ZZ.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/31.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>

#define ZZ_USE_SYSTEM_IMAGE_CACHE NO
/**************************************************************/
// UIImage

@interface UIImage (ZZ)

// 加载图片

// used: imageWithContentsOfFile 自动带有2x 3x等后缀
// 能够根据屏幕自动寻找2x 3x的图片
+ (UIImage *)imageWithFileName:(NSString *)name;

// todo
// 加载图片,自己控制释放用缓存
//+ (UIImage *)imageNamed:(NSString *)name useCache:(BOOL)useCache;

// 貌似是创建位图的 ，没太看懂,给其他函数使用
- (UIImage *)transprent;

// 圆形
- (UIImage *)rounded;
// 变成 尺寸circleRect的圆形
- (UIImage *)rounded:(CGRect)circleRect;

// 拉伸
- (UIImage *)stretched;
- (UIImage *)stretched:(UIEdgeInsets)capInsets;

// 灰度
- (UIImage *)grayscale;

// 旋转
- (UIImage *)rotate:(CGFloat)angle;
- (UIImage *)rotateCW90;
- (UIImage *)rotateCW180;
- (UIImage *)rotateCW270;

//等比例缩放
- (UIImage*)scaleToSize:(CGSize)size;

// 创建并返回使用指定的图像中的颜色对象。
- (UIColor *)patternColor;

// 截取部分图像
- (UIImage *)crop:(CGRect)rect;
// 截取部分图像
- (UIImage *)imageInRect:(CGRect)rect;

/** 从string返回图片
 * path:图片路径, stretched:拉伸
 * 文件名特殊修饰可加特殊修饰: @"image.png round"
 * stretch:拉伸, round:圆形, gray:灰度
 */
+ (UIImage *)imageFromString:(NSString *)name;
+ (UIImage *)imageFromString:(NSString *)name atPath:(NSString *)path;
+ (UIImage *)imageFromString:(NSString *)name stretched:(UIEdgeInsets)capInsets;
// 从视频截取图片
+ (UIImage *)imageFromVideo:(NSURL *)videoURL atTime:(CMTime)time scale:(CGFloat)scale;


// 叠加合并
+ (UIImage *)merge:(NSArray *)images;
// 叠加合并
- (UIImage *)merge:(UIImage *)image;


// 圆角
typedef enum {
    UIImageRoundedCornerTopLeft = 1,
    UIImageRoundedCornerTopRight = 1 << 1,
    UIImageRoundedCornerBottomRight = 1 << 2,
    UIImageRoundedCornerBottomLeft = 1 << 3
} UIImageRoundedCorner;
//得到一个 randius弧度的圆角图片
- (UIImage *)roundedRectWith:(float)radius;
// 可以得到 不同部位的圆角图片
- (UIImage *)roundedRectWith:(float)radius cornerMask:(UIImageRoundedCorner)cornerMask;

#pragma mark - 待完善
- (void)saveAsPngWithPath:(NSString *)path;
// compression is 0(most)..1(least)
- (void)saveAsJpgWithPath:(NSString *)path compressionQuality:(CGFloat)quality;
- (void)saveAsPhotoWithPath:(NSString *)path;

// 高斯模糊
- (UIImage*)stackBlur:(NSUInteger)radius;

// 修复方向
- (UIImage *)fixOrientation;

// 改变图片颜色, Gradient带灰度
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;

@end
