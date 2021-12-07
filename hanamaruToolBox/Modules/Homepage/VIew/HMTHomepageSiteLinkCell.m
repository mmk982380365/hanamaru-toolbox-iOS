//
//  HMTHomepageSiteLinkCell.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import "HMTHomepageSiteLinkCell.h"

@implementation HMTHomepageSiteLinkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Event

- (IBAction)onClickTwitter:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickTwitter)]) {
        [self.delegate onClickTwitter];
    }
}

- (IBAction)onClickYoutube:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickYoutube)]) {
        [self.delegate onClickYoutube];
    }
}

- (IBAction)onClickBilibili:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickBilibili)]) {
        [self.delegate onClickBilibili];
    }
}

- (IBAction)onClickFanbox:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickFanbox)]) {
        [self.delegate onClickFanbox];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
