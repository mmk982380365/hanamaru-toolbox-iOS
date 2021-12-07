//
//  HMTSongStatistic.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/5.
//

#import "HMTSongStatistic.h"

#import <MJExtension/MJExtension.h>

@implementation HMTSongStatistic

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"b_count": @"HMTSongStatisticCount",
        @"y_count": @"HMTSongStatisticCount"
    };
}

- (void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues {
    self.b_count_num = self.b_count.count;
    self.y_count_num = self.y_count.count;
}

@end
