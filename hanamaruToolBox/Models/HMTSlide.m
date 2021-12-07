//
//  HMTSlide.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import "HMTSlide.h"

#import <MJExtension/MJExtension.h>

@implementation HMTSlide

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"bilibili_url": @"bilibili-url",
        @"youtube_url": @"youtube-url",
    };
}

@end
