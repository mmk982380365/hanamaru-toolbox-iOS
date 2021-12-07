//
//  HMTSilderViewCell.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMTSilderViewCell : UITableViewCell

@property (assign, nonatomic) BOOL cellSelected;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

NS_ASSUME_NONNULL_END
