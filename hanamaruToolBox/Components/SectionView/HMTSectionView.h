//
//  HMTSectionView.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMTSectionView : UIControl

@property (assign, nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) NSArray *items;

@property (assign, nonatomic) BOOL isAnimated;

@end

NS_ASSUME_NONNULL_END
