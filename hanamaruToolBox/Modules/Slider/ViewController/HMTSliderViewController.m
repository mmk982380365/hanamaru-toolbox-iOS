//
//  HMTSliderViewController.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import "HMTSliderViewController.h"
#import "UIViewController+HMT_Slider.h"
#import "HMTSilderView.h"

#import <Masonry/Masonry.h>

@interface HMTSliderViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate, HMTSliderViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet HMTSilderView *leftView;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) UIView *gestureView;

@property (strong, nonatomic) UIPanGestureRecognizer *gestureViewPanGesture;

@property (strong, nonatomic) UITapGestureRecognizer *gestureViewTapGesture;

@property (assign, nonatomic) CGPoint edgeStartPoint;

@end

@implementation HMTSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.gestureView = [[UIView alloc] init];
    
    self.gestureViewPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onEdgePan:)];
    [self.gestureView addGestureRecognizer:self.gestureViewPanGesture];
    
    self.gestureViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.gestureView addGestureRecognizer:self.gestureViewTapGesture];
    
    self.leftView.delegate = self;
    
    if (_selectedViewController) {
        [_selectedViewController willMoveToParentViewController:self];
        [self addChildViewController:_selectedViewController];
        [self.containerView addSubview:_selectedViewController.view];
            _selectedViewController.view.frame = self.containerView.bounds;
        [_selectedViewController didMoveToParentViewController:self];
    }
    self.leftView.items = [_viewControllers valueForKeyPath:@"hmt_sliderItem"];
    self.leftView.selectedItem = _selectedViewController.hmt_sliderItem;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.scrollView.contentOffset = CGPointMake(self.leftView.frame.size.width, 0);
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.gestureView.frame = self.containerView.frame;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - Event

- (void)onTap:(id)sender {
    [self setOpen:NO animated:YES];
}

- (void)onEdgePan:(UIScreenEdgePanGestureRecognizer *)gesture {
    CGPoint translation = [gesture locationInView:self.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.edgeStartPoint = translation;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint offset = CGPointZero;
        offset.x = translation.x - self.edgeStartPoint.x;
        
        if (offset.x > 0) {
            offset.x = 0;
        } else if (offset.x < -self.leftView.frame.size.width) {
            offset.x = -self.leftView.frame.size.width;
        }
        offset.x = -offset.x;
        self.scrollView.contentOffset = offset;
    } else {
        CGPoint offset = CGPointZero;
        offset.x = self.edgeStartPoint.x - translation.x;
        if (offset.x < self.leftView.frame.size.width / 2) {
            [self setOpen:YES animated:YES];
        } else {
            [self setOpen:NO animated:YES];
        }
    }
    
}

#pragma mark - Setter

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers {
    if (_viewControllers != viewControllers) {
        _viewControllers = viewControllers;
        if (viewControllers.count > 0) {
            self.selectedViewController = viewControllers.firstObject;
            for (UIViewController *viewController in viewControllers) {
                if (!viewController.hmt_sliderItem) {
                    viewController.hmt_sliderItem = [HMTSliderItem itemWithName:viewController.title];
                }
                if ([viewController isKindOfClass:UINavigationController.class]) {
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    [button setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
                    [button addTarget:viewController action:@selector(hmt_onClickMain:) forControlEvents:UIControlEventTouchUpInside];
                    [(UINavigationController *)viewController viewControllers].firstObject.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
                }
            }
        }
        
        NSArray *array = [viewControllers valueForKeyPath:@"hmt_sliderItem"];
        self.leftView.items = array;
    }
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    if (_selectedViewController != selectedViewController) {
        
        if (_selectedViewController && self.isViewLoaded) {
            [_selectedViewController willMoveToParentViewController:nil];
            [_selectedViewController.view removeFromSuperview];
            [_selectedViewController removeFromParentViewController];
            [_selectedViewController didMoveToParentViewController:nil];
        }
        _selectedViewController = selectedViewController;
        if (!_selectedViewController.hmt_screenEdgePanGestureRecognizer) {
            [_selectedViewController hmt_addScreenEdgeGesture];
        }
        
        if (self.isViewLoaded) {
            [_selectedViewController willMoveToParentViewController:self];
            [self addChildViewController:_selectedViewController];
            [self.containerView addSubview:_selectedViewController.view];
            _selectedViewController.view.frame = self.containerView.bounds;
            [_selectedViewController didMoveToParentViewController:self];
        }
        self.leftView.selectedItem = _selectedViewController.hmt_sliderItem;
       
    }
}

- (void)setOpen:(BOOL)open {
    
    [self setOpen:open animated:NO];
}

- (void)setOpen:(BOOL)open animated:(BOOL)animated {
    if (_open != open) {
        _open = open;
        if (open) {
            [self.contentView addSubview:self.gestureView];
        } else {
            [self.gestureView removeFromSuperview];
        }
    }
    [self.scrollView setContentOffset:CGPointMake(open ? 0 : self.leftView.frame.size.width, 0) animated:animated];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.gestureViewPanGesture.state == UIGestureRecognizerStateChanged) {
        return;
    }
    if (scrollView.contentOffset.x == self.leftView.frame.size.width) {
        if (_open != NO) {
            _open = NO;
            [self.gestureView removeFromSuperview];
        }
    } else {
        if (_open != YES) {
            _open = YES;
            [self.contentView addSubview:self.gestureView];
        }
        
    }
}

#pragma mark - HMTSliderViewDelegate

- (void)sliderView:(HMTSilderView *)sliderView didSelectedItem:(HMTSliderItem *)item {
    NSInteger index = [self.leftView.items indexOfObject:item];
    self.selectedViewController = self.viewControllers[index];
    [self setOpen:NO animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
