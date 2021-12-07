//
//  HMTSongDetailViewController.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/6.
//

#import "HMTSongDetailViewController.h"
#import "HMTSongDetailHeaderView.h"
#import "HMTSongDetailCell.h"

NSNotificationName const HMTSongDetailViewControllerShowSongList = @"HMTSongDetailViewControllerShowSongList";

@interface HMTSongDetailViewController () <UITableViewDelegate, UITableViewDataSource, HMTSongDetailCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *allCountLabel;

@end

@implementation HMTSongDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    } else {
        // Fallback on earlier versions
    }
    [self.tableView registerClass:HMTSongDetailHeaderView.class forHeaderFooterViewReuseIdentifier:@"header"];
    
    
    self.lastTimeLabel.text = self.songStatistic.last_live.date;
    self.allCountLabel.text = [NSString stringWithFormat:@"%d", (int)self.songStatistic.count];
    self.title = self.songStatistic.name;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HMTSongDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    HMTSongStatisticCount *statistic = (indexPath.section == 0 ? self.songStatistic.y_count : self.songStatistic.b_count)[indexPath.row];
    cell.statistic = statistic;
    cell.delegate = self;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.songStatistic.y_count.count;
    }
    return self.songStatistic.b_count.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HMTSongDetailHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (section == 0) {
        headerView.titleLabel.text = NSLocalizedString(@"songDetailHeaderYoutube", nil);
        headerView.valueLabel.text = [NSString stringWithFormat:@"%d", (int)self.songStatistic.y_count.count];
    } else {
        headerView.titleLabel.text = NSLocalizedString(@"songDetailHeaderBilibili", nil);
        headerView.valueLabel.text = [NSString stringWithFormat:@"%d", (int)self.songStatistic.b_count.count];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

#pragma mark - HMTSongDetailCellDelegate

- (void)onClickSongList:(HMTSongStatisticCount *)statistic {
    NSString *date = statistic.date;
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:HMTSongDetailViewControllerShowSongList object:nil userInfo:@{
        @"date": date ?: @"",
        @"name": self.songStatistic.name
    }];
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
