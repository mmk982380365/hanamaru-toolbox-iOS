//
//  HMTSettingViewController.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import "HMTSettingViewController.h"
#import "HMTColorThemes.h"
#import "HMTAppUtils.h"

#import <Masonry/Masonry.h>

@interface HMTSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIView *tableBackgroundView;

@property (strong, nonatomic) UILabel *versionLabel;

@property (strong, nonatomic) UILabel *greetingLabel;

@end

@implementation HMTSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"about", nil);
    
    self.tableBackgroundView = [[UIView alloc] init];
    self.tableView.backgroundView = self.tableBackgroundView;
    
    self.versionLabel = [[UILabel alloc] init];
    self.versionLabel.text = [NSString stringWithFormat:@"v:%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    self.versionLabel.textColor = [HMTColorThemes textGrayColor];
    self.versionLabel.font = [UIFont systemFontOfSize:14];
    [self.tableBackgroundView addSubview:self.versionLabel];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.centerX.equalTo(self.tableView);
    }];
    
    if ([@"ja" isEqualToString:[HMTAppUtils getCurrentLanguage]]) {
        self.greetingLabel = [[UILabel alloc] init];
        self.greetingLabel.text = @"はれちゃんがずっと幸せでいられますように。";
        self.greetingLabel.textColor = [HMTColorThemes textGrayColor];
        self.greetingLabel.font = [UIFont systemFontOfSize:14];
        [self.tableBackgroundView addSubview:self.greetingLabel];
        
        [self.greetingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.tableView);
            make.bottom.equalTo(self.versionLabel.mas_top).offset(-8);
        }];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Booth";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Pixiv FANBOX";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Twitter";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Youtube";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Bilibili";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"scheduleTitle", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"streamRoomTitle", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 3;
    } else if (section == 2) {
        return 2;
    }
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://hanamaruhareru.booth.pm/"] options:@{} completionHandler:^(BOOL success) {
                
            }];
        } else if (indexPath.row == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://hanamaruhareru.fanbox.cc/"] options:@{} completionHandler:^(BOOL success) {
                
            }];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/hanamaruhareru"] options:@{} completionHandler:^(BOOL success) {
                
            }];
        } else if (indexPath.row == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/channel/UCyIcOCH-VWaRKH9IkR8hz7Q"] options:@{} completionHandler:^(BOOL success) {
                
            }];
        } else if (indexPath.row == 2) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://space.bilibili.com/441381282"] options:@{} completionHandler:^(BOOL success) {
                
            }];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://live.bilibili.com/p/html/live-web-calendar/index.html#/search?id=441381282"] options:@{} completionHandler:^(BOOL success) {
                
            }];
        } else if (indexPath.row == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://live.bilibili.com/21547895"] options:@{} completionHandler:^(BOOL success) {
                
            }];
        }
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"storeTitle", nil);
    } else if (section == 1) {
        return NSLocalizedString(@"channelTitle", nil);
    } else if (section == 2) {
        return NSLocalizedString(@"liveRoomTitle", nil);
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
