//
//  HMTColorThemes.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import "HMTColorThemes.h"

@implementation HMTColorThemes

+ (UIColor *)colorWithDarkStyle:(UIColor *)darkColor whiteStyle:(UIColor *)whiteColor {
    #ifdef __IPHONE_13_0
        if (@available(iOS 13, *)) {
            return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                return traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? darkColor : whiteColor;
            }];
        } else {
            return whiteColor;
        }
    #else
        return whiteColor;
    #endif
}

+ (UIColor *)primaryColor {
    return [UIColor colorNamed:@"primaryColor"];
}

+ (UIColor *)backgroundColor {
    return [UIColor colorNamed:@"backgroundColor"];
}

+ (UIColor *)liveHintTextColor {
    return [UIColor colorNamed:@"liveHintTextColor"];
}

+ (UIColor *)textColor {
    return [UIColor colorNamed:@"textColor"];
}

+ (UIColor *)textGrayColor {
    return [UIColor colorNamed:@"textGrayColor"];
}

+ (UIColor *)tableDarkColor {
    return [UIColor colorNamed:@"tableDarkColor"];
}

+ (UIColor *)youtubeColor {
    return [UIColor colorNamed:@"youtubeColor"];
}

+ (UIColor *)bilibiliColor {
    return [UIColor colorNamed:@"bilibiliColor"];
}

@end
