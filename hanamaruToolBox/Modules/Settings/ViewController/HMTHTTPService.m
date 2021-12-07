//
//  HMTHTTPService.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import "HMTHTTPService.h"

#import <AFNetworking/AFNetworking.h>

NSString * const kBaseURL = @"https://hanamaru-hareru.vercel.app/";

@interface HMTHTTPService ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation HMTHTTPService

+ (instancetype)sharedService {
    static HMTHTTPService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[HMTHTTPService alloc] init];
    });
    return service;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [AFHTTPSessionManager manager];
    }
    return self;
}

- (void)getApi:(NSString *)api params:(id)params success:(HMTHTTPServiceRequestSuccess)success failure:(HMTHTTPServiceRequestFailure)failure {
    NSString *url = [kBaseURL stringByAppendingString:api];
    [self.manager GET:url parameters:params headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !success ?: success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(error);
    }];
    
}

//https://hanamaru-hareru.github.io/database/forecast.json
- (void)getForecastSuccess:(HMTHTTPServiceRequestSuccess)success failure:(HMTHTTPServiceRequestFailure)failure {
    [self getApi:@"database/forecast.json" params:nil success:success failure:failure];
}

//https://hanamaru-hareru.github.io/database/single.json
- (void)getSingleSuccess:(HMTHTTPServiceRequestSuccess)success failure:(HMTHTTPServiceRequestFailure)failure {
    [self getApi:@"database/single.json" params:nil success:success failure:failure];
}

//https://hanamaru-hareru.github.io/database/slides.json
- (void)getSlidesSuccess:(HMTHTTPServiceRequestSuccess)success failure:(HMTHTTPServiceRequestFailure)failure {
    [self getApi:@"database/slides.json" params:nil success:success failure:failure];
}

//https://hanamaru-hareru.github.io/database/song-list.json
- (void)getSongListSuccess:(HMTHTTPServiceRequestSuccess)success failure:(HMTHTTPServiceRequestFailure)failure {
    [self getApi:@"database/song-list.json" params:nil success:success failure:failure];
}

//https://hanamaru-hareru.github.io/database/videos.json
- (void)getVideosSuccess:(HMTHTTPServiceRequestSuccess)success failure:(HMTHTTPServiceRequestFailure)failure {
    [self getApi:@"database/videos.json" params:nil success:success failure:failure];
}

@end
