//
//  HMTHomepageSectionHeaderView.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import "HMTHomepageSectionHeaderView.h"
#import "HMTColorThemes.h"

#import <Masonry/Masonry.h>

@implementation HMTHomepageSectionHeaderView

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
            self.backgroundColor = [HMTColorThemes backgroundColor];
        }
        
        self.numberLabel = [[UILabel alloc] init];
        self.numberLabel.font = [UIFont systemFontOfSize:12];
        self.numberLabel.textColor = [HMTColorThemes textColor];
        [self.contentView addSubview:self.numberLabel];
        
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(8);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
