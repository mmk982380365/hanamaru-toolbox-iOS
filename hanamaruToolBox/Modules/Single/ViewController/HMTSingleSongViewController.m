//
//  HMTSingleSongViewController.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import "HMTSingleSongViewController.h"
#import "HMTSingleSongCell.h"
#import "HMTSingleSongLayout.h"
#import "HMTSongListHeaderView.h"
#import "HMTLocalDataStorage.h"
#import "HMTAppUtils.h"

@interface HMTSingleSongViewController () <UICollectionViewDelegate, UICollectionViewDataSource, HMTSingleSongLayoutDelegate, HMTSingleSongCellDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) HMTSingleSongLayout *layout;

@property (strong, nonatomic) UISearchController *searchController;

@property (assign, nonatomic) BOOL searchActive;

@property (strong, nonatomic) NSArray *searchArray;

@end

@implementation HMTSingleSongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"singleSong", nil);
    
    self.searchController = [[UISearchController alloc] init];
    self.searchController.searchResultsUpdater = self;
    self.navigationItem.searchController = self.searchController;
    
    [self.collectionView registerClass:HMTSongListHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    self.layout = [[HMTSingleSongLayout alloc] init];
    self.layout.delegate = self;
    self.layout.column = 1;
    
    [self.collectionView setCollectionViewLayout:self.layout animated:NO];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HMTSingleSongCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    HMTSingle *single = nil;
    if (self.searchActive) {
        single = self.searchArray[indexPath.item];
    } else {
        single = [HMTLocalDataStorage sharedStorage].singleList[indexPath.item];
    }
    
    cell.single = single;
    cell.delegate = self;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.searchActive) {
        return self.searchArray.count;
    } else {
        return [HMTLocalDataStorage sharedStorage].singleList.count;
    }
    
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    HMTSongListHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    header.countLabel.text = [NSString stringWithFormat:@"%ld%@", [HMTLocalDataStorage sharedStorage].singleList.count, NSLocalizedString(@"count_header", nil)];;
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchActive) {
        return;
    }
    CABasicAnimation *animiation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animiation.fromValue = @0;
    animiation.toValue = @1;
    [cell.layer addAnimation:animiation forKey:@""];
}

#pragma mark - HMTSingleSongLayoutDelegate

- (CGFloat)layout:(HMTSingleSongLayout *)layout heightForHeaderWithIndexPath:(NSIndexPath *)indexPath {
    if (self.searchActive) {
        return 0;
    }
    return 24;
}

- (CGFloat)layout:(HMTSingleSongLayout *)layout heightForCellWithIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width {
    HMTSingle *single = nil;
    if (self.searchActive) {
        single = self.searchArray[indexPath.item];
    } else {
        single = [HMTLocalDataStorage sharedStorage].singleList[indexPath.item];
    }
    
    CGFloat imageHeight = (width - 16) * 9.0 / 16.0;
    
    CGSize textSize = [single.title boundingRectWithSize:CGSizeMake(width - 16 - 16, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:16]
    } context:nil].size;
    
    textSize.height += 1;
    
    
    // 16 (top + bottom) + imageHeight + 8 + textSize + 10 + 44(button) + 8
    return 16 + imageHeight + 8 + textSize.height + 10 + 44 + 8;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HMTSingle *single = nil;
    if (self.searchActive) {
        single = self.searchArray[indexPath.item];
    } else {
        single = [HMTLocalDataStorage sharedStorage].singleList[indexPath.item];
    }
    NSString *url = nil;
    if (single.y_url.length > 0 && single.b_url.length > 0) {
        NSString *lang = [HMTAppUtils getCurrentLanguage];
        if ([@"zh" isEqualToString:lang]) {
            url = single.b_url;
        } else {
            url = single.y_url;
        }
    } else if (single.y_url.length > 0) {
        url = single.y_url;
    } else if (single.b_url.length > 0) {
        url = single.b_url;
    }
    if (url) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
}

#pragma mark - HMTSingleSongCellDelegate

- (void)onClickYoutube:(HMTSingle *)single {
    if (single.y_url) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:single.y_url] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
}

- (void)onClickBilibili:(HMTSingle *)single {
    if (single.b_url) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:single.b_url] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *text = searchController.searchBar.text;
    if (text.length == 0) {
        if (self.searchActive) {
            self.searchActive = NO;
            [self.collectionView reloadData];
        }
        
    } else {
        self.searchActive = YES;
        
        self.searchArray = [[HMTLocalDataStorage sharedStorage].singleList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title CONTAINS %@", text]];
        
        [self.collectionView reloadData];
    }
    
    
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
