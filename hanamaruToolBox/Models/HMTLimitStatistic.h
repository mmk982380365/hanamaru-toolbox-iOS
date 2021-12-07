//
//  HMTLimitStatistic.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/7.
//

#import <Foundation/Foundation.h>

#import "HMTSongStatistic.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMTLimitStatistic : NSObject

@property (strong, nonatomic) NSArray<HMTSongStatistic *> *youtube;
@property (strong, nonatomic) NSArray<HMTSongStatistic *> *bilibili;
@property (strong, nonatomic) NSArray<HMTSongStatistic *> *both;

@end

NS_ASSUME_NONNULL_END
