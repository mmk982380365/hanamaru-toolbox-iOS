//
//  HMTSectionView.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/5.
//

#import "HMTSectionView.h"
#import "HMTColorThemes.h"

#import <Masonry/Masonry.h>

@interface HMTSectionView ()

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UIView *selectedBackgroundView;

@property (strong, nonatomic) NSArray<UIButton *> *btnsArray;

@property (strong, nonatomic) UIButton *lastSelectBtn;

@end

@implementation HMTSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    self.selectedBackgroundView = [[UIView alloc] init];
    self.selectedBackgroundView.backgroundColor = [HMTColorThemes primaryColor];
    self.selectedBackgroundView.layer.cornerRadius = 4;
    [self.contentView addSubview:self.selectedBackgroundView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    [self updateButtons];
    [self updateSelectedBtn:NO];
}

- (void)updateButtons {
    // Create buttons
    if (self.btnsArray.count > 0) {
        [self.btnsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    NSMutableArray *btns = [NSMutableArray array];
    for (NSString *item in self.items) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.tintColor = [HMTColorThemes textColor];
        [btn setTitle:item forState:UIControlStateNormal];
        btn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        [btns addObject:btn];
    }
    self.btnsArray = btns;
    
    // Layout
    
    UIButton *last = nil;
    for (UIButton *btn in self.btnsArray) {
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            if (last) {
                make.left.equalTo(last.mas_right).offset(16);
            } else {
                make.left.equalTo(self.contentView).offset(8);
            }
        }];
        last = btn;
    }
    
    if (last) {
        [last mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).inset(8);
        }];
    }
}

- (void)updateSelectedBtn:(BOOL)animated {
    if (self.selectedIndex < 0 || self.selectedIndex >= self.items.count) {
        return;
    }
    
    self.lastSelectBtn.tintColor = [HMTColorThemes textColor];
    
    self.lastSelectBtn = self.btnsArray[self.selectedIndex];
    
    
    [self.selectedBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.lastSelectBtn);
    }];
    
    [self updateConstraintsIfNeeded];
    
    if (animated) {
        self.isAnimated = YES;
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.isAnimated = NO;
            self.lastSelectBtn.tintColor = [UIColor whiteColor];
        }];
    } else {
        self.lastSelectBtn.tintColor = [UIColor whiteColor];
    }
    
    if (self.scrollView.contentSize.width - self.scrollView.frame.size.width > 0) {
        CGPoint offset = CGPointZero;
        offset.x = self.lastSelectBtn.frame.origin.x - (self.scrollView.frame.size.width - self.lastSelectBtn.frame.size.width) / 2.0;
        if (offset.x < 0) {
            offset.x = 0;
        } else if (offset.x > self.scrollView.contentSize.width - self.scrollView.frame.size.width) {
            offset.x = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
        }
        
        [self.scrollView setContentOffset:offset animated:animated];
    }
    

}

#pragma mark - Event

- (void)onClickBtn:(UIButton *)sender {
    if (self.isAnimated) {
        return;
    }
    _selectedIndex = [self.btnsArray indexOfObject:sender];
    [self updateSelectedBtn:YES];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Setter

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    [self updateSelectedBtn:YES];
}

- (void)setItems:(NSArray *)items {
    if (_items != items) {
        _items = items;
        _selectedIndex = 0;
        [self updateButtons];
        [self updateSelectedBtn:NO];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
