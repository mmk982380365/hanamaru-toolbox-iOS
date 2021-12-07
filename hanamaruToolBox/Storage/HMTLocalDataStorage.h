//
//  HMTLocalDataStorage.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import <Foundation/Foundation.h>

#import "HMTForecast.h"
#import "HMTSingle.h"
#import "HMTSlide.h"
#import "HMTSongList.h"
#import "HMTVideo.h"
#import "HMTSongStatistic.h"
#import "HMTLimitStatistic.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSNotificationName HMTDidFinishFetchDataBotification;

@interface HMTLocalDataStorage : NSObject

+ (instancetype)sharedStorage;

@property (strong, nonatomic) NSArray<HMTForecast *> *forecastList;
@property (strong, nonatomic) NSArray<HMTSingle *> *singleList;
@property (strong, nonatomic) NSArray<HMTSlide *> *slideList;
@property (strong, nonatomic) NSArray<HMTSongList *> *songList;
@property (strong, nonatomic) NSArray<HMTVideo *> *videoList;

@property (strong, nonatomic) NSDictionary<NSString *, NSMutableArray<HMTForecast *> *> *mappedForecastList;

@property (strong, nonatomic) NSArray<HMTSongStatistic *> *mappedSongStatistic;
@property (strong, nonatomic) NSArray<HMTSongStatistic *> *mappedMedleyStatistic;
@property (strong, nonatomic) NSArray<HMTSongStatistic *> *mappedAllStatistic;
@property (strong, nonatomic) NSDictionary *calendarStatistic;

@property (strong, nonatomic) HMTLimitStatistic *songLimited;
@property (strong, nonatomic) HMTLimitStatistic *medleyLimited;

- (void)loadData:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
