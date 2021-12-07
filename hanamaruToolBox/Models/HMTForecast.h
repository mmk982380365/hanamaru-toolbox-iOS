//
//  HMTForecast.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMTForecast : NSObject

@property (copy, nonatomic) NSString *platform;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *url;

@end

NS_ASSUME_NONNULL_END
