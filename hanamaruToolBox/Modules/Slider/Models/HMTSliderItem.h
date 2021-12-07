//
//  HMTSliderItem.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMTSliderItem : NSObject

@property (copy, nonatomic) NSString *name;

+ (instancetype)itemWithName:(NSString *)name;

- (instancetype)initWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
