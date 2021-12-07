//
//  HMTHomepageVideoCell.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import <UIKit/UIKit.h>

#import "HMTVideo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HMTHomepageVideoCellDelegate <NSObject>

- (void)onClickVideoList:(HMTVideo *)video;

@end

@interface HMTHomepageVideoCell : UITableViewCell

@property (weak, nonatomic) id<HMTHomepageVideoCellDelegate> delegate;

@property (strong, nonatomic) HMTVideo *video;

@end

NS_ASSUME_NONNULL_END
