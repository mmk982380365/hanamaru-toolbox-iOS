//
//  HMTColorThemes.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define HMT_ColorFromRGB(rgbValue) HMT_ColorFromRGBAlpha((rgbValue), 1.0)

#define HMT_ColorFromRGBAlpha(rgbValue,a) ({UIColor *_color = nil;if (@available(iOS 10.0, *)) {_color = [UIColor colorWithDisplayP3Red:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)];} else {_color = [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)];}_color;})


@interface HMTColorThemes : NSObject

+ (UIColor *)colorWithDarkStyle:(UIColor *)darkColor whiteStyle:(UIColor *)whiteColor;

/// 主色调
+ (UIColor *)primaryColor;

/// 背景色
+ (UIColor *)backgroundColor;

/// 直播通知字体颜色
+ (UIColor *)liveHintTextColor;

/// 默认字体色
+ (UIColor *)textColor;

/// 默认灰色字体色
+ (UIColor *)textGrayColor;

/// tableView背景色
+ (UIColor *)tableDarkColor;

/// 油管主题色
+ (UIColor *)youtubeColor;

/// b站主题色
+ (UIColor *)bilibiliColor;

@end

NS_ASSUME_NONNULL_END
