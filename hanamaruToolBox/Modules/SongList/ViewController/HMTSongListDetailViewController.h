//
//  HMTSongListDetailViewController.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/5.
//

#import "HMTViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMTSongListDetailViewController : HMTViewController

@property (copy, nonatomic) NSString *date;

- (void)scrollToIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
