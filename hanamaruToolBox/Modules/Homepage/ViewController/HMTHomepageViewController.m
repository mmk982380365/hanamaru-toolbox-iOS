//
//  HMTHomepageViewController.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import "HMTHomepageViewController.h"
#import "UIViewController+HMT_Slider.h"
#import "HMTHomepageTopBannerCell.h"
#import "HMTHomepageSiteLinkCell.h"
#import "HMTHomepageBannerCell.h"
#import "HMTHomepageNeweastLiveCell.h"
#import "HMTHomepageVideoCell.h"
#import "HMTLocalDataStorage.h"
#import "HMTHomepageData.h"
#import "HMTHomepageSectionHeaderView.h"
#import "HMTAppUtils.h"
#import "HMTColorThemes.h"
#import "HMTSongListDetailViewController.h"

@interface HMTHomepageViewController () <UITableViewDelegate, UITableViewDataSource, HMTHomepageSiteLinkCellDelegate, HMTHomepageBannerCellDelegate, HMTHomepageVideoCellDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray<HMTHomepageData *> *dataArray;

@property (strong, nonatomic) UISearchController *searchController;

@property (assign, nonatomic) BOOL searchActive;

@property (strong, nonatomic) NSArray<HMTVideo *> *searchArray;

@end

@implementation HMTHomepageViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"live", nil);
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    } else {
        // Fallback on earlier versions
    }
    
    [self.tableView registerClass:HMTHomepageSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(HMTHomepageSectionHeaderView.class)];
    
    self.searchController = [[UISearchController alloc] init];
    self.searchController.searchResultsUpdater = self;
    self.navigationItem.searchController = self.searchController;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveDataUpdate:) name:HMTDidFinishFetchDataBotification object:nil];
    [self loadData];
}

- (void)loadData {
    NSMutableArray *dataArray = [NSMutableArray array];
    
    HMTHomepageData *topBanner = [HMTHomepageData dataWithType:HMTHomepageDataTypeTopBanner];
    [dataArray addObject:topBanner];
    
    HMTHomepageData *siteLink = [HMTHomepageData dataWithType:HMTHomepageDataTypeSiteLink];
    [dataArray addObject:siteLink];
    
    if ([HMTLocalDataStorage sharedStorage].slideList.count > 0) {
        HMTHomepageData *banner = [HMTHomepageData dataWithType:HMTHomepageDataTypeBanner];
        [dataArray addObject:banner];
    }
    
    if ([HMTLocalDataStorage sharedStorage].forecastList.count > 0) {
        HMTHomepageData *forecast = [HMTHomepageData dataWithType:HMTHomepageDataTypeForecast];
        [dataArray addObject:forecast];
    }
    
    if ([HMTLocalDataStorage sharedStorage].videoList.count > 0) {
        HMTHomepageData *videoList = [HMTHomepageData dataWithType:HMTHomepageDataTypeVideoList];
        [dataArray addObject:videoList];
    }
    
    self.dataArray = dataArray;
    [self.tableView reloadData];
}

#pragma mark - Event

- (void)onReceiveDataUpdate:(NSNotification *)notification {
    [self loadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchActive) {
        HMTHomepageVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"video" forIndexPath:indexPath];
        HMTVideo *video = self.searchArray[indexPath.row];
        cell.video = video;
        return cell;
    }
    HMTHomepageData *data = self.dataArray[indexPath.section];
    if (data.type == HMTHomepageDataTypeTopBanner) {
        HMTHomepageTopBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topBanner" forIndexPath:indexPath];
        
        return cell;
    } else if (data.type == HMTHomepageDataTypeSiteLink) {
        HMTHomepageSiteLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"siteLink" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    } else if (data.type == HMTHomepageDataTypeBanner) {
        HMTHomepageBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"banner" forIndexPath:indexPath];
        cell.delegate = self;
        cell.slides = [HMTLocalDataStorage sharedStorage].slideList;
        return cell;
    } else if (data.type == HMTHomepageDataTypeForecast) {
        HMTHomepageNeweastLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"neweastLive" forIndexPath:indexPath];
        cell.forecasts = [HMTLocalDataStorage sharedStorage].forecastList;
        return cell;
    } else if (data.type == HMTHomepageDataTypeVideoList) {
        HMTHomepageVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"video" forIndexPath:indexPath];
        HMTVideo *video = [HMTLocalDataStorage sharedStorage].videoList[indexPath.row];
        cell.video = video;
        cell.delegate = self;
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchActive) {
        return self.searchArray.count;
    }
    HMTHomepageData *data = self.dataArray[section];
    if (data.type == HMTHomepageDataTypeTopBanner || data.type == HMTHomepageDataTypeSiteLink || data.type == HMTHomepageDataTypeBanner  || data.type == HMTHomepageDataTypeForecast) {
        return 1;
    } else if (data.type == HMTHomepageDataTypeVideoList) {
        return [HMTLocalDataStorage sharedStorage].videoList.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchActive) {
        return 1;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchActive) {
        return UITableViewAutomaticDimension;
    }
    HMTHomepageData *data = self.dataArray[indexPath.section];
    if (data.type == HMTHomepageDataTypeTopBanner) {
        CGFloat width = tableView.bounds.size.width;
        CGFloat height = width * 94.0 / 414.0;
        return height;
    } else if (data.type == HMTHomepageDataTypeSiteLink) {
        return 48;
    } else if (data.type == HMTHomepageDataTypeBanner) {
        CGFloat width = tableView.bounds.size.width - 16;
        CGFloat height = width * 9.0 / 16.0 + 16;
        return height;
    } else if (data.type == HMTHomepageDataTypeForecast || data.type == HMTHomepageDataTypeVideoList) {
        return UITableViewAutomaticDimension;
    } 
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.searchActive) {
        return nil;
    }
    HMTHomepageData *data = self.dataArray[section];
    if (data.type == HMTHomepageDataTypeVideoList) {
        HMTHomepageSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(HMTHomepageSectionHeaderView.class)];
        header.numberLabel.text = [NSString stringWithFormat:@"%ld%@", [HMTLocalDataStorage sharedStorage].videoList.count, NSLocalizedString(@"count_header", nil)];;
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.searchActive) {
        return 0;
    }
    HMTHomepageData *data = self.dataArray[section];
    if (data.type == HMTHomepageDataTypeVideoList) {
        return 48;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchActive) {
        HMTVideo *video = self.searchArray[indexPath.row];
        NSString *url = nil;
        if ([@"b" isEqualToString:video.type]) {
            url = video.url_b;
        } else {
            url = video.url_y;
        }
        if (url) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
                
            }];
        }
        return;
    }
    HMTHomepageData *data = self.dataArray[indexPath.section];
    if (data.type == HMTHomepageDataTypeVideoList) {
        HMTVideo *video = [HMTLocalDataStorage sharedStorage].videoList[indexPath.row];
        NSString *url = nil;
        if ([@"b" isEqualToString:video.type]) {
            url = video.url_b;
        } else {
            url = video.url_y;
        }
        if (url) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
                
            }];
        }
    } else if (data.type == HMTHomepageDataTypeForecast) {
        HMTForecast *forecast = [HMTLocalDataStorage sharedStorage].forecastList.firstObject;
        NSString *url = forecast.url;
        if (url.length > 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
                
            }];
        } else {
            NSString *url = nil;
            if ([@"b" isEqualToString:forecast.platform]) {
                url = @"https://live.bilibili.com/21547895";
            }
            if (url.length > 0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }
        }
    }
}

#pragma mark - HMTHomepageSiteLinkCellDelegate

- (void)onClickTwitter {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/hanamaruhareru"] options:@{} completionHandler:^(BOOL success) {
        
    }];
}

- (void)onClickYoutube {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/channel/UCyIcOCH-VWaRKH9IkR8hz7Q"] options:@{} completionHandler:^(BOOL success) {
        
    }];
}

- (void)onClickBilibili {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://space.bilibili.com/441381282"] options:@{} completionHandler:^(BOOL success) {
        
    }];
}

- (void)onClickFanbox {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://hanamaruhareru.fanbox.cc"] options:@{} completionHandler:^(BOOL success) {
        
    }];
}

#pragma mark - HMTHomepageVideoCellDelegate

- (void)onClickVideoList:(HMTVideo *)video {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HMTSongListDetailViewController *songList = [storyboard instantiateViewControllerWithIdentifier:@"songListDetail"];
    songList.title = NSLocalizedString(@"songListDetail", nil);
    songList.date = video.date;
    
    [self.navigationController pushViewController:songList animated:YES];
    
}

#pragma mark - HMTHomepageBannerCellDelegate

- (void)didClickBanner:(HMTSlide *)slide {
    
    
    
    NSString *url = nil;
    if (slide.url.length > 0) {
        url = slide.url;
    } else {
        if (slide.youtube_url.length > 0 && slide.bilibili_url.length > 0) {
            //
            NSString *lang = [HMTAppUtils getCurrentLanguage];
            if ([@"zh" isEqualToString:lang]) {
                url = slide.bilibili_url;
            } else {
                url = slide.youtube_url;
            }
        } else if (slide.bilibili_url.length > 0) {
            url = slide.bilibili_url;
        } else if (slide.youtube_url.length > 0) {
            url = slide.youtube_url;
        }
    }
    if (url) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    if (searchText.length == 0) {
        self.searchActive = NO;
        
    } else {
        self.searchActive = YES;
        self.searchArray = [[HMTLocalDataStorage sharedStorage].videoList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title CONTAINS %@ OR date CONTAINS %@", searchText, searchText]];
    }
    
    [self.tableView reloadData];
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
