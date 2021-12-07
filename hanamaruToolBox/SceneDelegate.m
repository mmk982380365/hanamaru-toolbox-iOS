//
//  SceneDelegate.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import "SceneDelegate.h"
#import "HMTSliderViewController.h"
#import "UIViewController+HMT_Slider.h"
#import "HMTLocalDataStorage.h"
#import "HMTAppUtils.h"

@interface SceneDelegate ()

@property (strong, nonatomic) HMTSliderViewController *sliderViewController;

@property (strong, nonatomic) UIViewController *splashViewController;

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    if ([self.window.rootViewController isKindOfClass:HMTSliderViewController.class]) {
        self.sliderViewController = (HMTSliderViewController *)self.window.rootViewController;
    }
    
    if (self.sliderViewController.viewControllers.count == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *homepage = [storyboard instantiateViewControllerWithIdentifier:@"homePage"];
        homepage.hmt_sliderItem = [[HMTSliderItem alloc] initWithName:NSLocalizedString(@"live", nil)];
        UIViewController *calendar = [storyboard instantiateViewControllerWithIdentifier:@"calendar"];
        calendar.hmt_sliderItem = [[HMTSliderItem alloc] initWithName:NSLocalizedString(@"calendar", nil)];
        UIViewController *singleSong = [storyboard instantiateViewControllerWithIdentifier:@"singleSong"];
        singleSong.hmt_sliderItem = [HMTSliderItem itemWithName:NSLocalizedString(@"singleSong", nil)];
        UIViewController *songList = [storyboard instantiateViewControllerWithIdentifier:@"songList"];
        songList.hmt_sliderItem = [HMTSliderItem itemWithName:NSLocalizedString(@"songList", nil)];
        UIViewController *misc = [storyboard instantiateViewControllerWithIdentifier:@"misc"];
        misc.hmt_sliderItem = [HMTSliderItem itemWithName:NSLocalizedString(@"misc", nil)];
        UIViewController *settings = [storyboard instantiateViewControllerWithIdentifier:@"settings"];
        settings.hmt_sliderItem = [HMTSliderItem itemWithName:NSLocalizedString(@"about", nil)];
        
        self.sliderViewController.viewControllers = @[
            homepage,
            calendar,
            singleSong,
            songList,
            misc,
            settings
        ];
    }
    
    [self.window makeKeyAndVisible];
    
    self.splashViewController = [HMTAppUtils launchViewController];
    [self.window addSubview:self.splashViewController.view];
    
    [[HMTLocalDataStorage sharedStorage] loadData:^{
        [self.splashViewController.view removeFromSuperview];
        self.splashViewController = nil;
        
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.25;
        [self.window.layer addAnimation:animation forKey:@""];
        
    }];
    
    
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
