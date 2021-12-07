//
//  HMTSilderViewCell.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import "HMTSilderViewCell.h"

@interface HMTSilderViewCell ()

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation HMTSilderViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Setter

- (void)setCellSelected:(BOOL)cellSelected {
    if (_cellSelected != cellSelected) {
        _cellSelected = cellSelected;
    }
    self.lineView.hidden = !cellSelected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
