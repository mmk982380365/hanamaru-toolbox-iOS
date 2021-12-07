//
//  HMTSongDetailCell.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/6.
//

#import <UIKit/UIKit.h>

#import "HMTSongStatisticCount.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HMTSongDetailCellDelegate <NSObject>

- (void)onClickSongList:(HMTSongStatisticCount *)statistic;

@end

@interface HMTSongDetailCell : UITableViewCell

@property (weak, nonatomic) id<HMTSongDetailCellDelegate> delegate;

@property (strong, nonatomic) HMTSongStatisticCount *statistic;

@end

NS_ASSUME_NONNULL_END
