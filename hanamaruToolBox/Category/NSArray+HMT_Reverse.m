//
//  NSArray+HMT_Reverse.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import "NSArray+HMT_Reverse.h"

@implementation NSArray (HMT_Reverse)

- (NSArray *)reversedArray {
    NSMutableArray *newArray = [NSMutableArray array];
    for (id obj in self.reverseObjectEnumerator) {
        [newArray addObject:obj];
    }
    return newArray;
}

@end
