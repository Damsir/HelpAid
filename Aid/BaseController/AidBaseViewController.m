//
//  AidBaseViewController.m
//  Aid
//
//  Created by 张丽 on 15/10/10.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import "AidBaseViewController.h"

@interface AidBaseViewController ()

@end

@implementation AidBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initTableView
{
    self.aidBaseTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DEVICE_W, DEVICE_H-64) style:UITableViewStylePlain];
    self.aidBaseTableV.dataSource = self;
    self.aidBaseTableV.delegate = self;
    [self.view addSubview:self.aidBaseTableV];
    
    [self.aidBaseTableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"base"];
}
#pragma mark -tableView的协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base"];
    return cell;
}

#pragma mark -关于加载的方法
-(void)headerRefresh
{}
-(void)footerLoadMore
{}

- (void)show
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)hidden
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
