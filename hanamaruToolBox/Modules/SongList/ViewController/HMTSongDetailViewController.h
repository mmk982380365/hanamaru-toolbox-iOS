//
//  HMTSongDetailViewController.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/6.
//

#import "HMTViewController.h"
#import "HMTSongStatistic.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSNotificationName const HMTSongDetailViewControllerShowSongList;

@interface HMTSongDetailViewController : HMTViewController

@property (strong, nonatomic) HMTSongStatistic *songStatistic;

@end

NS_ASSUME_NONNULL_END
