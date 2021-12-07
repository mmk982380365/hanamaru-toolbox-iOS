//
//  HMTSongDetailHeaderView.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMTSongDetailHeaderView : UITableViewHeaderFooterView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *valueLabel;

@property (strong, nonatomic) UIColor *headerBackgroundColor;

@end

NS_ASSUME_NONNULL_END
