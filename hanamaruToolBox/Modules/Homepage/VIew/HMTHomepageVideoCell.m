//
//  HMTHomepageVideoCell.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import "HMTHomepageVideoCell.h"

@interface HMTHomepageVideoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *songListBtn;

@end

@implementation HMTHomepageVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Event

- (IBAction)onClickList:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickVideoList:)]) {
        [self.delegate onClickVideoList:self.video];
    }
}

#pragma mark - Setter

- (void)setVideo:(HMTVideo *)video {
    if (_video != video) {
        _video = video;
        self.logoImageView.image = [UIImage imageNamed:[@"b" isEqualToString:video.type] ? @"icon_bilibili" : @"icon_youtube"];
        self.titleLabel.text = video.title;
        self.timeLabel.text = video.date;
        self.songListBtn.hidden = !video.songList;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
