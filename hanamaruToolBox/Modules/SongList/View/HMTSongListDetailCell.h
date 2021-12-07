//
//  HMTSongListDetailCell.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HMTSongListDetailCellDelegate <NSObject>

- (void)onClickDetail:(NSIndexPath *)indexPath;

@end

@interface HMTSongListDetailCell : UITableViewCell

@property (weak, nonatomic) id<HMTSongListDetailCellDelegate> delegate;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)flash;

@end

NS_ASSUME_NONNULL_END
