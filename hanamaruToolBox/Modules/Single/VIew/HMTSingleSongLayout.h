//
//  HMTSingleSongLayout.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HMTSingleSongLayout;
@protocol HMTSingleSongLayoutDelegate <NSObject>

- (CGFloat)layout:(HMTSingleSongLayout *)layout heightForHeaderWithIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)layout:(HMTSingleSongLayout *)layout heightForCellWithIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width;

@end

@interface HMTSingleSongLayout : UICollectionViewFlowLayout

@property (weak, nonatomic) id<HMTSingleSongLayoutDelegate> delegate;

@property (assign, nonatomic) int column;

@end

NS_ASSUME_NONNULL_END
