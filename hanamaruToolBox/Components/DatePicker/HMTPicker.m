//
//  HMTPicker.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/5.
//

#import "HMTPicker.h"
#import "HMTColorThemes.h"

UIColor *colorForDarkMode(UIColor *normalModeColor, UIColor *darkModeColor) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 130000
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            return traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? darkModeColor : normalModeColor;
        }];
    } else {
        return normalModeColor;
    }
#else
    return normalModeColor;
#endif
}

UIColor *colorForDarkModeWithColor(int color) {
    return colorForDarkMode(HMT_ColorFromRGB(color), HMT_ColorFromRGB(0xffffff - color));
}

@interface HMTPicker () <UIPickerViewDelegate, UIPickerViewDataSource, CAAnimationDelegate>

@property (strong, nonatomic) UIWindow *mainWindow;

@property (strong, nonatomic) UIView *backgroundView;

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UIView *topView;

@property (strong, nonatomic) UIButton *cancelBtn;

@property (strong, nonatomic) UIButton *confirmBtn;

@property (strong, nonatomic) UIView *topLineView;

@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIDatePicker *datePickerView;

@property (strong, nonatomic) UIPickerView *normalPickerView;

#pragma mark - data

@property (assign, nonatomic) BOOL isAnimating;

@end

@implementation HMTPicker

- (instancetype)initWithType:(HMTPickerViewType)type
{
    self = [super init];
    if (self) {
        _dateMode = HMTPickerViewDateModeDateAndTime;
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backgroundView = ({
        UIView *view = [[UIView alloc] init];
        //0xA0A0A0
        view.backgroundColor = [colorForDarkModeWithColor(0xA0A0A0) colorWithAlphaComponent:0.5];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view;
    });
    [self.view addSubview:self.backgroundView];
    
    self.contentView = ({
        UIView *view = [[UIView alloc] init];
        //0xFFFFFF
        view.backgroundColor = colorForDarkModeWithColor(0xffffff);
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view;
    });
    [self.view addSubview:self.contentView];
    
    self.topView = ({
        UIView *view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view;
    });
    [self.contentView addSubview:self.topView];
    
    self.cancelBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
        //0x999999
        [btn setTitleColor:colorForDarkModeWithColor(0x999999) forState:UIControlStateNormal];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
        [btn addTarget:self action:@selector(cancelAct:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.topView addSubview:self.cancelBtn];
    
    self.confirmBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:NSLocalizedString(@"confirm", nil) forState:UIControlStateNormal];
        [btn setTitleColor:colorForDarkMode(HMT_ColorFromRGB(0x0086E1), HMT_ColorFromRGB(0x0086E1 + 0x111111)) forState:UIControlStateNormal];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
        [btn addTarget:self action:@selector(confirmAct:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.topView addSubview:self.confirmBtn];
    
    self.topLineView = ({
        UIView *view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view.backgroundColor = colorForDarkModeWithColor(0xECECEC);
        view;
    });
    [self.topView addSubview:self.topLineView];
    
    self.bottomView = ({
        UIView *view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view;
    });
    [self.contentView addSubview:self.bottomView];
    
    if (self.type == HMTPickerViewTypeDate) {
        self.datePickerView = ({
            UIDatePicker *picker = [[UIDatePicker alloc] init];
            picker.translatesAutoresizingMaskIntoConstraints = NO;
#ifdef __IPHONE_14_0
            if (@available(iOS 14.0, *)) {
                picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
            } else {
                
            }
#endif
            picker;
        });
        [self.bottomView addSubview:self.datePickerView];
        
        NSMutableArray<NSLayoutConstraint *> *bottomViewConstraints = [NSMutableArray arrayWithCapacity:0];
        //_datePickerView
        [bottomViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_datePickerView]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_datePickerView)]];
        [bottomViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_datePickerView(260)]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_datePickerView)]];
        [self.bottomView addConstraints:bottomViewConstraints];
        
        self.datePickerView.datePickerMode = (UIDatePickerMode)self.dateMode;
        if (self.date) {
            self.datePickerView.date = self.date;
        }
        self.datePickerView.minimumDate = self.minimumDate;
        self.datePickerView.maximumDate = self.maximumDate;
    } else {
        self.normalPickerView = ({
            UIPickerView *picker = [[UIPickerView alloc] init];
            picker.translatesAutoresizingMaskIntoConstraints = NO;
            picker.delegate = self;
            picker.dataSource = self;
            picker;
        });
        [self.bottomView addSubview:self.normalPickerView];
        
        NSMutableArray<NSLayoutConstraint *> *bottomViewConstraints = [NSMutableArray arrayWithCapacity:0];
        //_normalPickerView
        [bottomViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_normalPickerView]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_normalPickerView)]];
        [bottomViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_normalPickerView(260)]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_normalPickerView)]];
        [self.bottomView addConstraints:bottomViewConstraints];
        
        if (self.dataSelectIndex < self.dataArray.count && self.dataSelectIndex >= 0) {
            [self.normalPickerView selectRow:self.dataSelectIndex inComponent:0 animated:NO];
        }
    }
    
    NSMutableArray<NSLayoutConstraint *> *topViewConstraints = [NSMutableArray arrayWithCapacity:0];
    
    //_cancelBtn
    [topViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_cancelBtn]" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_cancelBtn)]];
    [topViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_cancelBtn]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_cancelBtn)]];
    
    //_confirmBtn
    [topViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_confirmBtn]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_confirmBtn)]];
    [topViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_confirmBtn]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_confirmBtn)]];
    
    //_topLineView
    [topViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_topLineView]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_topLineView)]];
    [topViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_topLineView(1)]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_topLineView)]];
    
    [self.topView addConstraints:topViewConstraints];
    
    NSMutableArray<NSLayoutConstraint *> *contentViewConstraints = [NSMutableArray arrayWithCapacity:0];
    
    //_topView
    [contentViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_topView]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_topView)]];
    [contentViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_topView(40)]" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_topView)]];
    
    //_bottomView
    [contentViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bottomView]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_bottomView)]];
    if (@available(iOS 9.0, *)) {
        [contentViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_topView]-0-[_bottomView]" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_topView, _bottomView)]];
        if (@available(iOS 11.0, *)) {
            [self.bottomView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
        } else {
            // Fallback on earlier versions
            [self.bottomView.bottomAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.bottomAnchor].active = YES;
        }
    } else {
        // Fallback on earlier versions
        [contentViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_topView]-0-[_bottomView(200)]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_topView, _bottomView)]];
    }
    
    [self.contentView addConstraints:contentViewConstraints];
    
    NSMutableArray<NSLayoutConstraint *> *viewConstraints = [NSMutableArray arrayWithCapacity:0];
    
    //_backgroundView
    [viewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backgroundView]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];
    [viewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_backgroundView]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];
    
    //_contentView
    [viewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentView]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_contentView)]];
    [viewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_contentView]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_contentView)]];
    
    [self.view addConstraints:viewConstraints];
}

- (void)show {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 130000
    if (@available(iOS 13, *)) {
        UIWindowScene *windowScene = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                windowScene = scene;
                break;
            }
        }
        if (windowScene.delegate) {
            self.mainWindow = [[UIWindow alloc] initWithWindowScene:windowScene];
            self.mainWindow.rootViewController = self;
            [self.mainWindow makeKeyAndVisible];
        } else {
            self.mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.mainWindow.rootViewController = self;
            [self.mainWindow makeKeyAndVisible];
        }
    } else {
        self.mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.mainWindow.rootViewController = self;
        [self.mainWindow makeKeyAndVisible];
    }
#else
    self.mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.mainWindow.rootViewController = self;
    [self.mainWindow makeKeyAndVisible];
#endif
    
    [self.view layoutIfNeeded];
    
    CABasicAnimation *opacityAnim = [HMTPicker opacityAnimationFrom:0 to:1];
    opacityAnim.duration = 0.25;
    [opacityAnim setValue:@"show" forKey:@"action"];
    opacityAnim.delegate = self;
    [self.backgroundView.layer addAnimation:opacityAnim forKey:@""];
    
    CGPoint fromCenter = self.contentView.center;
    CGPoint toCentenr = self.contentView.center;
    fromCenter.y += self.contentView.frame.size.height;
    
    CABasicAnimation *positionAnim = [HMTPicker positionAnimationFrom:fromCenter to:toCentenr];
    positionAnim.duration = 0.25;
    [self.contentView.layer addAnimation:positionAnim forKey:@""];
}

- (void)hide:(void (^)(void))callback {
    if (self.isAnimating) {
        return;
    }
    
    self.backgroundView.alpha = 0;
    
    CABasicAnimation *opacityAnim = [HMTPicker opacityAnimationFrom:1 to:0];
    opacityAnim.duration = 0.25;
    [opacityAnim setValue:@"hide" forKey:@"action"];
    [opacityAnim setValue:callback forKey:@"callback"];
    opacityAnim.delegate = self;
    [self.backgroundView.layer addAnimation:opacityAnim forKey:@""];
    
    CGPoint fromCenter = self.contentView.center;
    CGPoint toCentenr = self.contentView.center;
    toCentenr.y += self.contentView.frame.size.height;
    
    self.contentView.center = toCentenr;
    
    CABasicAnimation *positionAnim = [HMTPicker positionAnimationFrom:fromCenter to:toCentenr];
    positionAnim.duration = 0.25;
    [self.contentView.layer addAnimation:positionAnim forKey:@""];
    
}

- (void)cancelAct:(UIButton *)btn {
    [self hide:^{
        
    }];
}

- (void)confirmAct:(UIButton *)btn {
    [self hide:^{
        if (self.type == HMTPickerViewTypeDate) {
            !self.confirmCallback ?: self.confirmCallback(self.datePickerView.date);
        } else if (self.type == HMTPickerViewTypeStringArray) {
            if (self.dataArray.count > 0) {
                !self.confirmCallback ?: self.confirmCallback(@(self.dataSelectIndex));
            } else {
                !self.confirmCallback ?: self.confirmCallback(nil);
            }
        }
    }];
}

#pragma mark - Setter

- (void)setDateMode:(HMTPickerViewDateMode)dateMode {
    _dateMode = dateMode;
    if (self.datePickerView) {
        self.datePickerView.datePickerMode = (UIDatePickerMode)dateMode;
    }
}

- (void)setDate:(NSDate *)date {
    if (!date) {
        return;
    }
    _date = date;
    if (self.datePickerView) {
        self.datePickerView.date = date;
    }
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    _minimumDate = minimumDate;
    if (self.datePickerView) {
        self.datePickerView.minimumDate = minimumDate;
    }
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    _maximumDate = maximumDate;
    if (self.datePickerView) {
        self.datePickerView.maximumDate = maximumDate;
    }
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
    }
    NSString *string = [NSString stringWithFormat:@"%@", self.dataArray[row]];
    
    label.text = string;
    return label;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@", self.dataArray[row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _dataSelectIndex = row;
    [self.normalPickerView selectRow:_dataSelectIndex inComponent:0 animated:YES];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *action = [anim valueForKeyPath:@"action"];
    if ([action isEqualToString:@"show"]) {
        
    } else if ([action isEqualToString:@"hide"]) {
        void (^callback)(void);
        callback = [anim valueForKeyPath:@"callback"];
        !callback ?: callback();
        self.isAnimating = NO;
        [self.mainWindow resignKeyWindow];
        self.mainWindow = nil;
    }
}

#pragma mark - Utils

+ (CABasicAnimation *)opacityAnimationFrom:(CGFloat)from to:(CGFloat)to {
    return [self animWithKeyPath:@"opacity" from:@(from) to:@(to)];
}

+ (CABasicAnimation *)positionAnimationFrom:(CGPoint)from to:(CGPoint)to {
    return [self animWithKeyPath:@"position" from:[NSValue valueWithCGPoint:from] to:[NSValue valueWithCGPoint:to]];
}

+ (CABasicAnimation *)animWithKeyPath:(NSString *)keyPath from:(id)from to:(id)to {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:keyPath];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue = from;
    anim.toValue = to;
    return anim;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
