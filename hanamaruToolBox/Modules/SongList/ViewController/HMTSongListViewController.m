//
//  HMTSongListViewController.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/5.
//

#import "HMTSongListViewController.h"
#import "HMTSectionView.h"
#import "HMTSongListPreviewViewController.h"
#import "HMTSongDetailViewController.h"
#import "HMTSongListDetailViewController.h"
#import "HMTLocalDataStorage.h"

#import <Masonry/Masonry.h>

@interface HMTSongListViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (assign, nonatomic) NSInteger currentIndex;

@property (weak, nonatomic) IBOutlet HMTSectionView *sectionView;

@property (weak, nonatomic) IBOutlet UIView *pageContainerView;

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) NSArray<UIViewController *> *viewControllers;

@end

@implementation HMTSongListViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"songList", nil);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveSongList:) name:HMTSongDetailViewControllerShowSongList object:nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *songList = [storyboard instantiateViewControllerWithIdentifier:@"songListDetail"];
    songList.title = NSLocalizedString(@"songListDetail", nil);
    
    HMTSongListPreviewViewController *songPreview = [storyboard instantiateViewControllerWithIdentifier:@"songListPreview"];
    songPreview.title = NSLocalizedString(@"songListPreview", nil);
    
    HMTSongListPreviewViewController *skewers = [storyboard instantiateViewControllerWithIdentifier:@"songListPreview"];
    skewers.isMedley = YES;
    skewers.title = NSLocalizedString(@"skewers", nil);
    
    HMTSongListPreviewViewController *all = [storyboard instantiateViewControllerWithIdentifier:@"songListPreview"];
    all.isAll = YES;
    all.title = NSLocalizedString(@"songListAll", nil);
    
    UIViewController *analytics = [storyboard instantiateViewControllerWithIdentifier:@"analytics"];
    analytics.title = NSLocalizedString(@"analytics", nil);
    
    self.viewControllers = @[
        songList,
        songPreview,
        skewers,
        all,
        analytics
    ];
    
    self.sectionView.items = [self.viewControllers valueForKeyPath:@"title"];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self addChildViewController:self.pageViewController];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self.pageContainerView addSubview:self.pageViewController.view];
    
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.pageContainerView);
    }];
    
    [self.pageViewController setViewControllers:@[self.viewControllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - Event

- (IBAction)onChangeSection:(id)sender {
    if (self.currentIndex != self.sectionView.selectedIndex) {
        self.sectionView.isAnimated = YES;
        BOOL isForward = self.currentIndex < self.sectionView.selectedIndex;
        self.currentIndex = self.sectionView.selectedIndex;
        
        UIViewController *vc = self.viewControllers[self.currentIndex];
        __weak typeof(self) ws = self;
        [self.pageViewController setViewControllers:@[vc] direction:isForward ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
            __strong typeof(ws) self = ws;
            self.sectionView.isAnimated = NO;
        }];
    }
    
}

- (void)onReceiveSongList:(NSNotification *)notification {
    [self.pageViewController setViewControllers:@[self.viewControllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        
    }];
    
    NSString *date = notification.userInfo[@"date"];
    NSString *name = notification.userInfo[@"name"];
    
    NSInteger index = [[[HMTLocalDataStorage sharedStorage].songList valueForKeyPath:@"date"] indexOfObject:date];
    if (index != NSNotFound) {
        HMTSongList *list = [HMTLocalDataStorage sharedStorage].songList[index];
        
        self.currentIndex = 0;
        self.sectionView.selectedIndex = 0;
        HMTSongListDetailViewController *vc = (HMTSongListDetailViewController *)self.viewControllers.firstObject;
        vc.date = date;
        
        NSInteger indexOfSong = NSNotFound;
        for (int i = 0; i < list.songs.count; i++) {
            NSString *song = list.songs[i];
            if ([song containsString:name]) {
                indexOfSong = i;
                break;;
            }
        }
        
        
        if (indexOfSong != NSNotFound) {
            [vc scrollToIndex:indexOfSong];
        }
        
    }
    
    
}

#pragma mark - UIPageViewControllerDelegate, UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    
    UIViewController *vc = [self.viewControllers objectAtIndex:index - 1];
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    if (index == NSNotFound || index + 1 >= self.viewControllers.count) {
        return nil;
    }
    UIViewController *vc = [self.viewControllers objectAtIndex:index + 1];
    return vc;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    self.currentIndex = [self.viewControllers indexOfObject:pageViewController.viewControllers.firstObject];
    self.sectionView.selectedIndex = self.currentIndex;
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
