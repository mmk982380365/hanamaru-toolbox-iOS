//
//  HMTSlide.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMTSlide : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *img;
@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *bilibili_url;
@property (copy, nonatomic) NSString *youtube_url;

@end

NS_ASSUME_NONNULL_END
