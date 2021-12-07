//
//  HMTSongListDetailCell.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/5.
//

#import "HMTSongListDetailCell.h"
#import "HMTColorThemes.h"

@implementation HMTSongListDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)flash {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    [self.contentView insertSubview:view atIndex:0];
    
    view.backgroundColor = [HMTColorThemes primaryColor];
    [UIView animateWithDuration:1 animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

#pragma mark - Event

- (IBAction)onClickPreview:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickDetail:)]) {
        [self.delegate onClickDetail:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
