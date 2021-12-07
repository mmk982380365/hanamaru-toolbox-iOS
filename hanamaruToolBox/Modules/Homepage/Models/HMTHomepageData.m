//
//  HMTHomepageData.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import "HMTHomepageData.h"

@implementation HMTHomepageData

+ (instancetype)dataWithType:(HMTHomepageDataType)type {
    return [[self alloc] initWithType:type];
}

- (instancetype)initWithType:(HMTHomepageDataType)type
{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

@end
