//
//  HMTSongListHeaderView.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import "HMTSongListHeaderView.h"
#import "HMTColorThemes.h"

#import <Masonry/Masonry.h>

@interface HMTSongListHeaderView ()

@end

@implementation HMTSongListHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.countLabel = [[UILabel alloc] init];
        self.countLabel.font = [UIFont systemFontOfSize:12];
        self.countLabel.textColor = [HMTColorThemes textColor];
        [self addSubview:self.countLabel];
        
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(8);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

@end
