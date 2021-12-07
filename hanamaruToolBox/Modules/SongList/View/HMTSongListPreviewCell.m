//
//  HMTSongListPreviewCell.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/5.
//

#import "HMTSongListPreviewCell.h"

@interface HMTSongListPreviewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countOfAllLabel;
@property (weak, nonatomic) IBOutlet UILabel *countOfYoutubeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countOfBilibiliLabel;
@property (weak, nonatomic) IBOutlet UIImageView *platformLogoImageView;

@end

@implementation HMTSongListPreviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Setter

- (void)setStatistic:(HMTSongStatistic *)statistic {
    if (_statistic != statistic) {
        _statistic = statistic;
        self.nameLabel.text = statistic.name;
        self.timeLabel.text = statistic.last_live.date;
        self.countOfAllLabel.text = [NSString stringWithFormat:@"%d", (int)statistic.count];
        self.countOfYoutubeLabel.text = [NSString stringWithFormat:@"%d", (int)statistic.y_count.count];
        self.countOfBilibiliLabel.text = [NSString stringWithFormat:@"%d", (int)statistic.b_count.count];
        self.platformLogoImageView.image = [UIImage imageNamed:[@"y" isEqualToString:statistic.last_live.platform] ? @"icon_youtube" : @"icon_bilibili"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
