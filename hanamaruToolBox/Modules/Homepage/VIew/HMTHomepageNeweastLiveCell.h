//
//  HMTHomepageNeweastLiveCell.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import <UIKit/UIKit.h>

#import "HMTLocalDataStorage.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMTHomepageNeweastLiveCell : UITableViewCell

@property (strong, nonatomic) NSArray<HMTForecast *> *forecasts;

@end

NS_ASSUME_NONNULL_END
