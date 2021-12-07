//
//  HMTHTTPService.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const kBaseURL;

typedef void(^HMTHTTPServiceRequestSuccess)(NSArray* responseObject);

typedef void(^HMTHTTPServiceRequestFailure)(NSError *error);

@interface HMTHTTPService : NSObject

+ (instancetype)sharedService;

- (void)getForecastSuccess:(HMTHTTPServiceRequestSuccess)success failure:(HMTHTTPServiceRequestFailure)failure;

- (void)getSingleSuccess:(HMTHTTPServiceRequestSuccess)success failure:(HMTHTTPServiceRequestFailure)failure;

- (void)getSlidesSuccess:(HMTHTTPServiceRequestSuccess)success failure:(HMTHTTPServiceRequestFailure)failure;

- (void)getSongListSuccess:(HMTHTTPServiceRequestSuccess)success failure:(HMTHTTPServiceRequestFailure)failure;

- (void)getVideosSuccess:(HMTHTTPServiceRequestSuccess)success failure:(HMTHTTPServiceRequestFailure)failure;

@end

NS_ASSUME_NONNULL_END
