//
//  HMTCalendarDetailCell.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import "HMTCalendarDetailCell.h"

@interface HMTCalendarDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation HMTCalendarDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Setter

- (void)setForecast:(HMTForecast *)forecast {
    if (_forecast != forecast) {
        _forecast = forecast;
        self.logoImageView.image = [UIImage imageNamed:[@"b" isEqualToString:forecast.platform] ? @"icon_bilibili" : @"icon_youtube"];
        NSString *dateString = [NSString stringWithFormat:@"%@ %@", forecast.date, forecast.time];
        
        NSDate *date = [self dateFromString:dateString];
        
        NSDateFormatter *dtfm = [[NSDateFormatter alloc] init];
        dtfm.dateFormat = @"HH:mm";
        
        self.timeLabel.text = [dtfm stringFromDate:date];
        
        self.titleLabel.text = forecast.title;
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Utils

- (NSDate *)dateFromString:(NSString *)dateString {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Tokyo"];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    });
    return [dateFormatter dateFromString:dateString];
}

@end
