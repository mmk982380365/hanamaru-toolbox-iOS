//
//  HMTTabBarController.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import "HMTTabBarController.h"

@interface HMTTabBarController ()

@end

@implementation HMTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = [UIColor systemBackgroundColor];
    
    self.tabBar.standardAppearance = appearance;
    if (@available(iOS 15.0, *)) {
        self.tabBar.scrollEdgeAppearance = appearance;
    } else {
        // Fallback on earlier versions
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
