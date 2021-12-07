//
//  HMTSongList.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import "HMTSongList.h"

#import <MJExtension/MJExtension.h>

@implementation HMTSongList

- (void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues {
    NSDateFormatter *dtfm1 = [[NSDateFormatter alloc] init];
    dtfm1.dateFormat = @"yyyy/MM/dd";
    NSDate *date = [dtfm1 dateFromString:self.date];
    NSDateFormatter *dtfm2 = [[NSDateFormatter alloc] init];
    dtfm2.dateFormat = @"yyyy-MM-dd";
    self.date = [dtfm2 stringFromDate:date];
}

@end
