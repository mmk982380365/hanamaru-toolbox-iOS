//
//  UIViewController+HMT_Slider.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import <UIKit/UIKit.h>

#import "HMTSliderViewController.h"
#import "HMTSliderItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HMT_Slider)

- (nullable HMTSliderViewController *)hmt_sliderViewController;

- (void)hmt_addScreenEdgeGesture;

@property (strong, nonatomic) UIScreenEdgePanGestureRecognizer *hmt_screenEdgePanGestureRecognizer;

@property (assign, nonatomic) CGPoint hmt_edgeStartPoint;

@property (strong, nonatomic) HMTSliderItem *hmt_sliderItem;

- (void)hmt_onClickMain:(id)sender;

@end

NS_ASSUME_NONNULL_END
