//
//  HMTVideo.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import <Foundation/Foundation.h>

#import "HMTSongList.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMTVideo : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *url_b;
@property (copy, nonatomic) NSString *url_y;
@property (copy, nonatomic) NSString *date;

@property (strong, nonatomic) HMTSongList *songList;

@end

NS_ASSUME_NONNULL_END
