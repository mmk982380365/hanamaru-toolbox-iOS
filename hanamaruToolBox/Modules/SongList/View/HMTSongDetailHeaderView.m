//
//  HMTSongDetailHeaderView.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/6.
//

#import "HMTSongDetailHeaderView.h"
#import "HMTColorThemes.h"

#import <Masonry/Masonry.h>

@interface HMTSongDetailHeaderView ()

@end

@implementation HMTSongDetailHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (@available(iOS 14.0, *)) {
            UIBackgroundConfiguration *conf = [UIBackgroundConfiguration listPlainHeaderFooterConfiguration];
            conf.backgroundColor = [HMTColorThemes primaryColor];
            conf.backgroundColorTransformer = ^UIColor * _Nonnull(UIColor * _Nonnull color) {
                
                if (@available(iOS 15.0, *)) {
                    return self.configurationState.isPinned ? color : [color colorWithAlphaComponent:0];
                } else {
                    // Fallback on earlier versions
                    return [HMTColorThemes backgroundColor];
                }
            };
            self.backgroundConfiguration = conf;
            
        } else {
            // Fallback on earlier versions
            self.backgroundColor = [HMTColorThemes primaryColor];
        }
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [HMTColorThemes textColor];
        [self.contentView addSubview:self.titleLabel];
        
        self.valueLabel = [[UILabel alloc] init];
        self.valueLabel.font = [UIFont systemFontOfSize:14];
        self.valueLabel.textColor = [HMTColorThemes textColor];
        [self.contentView addSubview:self.valueLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(8);
            make.top.bottom.equalTo(self.contentView).inset(4);
        }];
        
        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right);
            make.right.mas_lessThanOrEqualTo(self.contentView).offset(-8);
            make.centerY.equalTo(self.titleLabel);
        }];
    }
    return self;
}

- (void)setHeaderBackgroundColor:(UIColor *)headerBackgroundColor {
    _headerBackgroundColor = headerBackgroundColor;
    
    if (@available(iOS 14.0, *)) {
        UIBackgroundConfiguration *conf = [UIBackgroundConfiguration listPlainHeaderFooterConfiguration];
        conf.backgroundColor = headerBackgroundColor;
        conf.backgroundColorTransformer = ^UIColor * _Nonnull(UIColor * _Nonnull color) {
            
            if (@available(iOS 15.0, *)) {
                return self.configurationState.isPinned ? color : [color colorWithAlphaComponent:0];
            } else {
                // Fallback on earlier versions
                return color;
            }
        };
        self.backgroundConfiguration = conf;
        
    } else {
        // Fallback on earlier versions
        self.backgroundColor = headerBackgroundColor;
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
