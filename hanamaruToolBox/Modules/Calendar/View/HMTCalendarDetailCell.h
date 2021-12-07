//
//  HMTCalendarDetailCell.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import <UIKit/UIKit.h>

#import "HMTForecast.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMTCalendarDetailCell : UITableViewCell

@property (strong, nonatomic) HMTForecast *forecast;

@end

NS_ASSUME_NONNULL_END
