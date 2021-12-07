//
//  HMTHomepageData.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HMTHomepageDataType) {
    HMTHomepageDataTypeTopBanner = 0,
    HMTHomepageDataTypeSiteLink,
    HMTHomepageDataTypeBanner,
    HMTHomepageDataTypeForecast,
    HMTHomepageDataTypeVideoList
};

@interface HMTHomepageData : NSObject

@property (assign, nonatomic) HMTHomepageDataType type;

+ (instancetype)dataWithType:(HMTHomepageDataType)type;

- (instancetype)initWithType:(HMTHomepageDataType)type;

@end

NS_ASSUME_NONNULL_END
