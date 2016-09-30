//
//  AidTabBarController.m
//  Aid
//
//  Created by 张丽 on 15/10/10.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import "AidTabBarController.h"

@interface AidTabBarController ()

@end

@implementation AidTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.tintColor = AID_BASE_COLOR;
    self.tabBar.translucent = NO;
    NSArray *itemTitles = @[@"首页",@"分类",@"个人",@"附近医院"];
    NSArray *itemImages = @[@"tab_home",@"gonglue_1",@"tab_user",@"topic_off"];
    int i=0;
    for (UINavigationController *navi in self.viewControllers)
    {
        navi.tabBarItem = [[UITabBarItem alloc] initWithTitle:itemTitles[i] image:[UIImage imageNamed:itemImages[i]] selectedImage:nil];
        i++;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
