//
//  HMTSingle.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import "HMTSingle.h"
#import "HMTHTTPService.h"

#import <MJExtension/MJExtension.h>

@implementation HMTSingle

- (void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues {
    if (self.img.length > 0 && ![self.img hasPrefix:@"http"]) {
        NSURLComponents *components = [NSURLComponents componentsWithString:kBaseURL];
        if (components.path) {
            components.path = [components.path stringByAppendingPathComponent:self.img];
        } else {
            components.path = self.img;
        }
        self.img = components.string;
    }
}

@end
