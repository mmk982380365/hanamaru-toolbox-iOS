//
//  HMTHomepageBannerCell.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import <UIKit/UIKit.h>

#import "HMTLocalDataStorage.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HMTHomepageBannerCellDelegate <NSObject>

- (void)didClickBanner:(HMTSlide *)slide;

@end

@interface HMTHomepageBannerCell : UITableViewCell

@property (weak, nonatomic) id<HMTHomepageBannerCellDelegate> delegate;

@property (strong, nonatomic) NSArray<HMTSlide *> *slides;

@end

NS_ASSUME_NONNULL_END
