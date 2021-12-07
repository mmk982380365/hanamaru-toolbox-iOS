//
//  UIViewController+HMT_Slider.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import "UIViewController+HMT_Slider.h"

#import <objc/runtime.h>

@interface UIViewController () <UIGestureRecognizerDelegate>

@end

@implementation UIViewController (HMT_Slider)

- (HMTSliderViewController *)hmt_sliderViewController {
    
    if ([self.parentViewController isKindOfClass:HMTSliderViewController.class]) {
        return (HMTSliderViewController *)self.parentViewController;
    } else if (self.navigationController) {
        return self.navigationController.hmt_sliderViewController;
    } else if (self.tabBarController) {
        return self.tabBarController.hmt_sliderViewController;
    }
    
    return self.parentViewController.hmt_sliderViewController;
}

- (void)hmt_addScreenEdgeGesture {
    self.hmt_screenEdgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(hmt_onEdgePan:)];
    self.hmt_screenEdgePanGestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:self.hmt_screenEdgePanGestureRecognizer];
}

#pragma mark - Event

- (void)hmt_onClickMain:(id)sender {
    [self.hmt_sliderViewController setOpen:!self.hmt_sliderViewController.isOpen animated:YES];
}

- (void)hmt_onEdgePan:(UIScreenEdgePanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.view];
    
    UIScrollView *scrollView = [self.hmt_sliderViewController valueForKeyPath:@"scrollView"];
    UIScrollView *leftView = [self.hmt_sliderViewController valueForKeyPath:@"leftView"];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.hmt_edgeStartPoint = scrollView.contentOffset;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint offset = CGPointZero;
        offset.x = self.hmt_edgeStartPoint.x - translation.x;
        if (offset.x < 0) {
            offset.x = 0;
        } else if (offset.x > leftView.frame.size.width) {
            offset.x = leftView.frame.size.width;
        }
        scrollView.contentOffset = offset;
    } else {
        CGPoint offset = CGPointZero;
        offset.x = self.hmt_edgeStartPoint.x - translation.x;
        if (offset.x < leftView.frame.size.width / 2) {
            [self.hmt_sliderViewController setOpen:YES animated:YES];
        } else {
            [self.hmt_sliderViewController setOpen:NO animated:YES];
        }
    }
    
}

#pragma mark - Getter & Setter

static char hmt_screenEdgePanGestureRecognizerKey;

- (void)setHmt_screenEdgePanGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)hmt_screenEdgePanGestureRecognizer {
    hmt_screenEdgePanGestureRecognizer.delegate = self;
    objc_setAssociatedObject(self, &hmt_screenEdgePanGestureRecognizerKey, hmt_screenEdgePanGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIScreenEdgePanGestureRecognizer *)hmt_screenEdgePanGestureRecognizer {
    return objc_getAssociatedObject(self, &hmt_screenEdgePanGestureRecognizerKey);
}

static char hmt_edgeStartPointKey;

- (void)setHmt_edgeStartPoint:(CGPoint)hmt_edgeStartPoint {
    objc_setAssociatedObject(self, &hmt_edgeStartPointKey, [NSValue valueWithCGPoint:hmt_edgeStartPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGPoint)hmt_edgeStartPoint {
    return [objc_getAssociatedObject(self, &hmt_edgeStartPointKey) CGPointValue];
}

static char hmt_sliderItemKey;

- (void)setHmt_sliderItem:(HMTSliderItem *)hmt_sliderItem {
    objc_setAssociatedObject(self, &hmt_sliderItemKey, hmt_sliderItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HMTSliderItem *)hmt_sliderItem {
    return objc_getAssociatedObject(self, &hmt_sliderItemKey);
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self isKindOfClass:UINavigationController.class]) {
        return ((UINavigationController *)self).viewControllers.count <= 1;
    }
    return YES;
}

@end
