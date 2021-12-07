//
//  HMTSongStatistic.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/5.
//

#import <Foundation/Foundation.h>

#import "HMTSongStatisticCount.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMTSongStatistic : NSObject

@property (strong, nonatomic) HMTSongStatisticCount *last_live;

@property (strong, nonatomic) NSArray<HMTSongStatisticCount *> *b_count;

@property (assign, nonatomic) NSInteger b_count_num;

@property (strong, nonatomic) NSArray<HMTSongStatisticCount *> *y_count;

@property (assign, nonatomic) NSInteger y_count_num;

@property (copy, nonatomic) NSString *name;

@property (assign, nonatomic) NSInteger count;

@end

NS_ASSUME_NONNULL_END
