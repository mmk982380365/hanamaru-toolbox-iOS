//
//  HMTHomepageNeweastLiveCell.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import "HMTHomepageNeweastLiveCell.h"
#import "HMTColorThemes.h"

@interface HMTHomepageNeweastLiveCell ()

@property (weak, nonatomic) IBOutlet UILabel *forecastTitleLabel;

@end

@implementation HMTHomepageNeweastLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Setter

- (void)setForecasts:(NSArray<HMTForecast *> *)forecasts {
    if (_forecasts != forecasts) {
        _forecasts = forecasts;
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] init];
        
        for (HMTForecast *forecast in forecasts) {
            if ([@"b" isEqualToString:forecast.platform]) {
                // bilibili
                NSTextAttachment *attachment = [NSTextAttachment textAttachmentWithImage:[UIImage imageNamed:@"icon_forecast_bilibili"]];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                [attributeString appendAttributedString:attachmentString];
            } else {
                // youtube
                NSTextAttachment *attachment = [NSTextAttachment textAttachmentWithImage:[UIImage imageNamed:@"icon_forecast_youtube"]];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                [attributeString appendAttributedString:attachmentString];
            }
            
            NSString *dateString = [NSString stringWithFormat:@"%@ %@", forecast.date, forecast.time];
            
            NSDate *date = [self dateFromString:dateString];
            
            NSString *timeStr = [[[HMTHomepageNeweastLiveCell tokyoDateFormatter] stringFromDate:date] stringByAppendingString:@"(JST) / "];
            timeStr = [timeStr stringByAppendingFormat:@"%@(CST)", [[HMTHomepageNeweastLiveCell shanghaiDateFormatter] stringFromDate:date]];
            
            
            [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ %@", timeStr, forecast.title] attributes:@{
                NSForegroundColorAttributeName: [HMTColorThemes liveHintTextColor],
                NSFontAttributeName: [UIFont systemFontOfSize:12]
            }]];
            if (forecast != forecasts.lastObject) {
                [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
            }
        }
        
        self.forecastTitleLabel.attributedText = attributeString;
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

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

+ (NSDateFormatter *)tokyoDateFormatter {
    static NSDateFormatter *tokyoDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tokyoDateFormatter = [[NSDateFormatter alloc] init];
        tokyoDateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Tokyo"];
        tokyoDateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        tokyoDateFormatter.dateFormat = @"yyyy-MM-dd (EEEE) HH:mm";
        // 2021-12-05 (星期日) 21:00(JST)
        
    });
    return tokyoDateFormatter;
}

+ (NSDateFormatter *)shanghaiDateFormatter {
    static NSDateFormatter *shanghaiDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shanghaiDateFormatter = [[NSDateFormatter alloc] init];
        shanghaiDateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        shanghaiDateFormatter.dateFormat = @"HH:mm";
    });
    return shanghaiDateFormatter;
}

@end
