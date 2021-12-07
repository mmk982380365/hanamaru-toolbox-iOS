//
//  HMTSilderView.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import <UIKit/UIKit.h>

#import "HMTSliderItem.h"

NS_ASSUME_NONNULL_BEGIN

@class HMTSilderView;
@protocol HMTSliderViewDelegate <NSObject>

- (void)sliderView:(HMTSilderView *)sliderView didSelectedItem:(HMTSliderItem *)item;

@end

@interface HMTSilderView : UIView

@property (weak, nonatomic) id<HMTSliderViewDelegate> delegate;

@property (strong, nonatomic) NSArray<HMTSliderItem *> *items;

@property (strong, nonatomic) HMTSliderItem *selectedItem;

@end

NS_ASSUME_NONNULL_END
