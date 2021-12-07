//
//  HMTLocalDataStorage.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import "HMTLocalDataStorage.h"
#import "HMTHTTPService.h"
#import "NSArray+HMT_Reverse.h"
#import "HMTSongEntity.h"

#import <MJExtension/MJExtension.h>

NSNotificationName HMTDidFinishFetchDataBotification = @"HMTDidFinishFetchDataBotification";

@interface HMTLocalDataStorage ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation HMTLocalDataStorage

+ (instancetype)sharedStorage {
    static HMTLocalDataStorage *storage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storage = [[HMTLocalDataStorage alloc] init];
    });
    return storage;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return self;
}

- (void)loadData:(void (^)(void))block {
    dispatch_group_t group = dispatch_group_create();
    
    NSMutableArray<HMTForecast *> *forecasts = [NSMutableArray array];
    NSMutableArray<HMTSingle *> *singles = [NSMutableArray array];
    NSMutableArray<HMTSongList *> *songList = [NSMutableArray array];
    NSMutableArray<HMTVideo *> *videos = [NSMutableArray array];
    NSMutableArray<HMTSlide *> *slides = [NSMutableArray array];
    
    // forecast
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t flag = dispatch_semaphore_create(0);
        [[HMTHTTPService sharedService] getForecastSuccess:^(NSArray * _Nonnull responseObject) {
            
            NSArray *array = [HMTForecast mj_objectArrayWithKeyValuesArray:responseObject];
            [forecasts addObjectsFromArray:array];
            
            
            dispatch_semaphore_signal(flag);
        } failure:^(NSError * _Nonnull error) {
            dispatch_semaphore_signal(flag);
        }];
        dispatch_semaphore_wait(flag, DISPATCH_TIME_FOREVER);
    });
    
    // single
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t flag = dispatch_semaphore_create(0);
        [[HMTHTTPService sharedService] getSingleSuccess:^(NSArray * _Nonnull responseObject) {
            NSArray *array = [HMTSingle mj_objectArrayWithKeyValuesArray:responseObject];
            [singles addObjectsFromArray:array];
            dispatch_semaphore_signal(flag);
        } failure:^(NSError * _Nonnull error) {
            dispatch_semaphore_signal(flag);
        }];
        dispatch_semaphore_wait(flag, DISPATCH_TIME_FOREVER);
    });
    
    // songList
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t flag = dispatch_semaphore_create(0);
        [[HMTHTTPService sharedService] getSongListSuccess:^(NSArray * _Nonnull responseObject) {
            NSArray *array = [HMTSongList mj_objectArrayWithKeyValuesArray:responseObject];
            [songList addObjectsFromArray:array];
            dispatch_semaphore_signal(flag);
        } failure:^(NSError * _Nonnull error) {
            dispatch_semaphore_signal(flag);
        }];
        dispatch_semaphore_wait(flag, DISPATCH_TIME_FOREVER);
    });
    
    // videos
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t flag = dispatch_semaphore_create(0);
        [[HMTHTTPService sharedService] getVideosSuccess:^(NSArray * _Nonnull responseObject) {
            for (NSArray *info in responseObject) {
                HMTVideo *video = [[HMTVideo alloc] init];
                video.type = info[0];
                video.title = info[1];
                video.url_y = info[2];
                video.url_b = info[3];
                video.date = info[4];
                [videos addObject:video];
            }
            dispatch_semaphore_signal(flag);
        } failure:^(NSError * _Nonnull error) {
            dispatch_semaphore_signal(flag);
        }];
        dispatch_semaphore_wait(flag, DISPATCH_TIME_FOREVER);
    });
    
    // slides
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t flag = dispatch_semaphore_create(0);
        [[HMTHTTPService sharedService] getSlidesSuccess:^(NSArray * _Nonnull responseObject) {
            NSArray *array = [HMTSlide mj_objectArrayWithKeyValuesArray:responseObject];
            [slides addObjectsFromArray:array];
            dispatch_semaphore_signal(flag);
        } failure:^(NSError * _Nonnull error) {
            dispatch_semaphore_signal(flag);
        }];
        dispatch_semaphore_wait(flag, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [HMTSongEntity runTransaction:^BOOL{
            return [HMTSongEntity createDatabase];
        }];
        
        for (HMTSlide *slide in slides) {
            if ([@"$#last_live" isEqualToString:slide.title]) {
                HMTVideo *video = [self getNotSongDataWithVideos:videos songList:songList];
                slide.bilibili_url = video.url_b;
                slide.youtube_url = video.url_y;
                slide.title = video.title;
                slide.img = [kBaseURL stringByAppendingString:@"asserts/slides/last_live.jpg"];
            } else if ([@"$#last_song_live" isEqualToString:slide.title]) {
                HMTVideo *video = [self getSongDataWithVideos:videos songList:songList];
                slide.bilibili_url = video.url_b;
                slide.youtube_url = video.url_y;
                slide.title = video.title;
                slide.img = [kBaseURL stringByAppendingString:@"asserts/slides/last_song_live.jpg"];
            }
            if (slide.img.length > 0 && ![slide.img hasPrefix:@"http"]) {
                NSURLComponents *components = [NSURLComponents componentsWithString:kBaseURL];
                if (components.path) {
                    components.path = [components.path stringByAppendingPathComponent:slide.img];
                } else {
                    components.path = slide.img;
                }
                slide.img = components.string;
            }
        }
        
        // produce song list
        
        for (HMTSongList *song in songList) {
            for (HMTVideo *video in videos) {
                if ([video.date isEqualToString:song.date]) {
                    video.songList = song;
                    break;
                }
            }
        }
        
        self.forecastList = forecasts;
        self.singleList = singles.reversedArray;
        self.songList = songList;
        self.videoList = videos;
        self.slideList = slides;
        
        NSMutableDictionary *mappedForecastList = [NSMutableDictionary dictionary];
        for (HMTForecast *forecast in forecasts) {
            NSString *key = forecast.date;
            NSMutableArray *array = nil;
            if (mappedForecastList[key]) {
                array = mappedForecastList[key];
            } else {
                array = [NSMutableArray arrayWithCapacity:0];
                mappedForecastList[key] = array;
            }
            [array addObject:forecast];
        }
        self.mappedForecastList = mappedForecastList;
        
        [self processSongList];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:HMTDidFinishFetchDataBotification object:nil];
        !block ?: block();
    });
}

- (void)countSong:(NSMutableDictionary *)song_statistic songName:(NSString *)song_name isYoutube:(BOOL)is_y liveId:(int)live_id timestamp:(NSString *)timestamp date:(NSString *)date {
    NSMutableDictionary *song_info = nil;
    if ([song_statistic.allKeys containsObject:song_name]) {
        song_info = song_statistic[song_name];
        song_info[@"count"] = @([song_info[@"count"] integerValue] + 1);
    } else {
        song_info = [NSMutableDictionary dictionary];
        song_info[@"count"] = @1;
        song_info[@"y_count"] = [NSMutableArray array];
        song_info[@"b_count"] = [NSMutableArray array];
        song_info[@"last_live"] = @{
            @"live_id": @(live_id),
            @"timestamp": timestamp,
            @"platform": is_y ? @"y" : @"b",
            @"date": date
        };
    }
    if (is_y) {
        NSMutableArray *array = song_info[@"y_count"];
        [array addObject:@{
            @"live_id": @(live_id),
            @"timestamp": timestamp,
            @"platform": @"y",
            @"date": date
        }];
    } else {
        NSMutableArray *array = song_info[@"b_count"];
        [array addObject:@{
            @"live_id": @(live_id),
            @"timestamp": timestamp,
            @"platform": @"b",
            @"date": date
        }];
    }
    song_statistic[song_name] = song_info;
}

- (NSArray *)convertAnalyticsToRecords:(NSDictionary *)statistic_record {
    NSArray *song_names = statistic_record.allKeys;
    song_names = [song_names sortedArrayUsingDescriptors:@[
        [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES]
    ]];
    NSMutableArray *song_records = [NSMutableArray array];
    for (NSString *key in song_names) {
        NSMutableDictionary *record = [statistic_record[key] mutableCopy];
        record[@"name"] = key;
        [song_records addObject:record];
    }
    
    return song_records;
}

- (void)processSongList {
    clock_t begin = clock();
    [HMTSongEntity runTransaction:^BOOL{
        return [HMTSongEntity deleteAllObjects];
    }];
    NSMutableArray *data = [NSMutableArray array];
    NSInteger index = 0;
    
    NSMutableDictionary *calendar = [NSMutableDictionary dictionary];
    
    for (HMTSongList *live_data in self.songList) {
        live_data.realDate = [self.dateFormatter dateFromString:live_data.date];
        BOOL is_youtube = live_data.url_y.length > 0;
        NSArray *songs = live_data.songs;
        NSArray *song_timestamp = live_data.timestamps ?: @[];
        
        BOOL last_medley = NO;
        
        NSMutableArray<HMTSongListSong *> *songDetailList = [NSMutableArray array];
        
        for (NSString *song in songs) {
            
            
            HMTSongEntity *entity = [[HMTSongEntity alloc] init];
            entity.iid = index;
            entity.isAutoIncrement = YES;
            entity.title = [song stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            entity.date = live_data.date;
            entity.url_b = live_data.url_b;
            entity.url_y = live_data.url_y;
            entity.platform = is_youtube ? @"y" : @"b";
            
            NSString *song_pos = song_timestamp.count > 0 ? song_timestamp[[songs indexOfObject:song]] : nil;
            
            entity.timestamp = song_pos;
            
            HMTSongListSong *listSong = [[HMTSongListSong alloc] init];
            listSong.name = song;
            listSong.timestamp = song_pos;
            
            if ([song hasPrefix:@"\t"]) {
                if (!last_medley) {
                    songDetailList.lastObject.isMedleyTitle = YES;
                    [data removeLastObject];
                }
                listSong.isMedley = YES;
                entity.isMedleySong = YES;
                last_medley = YES;
            } else {
                last_medley = NO;
            }
            [songDetailList addObject:listSong];
            [data addObject:entity];
            index++;
        }
        live_data.songs_list = songDetailList;
        
        
        NSInteger i = [self.songList indexOfObject:live_data];
        NSInteger live_year = 0;
        NSCalendar *calendarTool = [NSCalendar currentCalendar];
        [calendarTool getEra:nil year:&live_year month:nil day:nil fromDate:live_data.realDate];
        if ([calendar.allKeys containsObject:@(live_year)]) {
            NSMutableArray *array = calendar[@(live_year)];
            [array addObject:@[
                live_data,
                @(i)
            ]];
        } else {
            NSMutableArray *array = [NSMutableArray arrayWithObject:@[
                live_data,
                @(i)
            ]];
            calendar[@(live_year)] = array;
        }
    }
    
    [HMTSongEntity runTransaction:^BOOL{
        return [HMTSongEntity saveObjects:data];
    }];
    
    clock_t duration = clock() - begin;
    
    NSLog(@"%f", (double)duration / CLOCKS_PER_SEC);
    
    NSMutableDictionary *song_statistic = [NSMutableDictionary dictionary];
    NSMutableDictionary *medley_statistic = [NSMutableDictionary dictionary];
    NSMutableDictionary *all_statistic = [NSMutableDictionary dictionary];
    NSArray *songsNormal = [HMTSongEntity objectsWhereIsMedley:NO];
    NSArray *songsMedley = [HMTSongEntity objectsWhereIsMedley:YES];
    NSArray *songsAll = [HMTSongEntity allObjects];
    
    duration = clock() - begin;
    
    NSLog(@"%f", (double)duration / CLOCKS_PER_SEC);
    
    for (HMTSongEntity *entity in songsNormal) {
        [self countSong:song_statistic songName:entity.title isYoutube:[@"y" isEqualToString:entity.platform] liveId:(int)entity.iid timestamp:entity.timestamp date:entity.date];
    }
    
    for (HMTSongEntity *entity in songsMedley) {
        [self countSong:medley_statistic songName:entity.title isYoutube:[@"y" isEqualToString:entity.platform] liveId:(int)entity.iid timestamp:entity.timestamp date:entity.date];
    }
    
    for (HMTSongEntity *entity in songsAll) {
        [self countSong:all_statistic songName:entity.title isYoutube:[@"y" isEqualToString:entity.platform] liveId:(int)entity.iid timestamp:entity.timestamp date:entity.date];
    }
    
    
    
    self.calendarStatistic = calendar;
    self.mappedSongStatistic = [HMTSongStatistic mj_objectArrayWithKeyValuesArray:[self convertAnalyticsToRecords:song_statistic]];
    self.mappedMedleyStatistic = [HMTSongStatistic mj_objectArrayWithKeyValuesArray:[self convertAnalyticsToRecords:medley_statistic]];
    self.mappedAllStatistic = [HMTSongStatistic mj_objectArrayWithKeyValuesArray:[self convertAnalyticsToRecords:all_statistic]];
    
    
    self.songLimited = [self getLimitedSongs:self.mappedSongStatistic];
    self.medleyLimited = [self getLimitedSongs:self.mappedMedleyStatistic];
}

- (HMTLimitStatistic *)getLimitedSongs:(NSArray<HMTSongStatistic *> *)song_statistics {
    
    NSMutableArray *limited_youtube = [NSMutableArray array];
    NSMutableArray *limited_bilibili = [NSMutableArray array];
    NSMutableArray *not_limited = [NSMutableArray array];
    
    for (HMTSongStatistic *song_info in song_statistics) {
        if (song_info.b_count.count == 0) {
            [limited_youtube addObject:song_info];
        } else if (song_info.y_count.count == 0) {
            [limited_bilibili addObject:song_info];
        } else {
            [not_limited addObject:song_info];
        }
    }
    
    HMTLimitStatistic *statistic = [[HMTLimitStatistic alloc] init];
    statistic.youtube = limited_youtube;
    statistic.bilibili = limited_bilibili;
    statistic.both = not_limited;
    return statistic;
}

- (HMTVideo *)getNotSongDataWithVideos:(NSArray<HMTVideo *> *)videos songList:(NSArray<HMTSongList *> *)songList {
    NSMutableSet *setVideo = [NSMutableSet setWithArray:[videos valueForKeyPath:@"date"]];
    NSMutableSet *nextVideo = [setVideo mutableCopy];
    NSMutableSet *setSongList = [NSMutableSet setWithArray:[songList valueForKeyPath:@"date"]];
    [setVideo intersectSet:setSongList];
    [nextVideo minusSet:setVideo];
    NSArray *array = [[nextVideo allObjects] sortedArrayUsingComparator:^NSComparisonResult(NSString   * _Nonnull obj1, NSString * _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSString *date = array.lastObject;
    
    HMTVideo *videoData = nil;
    
    for (HMTVideo *video in videos) {
        if ([date isEqualToString:video.date]) {
            videoData = video;
            break;
        }
    }
    return videoData;
}

- (HMTVideo *)getSongDataWithVideos:(NSArray<HMTVideo *> *)videos songList:(NSArray<HMTSongList *> *)songList {
    NSMutableSet *setVideo = [NSMutableSet setWithArray:[videos valueForKeyPath:@"date"]];
    NSSet *setSongList = [NSSet setWithArray:[songList valueForKeyPath:@"date"]];
    [setVideo intersectSet:setSongList];
    NSArray *array = [[setVideo allObjects] sortedArrayUsingComparator:^NSComparisonResult(NSString   * _Nonnull obj1, NSString * _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSString *date = array.lastObject;
    
    HMTVideo *videoData = nil;
    
    for (HMTVideo *video in videos) {
        if ([date isEqualToString:video.date]) {
            videoData = video;
            break;
        }
    }
    return videoData;
}

@end
