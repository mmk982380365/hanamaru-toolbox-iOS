//
//  HMTHomepageBannerCell.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import "HMTHomepageBannerCell.h"

#import <SDCycleScrollView/SDCycleScrollView.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>

@interface HMTHomepageBannerImageCell : UICollectionViewCell

@end

@implementation HMTHomepageBannerImageCell



@end

@interface HMTHomepageBannerCell () <SDCycleScrollViewDelegate>

@property (strong, nonatomic) SDCycleScrollView *bannerView;

@end

@implementation HMTHomepageBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds delegate:self placeholderImage:[UIImage imageNamed:@"img_default"]];
    self.bannerView.layer.cornerRadius = 8;
    self.bannerView.layer.masksToBounds = YES;
    self.bannerView.autoScrollTimeInterval = 4;
    [self.contentView addSubview:self.bannerView];
    
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).inset(8);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickBanner:)]) {
        [self.delegate didClickBanner:self.slides[index]];
    }
}

#pragma mark - Setter

- (void)setSlides:(NSArray<HMTSlide *> *)slides {
    if (_slides != slides) {
        _slides = slides;
        self.bannerView.imageURLStringsGroup = [slides valueForKeyPath:@"img"];
    }
}

@end
