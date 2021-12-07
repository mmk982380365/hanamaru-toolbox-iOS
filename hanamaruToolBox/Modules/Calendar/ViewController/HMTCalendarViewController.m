//
//  HMTCalendarViewController.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import "HMTCalendarViewController.h"
#import "HMTAppUtils.h"
#import "HMTLocalDataStorage.h"
#import "HMTColorThemes.h"
#import "HMTCalendarDetailCell.h"

#import <JTCalendar/JTCalendar.h>
#import <Masonry/Masonry.h>

@interface HMTCalendarViewController () <JTCalendarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSDateFormatter *dateFormat;

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (strong, nonatomic) NSDate *selectedDate;

@end

@implementation HMTCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"calendar", nil);
    
    self.selectedDate = [NSDate date];
    
    self.dateFormat = [[NSDateFormatter alloc] init];
    self.dateFormat.dateFormat = @"yyyy-MM-dd";
    
    
    self.calendarManager = [[JTCalendarManager alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:[HMTAppUtils getCurrentLanguage]] andTimeZone:[NSTimeZone systemTimeZone]];
    self.calendarManager.delegate = self;
    self.calendarManager.menuView = self.calendarMenuView;
    self.calendarManager.contentView = self.calendarContentView;
    self.calendarManager.date = self.selectedDate;
    
    [self.tableView reloadData];
}

#pragma mark - JTCalendarDelegate

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView {
    dayView.hidden = NO;
    if (dayView.isFromAnotherMonth) {
        dayView.hidden = YES;
    }
    
    NSString *dateString = [self.dateFormat stringFromDate:dayView.date];
    NSArray *forecasts = [HMTLocalDataStorage sharedStorage].mappedForecastList[dateString];
    if (forecasts && forecasts.count > 0) {
        HMTForecast *forecast = forecasts.firstObject;
        if ([@"b" isEqualToString:forecast.platform]) {
            dayView.dotView.backgroundColor = [HMTColorThemes bilibiliColor];
        } else {
            dayView.dotView.backgroundColor = [HMTColorThemes youtubeColor];
        }
        
        dayView.dotView.hidden = NO;
    } else {
        dayView.dotView.hidden = YES;
    }
    
    if (self.selectedDate && [self.calendarManager.dateHelper date:self.selectedDate isTheSameDayThan:dayView.date]) {
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [HMTColorThemes primaryColor];
    } else {
        dayView.circleView.hidden = YES;
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView {
    
    self.selectedDate = dayView.date;
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
        dayView.circleView.transform = CGAffineTransformIdentity;
        [self.calendarManager reload];
        [self.tableView reloadData];
    } completion:nil];
    
    // Load the previous or next page if touch a day from another month
    if(![self.calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([self.calendarManager.date compare:dayView.date] == NSOrderedAscending){
            [self.calendarContentView loadNextPageWithAnimation];
        }
        else{
            [self.calendarContentView loadPreviousPageWithAnimation];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HMTCalendarDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *dateString = [self.dateFormat stringFromDate:self.selectedDate];
    NSArray *forecasts = [HMTLocalDataStorage sharedStorage].mappedForecastList[dateString];
    cell.forecast = forecasts[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *dateString = [self.dateFormat stringFromDate:self.selectedDate];
    NSArray *forecasts = [HMTLocalDataStorage sharedStorage].mappedForecastList[dateString];
    
    return forecasts.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *dateString = [self.dateFormat stringFromDate:self.selectedDate];
    NSArray *forecasts = [HMTLocalDataStorage sharedStorage].mappedForecastList[dateString];
    HMTForecast *forecast = forecasts[indexPath.row];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
