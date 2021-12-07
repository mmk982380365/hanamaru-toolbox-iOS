//
//  HMTHomepageSiteLinkCell.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HMTHomepageSiteLinkCellDelegate <NSObject>

- (void)onClickTwitter;

- (void)onClickYoutube;

- (void)onClickBilibili;

- (void)onClickFanbox;

@end

@interface HMTHomepageSiteLinkCell : UITableViewCell

@property (weak, nonatomic) id<HMTHomepageSiteLinkCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
