//
//  HMTSongDetailCell.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/6.
//

#import "HMTSongDetailCell.h"

@interface HMTSongDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation HMTSongDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Event

- (IBAction)onClickList:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickSongList:)]) {
        [self.delegate onClickSongList:self.statistic];
    }
}

#pragma mark - Setter

- (void)setStatistic:(HMTSongStatisticCount *)statistic {
    if (_statistic != statistic) {
        _statistic = statistic;
        self.detailLabel.text = [NSString stringWithFormat:@"%@ (%@)", statistic.date, statistic.timestamp];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
