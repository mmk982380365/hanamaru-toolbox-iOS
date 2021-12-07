//
//  HMTSliderItem.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import "HMTSliderItem.h"

@implementation HMTSliderItem

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

+ (instancetype)itemWithName:(NSString *)name {
    return [[self alloc] initWithName:name];
}

@end
