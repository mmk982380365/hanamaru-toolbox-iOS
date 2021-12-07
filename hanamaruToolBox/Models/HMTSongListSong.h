//
//  HMTSongListSong.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMTSongListSong : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *timestamp;
@property (assign, nonatomic) BOOL isMedley;
@property (assign, nonatomic) BOOL isMedleyTitle;

@end

NS_ASSUME_NONNULL_END
