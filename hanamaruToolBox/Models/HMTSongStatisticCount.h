//
//  HMTSongStatisticCount.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMTSongStatisticCount : NSObject

@property (copy, nonatomic) NSString *live_id;

@property (copy, nonatomic) NSString *timestamp;

@property (copy, nonatomic) NSString *date;

@property (copy, nonatomic) NSString *platform;

@end

NS_ASSUME_NONNULL_END
