//
//  HMTSliderViewController.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMTSliderViewController : UIViewController

@property (strong, nonatomic) UIViewController *selectedViewController;

@property (strong, nonatomic) NSArray<UIViewController *> *viewControllers;

@property (assign, nonatomic, getter=isOpen) BOOL open;

- (void)setOpen:(BOOL)open animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
