//
//  HMTNavigationController.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import "HMTNavigationController.h"
#import "HMTColorThemes.h"

@interface HMTNavigationController ()

@end

@implementation HMTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = [HMTColorThemes primaryColor];
    
    self.navigationBar.standardAppearance = appearance;
//    self.navigationBar.scrollEdgeAppearance = appearance;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
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
