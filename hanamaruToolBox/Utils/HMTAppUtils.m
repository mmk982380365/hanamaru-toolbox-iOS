//
//  HMTAppUtils.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import "HMTAppUtils.h"

@implementation HMTAppUtils

+ (UIViewController *)launchViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:[[NSBundle mainBundle] infoDictionary][@"UILaunchStoryboardName"] bundle:nil];
    UIViewController *vc = [sb instantiateInitialViewController];
    return vc;
}

+ (NSString *)getCurrentLanguage {
    NSArray *languages = [NSLocale preferredLanguages];
    if (languages.count > 0) {
        for (NSString *language in languages) {
            if ([language hasPrefix:@"zh"]) {
                return @"zh";
            } else if ([language hasPrefix:@"en"]) {
                return @"en";
            } else if ([language hasPrefix:@"ja"]) {
                return @"ja";
            }
        }
    }
    
    return @"zh";
}

@end
