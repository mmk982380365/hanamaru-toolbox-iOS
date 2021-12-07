//
//  HMTSongListDetailViewController.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/5.
//

#import "HMTSongListDetailViewController.h"
#import "HMTLocalDataStorage.h"
#import "HMTPicker.h"
#import "HMTSongListDetailCell.h"
#import "HMTSongDetailViewController.h"

@interface HMTSongListDetailViewController () <UITableViewDelegate, UITableViewDataSource, HMTSongListDetailCellDelegate>

@property (weak, nonatomic) IBOutlet UIButton *dateBtn;

@property (strong, nonatomic) HMTSongList *currentList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *platformLogoImageView;

@end

@implementation HMTSongListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [HMTLocalDataStorage sharedStorage].songList.firstObject.date
    
    
    if (self.date) {
        NSInteger index = [[[HMTLocalDataStorage sharedStorage].songList valueForKeyPath:@"date"] indexOfObject:self.date];
        if (index != NSNotFound) {
            self.currentList = [HMTLocalDataStorage sharedStorage].songList[index];
        } else {
            self.currentList = [HMTLocalDataStorage sharedStorage].songList.firstObject;
        }
        [self.dateBtn setTitle:self.currentList.date forState:UIControlStateNormal];
        self.titleLabel.text = self.currentList.title;
        self.timeLabel.text = self.currentList.date;
        if (self.currentList.url_y.length > 0) {
            self.platformLogoImageView.image = [UIImage imageNamed:@"icon_youtube"];
        } else {
            self.platformLogoImageView.image = [UIImage imageNamed:@"icon_bilibili"];
        }
    } else {
        self.currentList = [HMTLocalDataStorage sharedStorage].songList.firstObject;
    }
    
    
    
}

- (void)scrollToIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        [cell performSelectorOnMainThread:@selector(flash) withObject:nil waitUntilDone:YES];
    });
}

#pragma mark - Event

- (IBAction)onClickDate:(id)sender {
    HMTPicker *picker = [[HMTPicker alloc] initWithType:HMTPickerViewTypeStringArray];
    picker.dataArray = [[HMTLocalDataStorage sharedStorage].songList valueForKeyPath:@"date"];
    picker.dataSelectIndex = [[HMTLocalDataStorage sharedStorage].songList indexOfObject:self.currentList];
    picker.confirmCallback = ^(id  _Nullable data) {
        self.currentList = [HMTLocalDataStorage sharedStorage].songList[[data integerValue]];
    };
    [picker show];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HMTSongListDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    HMTSongListSong *song = self.currentList.songs_list[indexPath.row];
    cell.detailBtn.hidden = self.currentList.songs_list[indexPath.row].isMedleyTitle;
    cell.titleLabel.text = [NSString stringWithFormat:@"%@(%@)", song.name, song.timestamp];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentList.songs_list.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *time = self.currentList.timestamps[indexPath.row];
    
    NSArray *array = [time componentsSeparatedByString:@":"];
    int timestamp = 0;
    int index = 0;
    for (NSString *time in array.reverseObjectEnumerator) {
        timestamp += time.integerValue * pow(60, index);
        index++;
    }
    
    NSURLComponents *components = nil;
    if (self.currentList.url_y.length > 0) {
        components = [NSURLComponents componentsWithString:self.currentList.url_y];
        NSMutableArray *queryItems = [components.queryItems mutableCopy];
        if (!queryItems) {
            queryItems = [NSMutableArray array];
        }
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"t" value:[NSString stringWithFormat:@"%d", timestamp]]];
        components.queryItems = queryItems;
    } else {
        components = [NSURLComponents componentsWithString:self.currentList.url_b];
        NSMutableArray *queryItems = [components.queryItems mutableCopy];
        if (!queryItems) {
            queryItems = [NSMutableArray array];
        }
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"t" value:[NSString stringWithFormat:@"%d", timestamp]]];
        components.queryItems = queryItems;
    }
    if (components) {
        [[UIApplication sharedApplication] openURL:components.URL options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
    
}

#pragma mark - HMTSongListDetailCellDelegate

- (void)onClickDetail:(NSIndexPath *)indexPath {
    HMTSongListSong *song = self.currentList.songs_list[indexPath.row];
    
    HMTSongStatistic *statistic = nil;
    if (song.isMedley) {
        NSArray *array = [[HMTLocalDataStorage sharedStorage].mappedMedleyStatistic filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", [song.name stringByReplacingOccurrencesOfString:@"\t" withString:@""]]];
        statistic = array.firstObject;
    } else {
        NSArray *array = [[HMTLocalDataStorage sharedStorage].mappedSongStatistic filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", song.name]];
        statistic = array.firstObject;
    }
    if (statistic) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HMTSongDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"songDetail"];
        vc.songStatistic = statistic;
        [self.navigationController pushViewController:vc animated:YES];
    }
    

}

#pragma mark - Setter

- (void)setDate:(NSString *)date {
    if (_date != date) {
        _date = date;
        if (date) {
            NSInteger index = [[[HMTLocalDataStorage sharedStorage].songList valueForKeyPath:@"date"] indexOfObject:date];
            if (index != NSNotFound) {
                self.currentList = [HMTLocalDataStorage sharedStorage].songList[index];
            } else {
                self.currentList = [HMTLocalDataStorage sharedStorage].songList.firstObject;
            }
        } else {
            self.currentList = [HMTLocalDataStorage sharedStorage].songList.firstObject;
        }
    }
}

- (void)setCurrentList:(HMTSongList *)currentList {
    if (_currentList != currentList) {
        _currentList = currentList;
        [self.dateBtn setTitle:currentList.date forState:UIControlStateNormal];
        [self.tableView reloadData];
        self.titleLabel.text = currentList.title;
        self.timeLabel.text = currentList.date;
        if (currentList.url_y.length > 0) {
            self.platformLogoImageView.image = [UIImage imageNamed:@"icon_youtube"];
        } else {
            self.platformLogoImageView.image = [UIImage imageNamed:@"icon_bilibili"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView setContentOffset:CGPointZero animated:NO];
        });
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
