//
//  HMTSingleSongCell.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import <UIKit/UIKit.h>

#import "HMTSingle.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HMTSingleSongCellDelegate <NSObject>

- (void)onClickYoutube:(HMTSingle *)single;

- (void)onClickBilibili:(HMTSingle *)single;

@end

@interface HMTSingleSongCell : UICollectionViewCell

@property (weak, nonatomic) id<HMTSingleSongCellDelegate> delegate;

@property (strong, nonatomic) HMTSingle *single;

@end

NS_ASSUME_NONNULL_END
