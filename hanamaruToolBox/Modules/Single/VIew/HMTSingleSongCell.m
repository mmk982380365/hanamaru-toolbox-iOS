//
//  HMTSingleSongCell.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import "HMTSingleSongCell.h"
#import "HMTColorThemes.h"

#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>

@interface HMTSingleSongCell ()

@property (weak, nonatomic) IBOutlet UIView *cellBackgroundView;

@property (weak, nonatomic) IBOutlet UIView *cardContentView;

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *youtubeBtn;

@property (weak, nonatomic) IBOutlet UIButton *bilibiliBtn;

@end

@implementation HMTSingleSongCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cellBackgroundView.layer.cornerRadius = 4;
    
    self.cellBackgroundView.layer.shadowRadius = 3;
    self.cellBackgroundView.layer.shadowColor = HMT_ColorFromRGB(0xe2e3e5).CGColor;
    self.cellBackgroundView.layer.shadowOffset = CGSizeMake(2, 5);
    self.cellBackgroundView.layer.shadowOpacity = 1;
    self.cellBackgroundView.layer.masksToBounds = NO;
    
    
    
}

#pragma mark - Event

- (IBAction)onClickYoutube:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickYoutube:)]) {
        [self.delegate onClickYoutube:self.single];
    }
}

- (IBAction)onClickBilibili:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickBilibili:)]) {
        [self.delegate onClickBilibili:self.single];
    }
}

#pragma mark - Setter

- (void)setSingle:(HMTSingle *)single {
    if (_single != single) {
        _single = single;
        
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:single.img] placeholderImage:[UIImage imageNamed:@"img_default"]];
        
        self.nameLabel.text = single.title;
        
        if (single.y_url.length > 0 && single.b_url.length > 0) {
            // 都有
            self.youtubeBtn.hidden = NO;
            self.bilibiliBtn.hidden = NO;
            [self.youtubeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
                make.left.equalTo(self.cardContentView).offset(8);
                make.height.mas_equalTo(44);
            }];
            
            [self.bilibiliBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
                make.left.equalTo(self.youtubeBtn.mas_right).offset(8);
                make.height.mas_equalTo(44);
            }];
            
        } else if (single.y_url.length > 0) {
            // 404
            self.youtubeBtn.hidden = NO;
            self.bilibiliBtn.hidden = YES;
            
            [self.youtubeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
                make.left.equalTo(self.cardContentView).offset(8);
                make.height.mas_equalTo(44);
            }];
            
            [self.bilibiliBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            }];
        } else if (single.b_url.length > 0) {
            //b
            self.youtubeBtn.hidden = YES;
            self.bilibiliBtn.hidden = NO;
            
            [self.youtubeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                
            }];
            
            [self.bilibiliBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
                make.left.equalTo(self.cardContentView).offset(8);
                make.height.mas_equalTo(44);
            }];
            
        }
        
    }
}

@end
