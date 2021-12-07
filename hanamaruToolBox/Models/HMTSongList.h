//
//  HMTSongList.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import <Foundation/Foundation.h>

#import "HMTSongListSong.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMTSongList : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *url_y;
@property (copy, nonatomic) NSString *url_b;
@property (copy, nonatomic) NSString *date;
@property (strong, nonatomic) NSArray<NSString *> *songs;
@property (strong, nonatomic) NSArray<NSString *> *timestamps;
@property (strong, nonatomic) NSDate *realDate;

@property (strong, nonatomic) NSArray<HMTSongListSong *> *songs_list;

@end

NS_ASSUME_NONNULL_END
