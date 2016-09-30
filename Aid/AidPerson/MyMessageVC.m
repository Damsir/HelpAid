//
//  MyMessageVC.m
//  Aid
//
//  Created by 张丽 on 15/10/14.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import "MyMessageVC.h"
#import "AIdBaseBarManager.h"




@interface MyMessageVC ()
{

}
@end

@implementation MyMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self loadData];
}
-(void)initUI
{
    self.navigationItem.titleView = [AIdBaseBarManager setNavigationItemTitleViewWith:self.titleName];
}
#pragma mark -加载数据
-(void)loadData
{
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
