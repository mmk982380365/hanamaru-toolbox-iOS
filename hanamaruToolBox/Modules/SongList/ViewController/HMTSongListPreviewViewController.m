//
//  HMTSongListPreviewViewController.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/5.
//

#import "HMTSongListPreviewViewController.h"
#import "HMTPicker.h"
#import "HMTSongListPreviewCell.h"
#import "HMTLocalDataStorage.h"
#import "HMTSongDetailViewController.h"

typedef NS_ENUM(NSInteger, HMTSongSortType) {
    HMTSongSortTypeName = 0,
    HMTSongSortTypeTime,
    HMTSongSortTypeCountAll,
    HMTSongSortTypeCountBilibili,
    HMTSongSortTypeCountYoutube
};

typedef NS_ENUM(NSInteger, HMTSongOrderType) {
    HMTSongOrderTypeAsc = 0, // 升序
    HMTSongOrderTypeDesc  // 降序
};

@interface HMTSongListPreviewViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *sortTypeBtn;

@property (weak, nonatomic) IBOutlet UIButton *orderTypeBtn;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (assign, nonatomic) BOOL searchActive;

@property (assign, nonatomic) HMTSongSortType sortType;

@property (assign, nonatomic) HMTSongOrderType orderType;

@property (strong, nonatomic) NSArray<HMTSongStatistic *> *dataArray;

@property (strong, nonatomic) NSArray<HMTSongStatistic *> *searchArray;

@end

@implementation HMTSongListPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sortType = HMTSongSortTypeName;
    self.orderType = HMTSongOrderTypeAsc;
    
    [self loadData];
    
}

#pragma mark - Data

- (void)loadData {
    NSArray *dataArray;
    if (self.searchActive) {
        dataArray = self.searchArray;
    } else if (self.isAll) {
        dataArray = [HMTLocalDataStorage sharedStorage].mappedAllStatistic;
    } else if (self.isMedley) {
        dataArray = [HMTLocalDataStorage sharedStorage].mappedMedleyStatistic;
    } else {
        dataArray = [HMTLocalDataStorage sharedStorage].mappedSongStatistic;
    }
    
    
    NSString *sortKey = nil;
    switch (self.sortType) {
        case HMTSongSortTypeName:
            sortKey = @"name";
            break;
            
        case HMTSongSortTypeTime:
            sortKey = @"last_live.date";
            break;
            
        case HMTSongSortTypeCountAll:
            sortKey = @"count";
            break;
            
        case HMTSongSortTypeCountYoutube:
            sortKey = @"y_count_num";
            break;
            
        case HMTSongSortTypeCountBilibili:
            sortKey = @"b_count_num";
            break;
            
        default:
            sortKey = @"name";
            break;
    }
    
    dataArray = [dataArray sortedArrayUsingDescriptors:@[
        [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:self.orderType == HMTSongOrderTypeAsc ? YES : NO]
    ]];
    
    if (self.searchActive) {
        self.searchArray = dataArray;
    } else {
        self.dataArray = dataArray;
    }
    [self.tableView reloadData];
}

#pragma mark - Event

- (IBAction)onClickSortType:(id)sender {
    HMTPicker *picker = [[HMTPicker alloc] initWithType:HMTPickerViewTypeStringArray];
    picker.dataArray = @[
        NSLocalizedString(@"sortTypeName", nil),
        NSLocalizedString(@"sortTypeTime", nil),
        NSLocalizedString(@"sortTypeCountAll", nil),
        NSLocalizedString(@"sortTypeCountYoutube", nil),
        NSLocalizedString(@"sortTypeCountBilibili", nil)
    ];
    picker.dataSelectIndex = self.sortType;
    picker.confirmCallback = ^(id  _Nullable data) {
        self.sortType = [data integerValue];
    };
    [picker show];
}

- (IBAction)onClickOrderType:(id)sender {
    HMTPicker *picker = [[HMTPicker alloc] initWithType:HMTPickerViewTypeStringArray];
    picker.dataArray = @[
        NSLocalizedString(@"orderTypeAsc", nil),
        NSLocalizedString(@"orderTypeDesc", nil)
    ];
    picker.dataSelectIndex = self.orderType;
    picker.confirmCallback = ^(id  _Nullable data) {
        self.orderType = [data integerValue];
    };
    [picker show];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HMTSongListPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    HMTSongStatistic *statistic = (self.searchActive ? self.searchArray : self.dataArray)[indexPath.row];
    cell.statistic = statistic;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.searchActive ? self.searchArray : self.dataArray).count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HMTSongDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"songDetail"];
    HMTSongStatistic *statistic = (self.searchActive ? self.searchArray : self.dataArray)[indexPath.row];
    vc.songStatistic = statistic;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.searchActive = NO;
    } else {
        self.searchActive = YES;
        
        self.searchArray = [self.dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name CONTAINS %@", searchText]];
    }
    
    [self loadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Setter

- (void)setSortType:(HMTSongSortType)sortType {
    _sortType = sortType;
    NSString *name = nil;
    switch (sortType) {
        case HMTSongSortTypeName:
        {
            name = NSLocalizedString(@"sortTypeName", nil);
        }
            break;
        case HMTSongSortTypeTime:
        {
            name = NSLocalizedString(@"sortTypeTime", nil);
        }
            break;
        case HMTSongSortTypeCountAll:
        {
            name = NSLocalizedString(@"sortTypeCountAll", nil);
        }
            break;
        case HMTSongSortTypeCountYoutube:
        {
            name = NSLocalizedString(@"sortTypeCountYoutube", nil);
        }
            break;
        case HMTSongSortTypeCountBilibili:
        {
            name = NSLocalizedString(@"sortTypeCountBilibili", nil);
        }
            break;
            
        default:
            break;
    }
    [self.sortTypeBtn setTitle:name forState:UIControlStateNormal];
    [self loadData];
}

- (void)setOrderType:(HMTSongOrderType)orderType {
    _orderType = orderType;
    NSString *name = nil;
    switch (orderType) {
        case HMTSongOrderTypeAsc:
        {
            name = NSLocalizedString(@"orderTypeAsc", nil);
        }
            break;
        case HMTSongOrderTypeDesc:
        {
            name = NSLocalizedString(@"orderTypeDesc", nil);
        }
            break;
            
        default:
            break;
    }
    [self.orderTypeBtn setTitle:name forState:UIControlStateNormal];
    [self loadData];
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
