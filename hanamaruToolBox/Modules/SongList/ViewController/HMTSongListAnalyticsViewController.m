//
//  HMTSongListAnalyticsViewController.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/5.
//

#import "HMTSongListAnalyticsViewController.h"
#import "HMTSectionView.h"
#import "HMTSongListPreviewCell.h"
#import "HMTLocalDataStorage.h"
#import "HMTSongDetailHeaderView.h"
#import "HMTSongDetailViewController.h"
#import "HMTColorThemes.h"

#import <Masonry/Masonry.h>
#import <iOS-Echarts/iOS-Echarts.h>

@interface HMTSongListAnalyticsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet HMTSectionView *sectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *echartContentView;

@property (strong, nonatomic) WKEchartsView *echartView;

@property (assign, nonatomic) NSInteger currentIndex;

@property (assign, nonatomic) BOOL onLoadFlag;

@property (strong, nonatomic) PYOption *echartOption;

@end

@implementation HMTSongListAnalyticsViewController

+ (void)load {
    __unused WKEchartsView *echart = [[WKEchartsView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sectionView.items = @[NSLocalizedString(@"limitSingle", nil), NSLocalizedString(@"limitMedley", nil)];
    
    [self.tableView registerClass:HMTSongDetailHeaderView.class forHeaderFooterViewReuseIdentifier:@"header"];
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.onLoadFlag) {
        [self createEchartView];
        [self loadEchartData];
        self.onLoadFlag = YES;
    }
}

- (void)createEchartView {
    self.echartView = [[WKEchartsView alloc] init];
    self.echartView.userInteractionEnabled = NO;
    [self.echartContentView addSubview:self.echartView];
    
    [self.echartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.echartContentView);
    }];
}

- (void)loadEchartData {
    PYOption *option = [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.orientEqual(PYOrientVertical)
            .xEqual(PYPositionLeft)
            .dataEqual(@[
                NSLocalizedString(@"youtube", nil),
                NSLocalizedString(@"bilibili", nil),
                NSLocalizedString(@"statisticAll", nil)
            ]);
        }])
        .addSeries([PYPieSeries initPYPieSeriesWithBlock:^(PYPieSeries *series) {
            series.radiusEqual(@"45%")
            .centerEqual(@[@"55%",@"60%"])
            .typeEqual(PYSeriesTypePie)
            .dataEqual(@[
                       @{@"value":@((self.currentIndex == 0 ? [HMTLocalDataStorage sharedStorage].songLimited : [HMTLocalDataStorage sharedStorage].medleyLimited).youtube.count),@"name":NSLocalizedString(@"youtube", nil)},
                       @{@"value":@((self.currentIndex == 0 ? [HMTLocalDataStorage sharedStorage].songLimited : [HMTLocalDataStorage sharedStorage].medleyLimited).bilibili.count),@"name":NSLocalizedString(@"bilibili", nil)},
                       @{@"value":@((self.currentIndex == 0 ? [HMTLocalDataStorage sharedStorage].songLimited : [HMTLocalDataStorage sharedStorage].medleyLimited).both.count),@"name":NSLocalizedString(@"statisticAll", nil)},
            ]);
        }]);
    }];
    
    
    if (!self.echartOption) {
        [self.echartView setOption:option];
        [self.echartView loadEcharts];
        
    } else {
        [self.echartView refreshEchartsWithOption:option];
    }
    
    self.echartOption = option;
    
}

#pragma mark - Event

- (IBAction)onChangeSection:(id)sender {
    self.currentIndex = self.sectionView.selectedIndex;
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
    [self loadEchartData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HMTSongListPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    HMTSongStatistic *statistic = nil;
    if (indexPath.section == 0) {
        statistic = (self.currentIndex == 0 ? [HMTLocalDataStorage sharedStorage].songLimited : [HMTLocalDataStorage sharedStorage].medleyLimited).youtube[indexPath.row];
    } else {
        statistic = (self.currentIndex == 0 ? [HMTLocalDataStorage sharedStorage].songLimited : [HMTLocalDataStorage sharedStorage].medleyLimited).bilibili[indexPath.row];
    }
    cell.statistic = statistic;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return (self.currentIndex == 0 ? [HMTLocalDataStorage sharedStorage].songLimited : [HMTLocalDataStorage sharedStorage].medleyLimited).youtube.count;
    }
    return (self.currentIndex == 0 ? [HMTLocalDataStorage sharedStorage].songLimited : [HMTLocalDataStorage sharedStorage].medleyLimited).bilibili.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HMTSongDetailHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    headerView.titleLabel.text = section == 0 ? NSLocalizedString(@"youtube", nil) : NSLocalizedString(@"bilibili", nil);
    headerView.headerBackgroundColor = [HMTColorThemes backgroundColor];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HMTSongDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"songDetail"];
    HMTSongStatistic *statistic = nil;
    if (indexPath.section == 0) {
        statistic = (self.currentIndex == 0 ? [HMTLocalDataStorage sharedStorage].songLimited : [HMTLocalDataStorage sharedStorage].medleyLimited).youtube[indexPath.row];
    } else {
        statistic = (self.currentIndex == 0 ? [HMTLocalDataStorage sharedStorage].songLimited : [HMTLocalDataStorage sharedStorage].medleyLimited).bilibili[indexPath.row];
    }
    vc.songStatistic = statistic;
    [self.navigationController pushViewController:vc animated:YES];
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
