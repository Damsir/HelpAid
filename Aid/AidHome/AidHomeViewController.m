//
//  AidHomeViewController.m
//  Aid
//
//  Created by 张丽 on 15/10/10.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import "AidHomeViewController.h"
#import "AidHomeManagerModel.h"

//model
#import "AidHomeDataModel.h"

#import "AidHomeTableViewCell.h"
#import "AidNoImgTableViewCell.h"





@interface AidHomeViewController ()
{
    AidHomeManagerModel *managerModel;
    
    UISegmentedControl *sectionSegment;
    NSString *secStr1;
    NSString *secStr2;
    
}
@end

@implementation AidHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    managerModel = [[AidHomeManagerModel alloc] init];
    secStr1 = [[NSString alloc] init];
    secStr2 = [[NSString alloc] init];
    [self loadData];
    [self initUI];
}
#pragma mark -获取网络数据
-(void)loadData
{
    [self show];
    __weak typeof(*&self)weakSelf = self;
    
    [managerModel loadHomeDataInfo:^(BOOL isSuccess, NSError *error) {
        
        if (isSuccess)
        {
            [weakSelf.aidBaseTableV headerEndRefreshing];
            [weakSelf.aidBaseTableV reloadData];
            [weakSelf hidden];
        }
        else
        {
            [weakSelf initErrorView];
            [weakSelf hidden];
        }

    }];
}
//当没网的时候提示
-(void)initErrorView
{
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络出错咯" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        
    }];
    [alterController addAction:sure];
    
    [self presentViewController:alterController animated:YES completion:^{
        
    }];
}



#pragma mark -创建视图
-(void)initUI
{
    [self initSegmentController];
    
    [self initTableView];
   
   
}
-(void)initTableView
{
    self.aidBaseTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DEVICE_W, DEVICE_H-64-49)];
   
    self.aidBaseTableV.dataSource = self;
    self.aidBaseTableV.delegate = self;
    [self.view addSubview:self.aidBaseTableV];
    
//    给tableView添加下拉刷新方法
    [self.aidBaseTableV addHeaderWithTarget:self action:@selector(headerRefresh)];
 
    [self registerTableViewCell];
    
    //添加左滑手势
    UISwipeGestureRecognizer * swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)] ;
    //设置左滑方式
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft ;
    
    [self.aidBaseTableV addGestureRecognizer:swipeLeft] ;
    
    //添加右滑手势
    UISwipeGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)] ;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight ;
    //这种添加只是告诉view你有滑动手势，并没有执行方法
    [self.aidBaseTableV addGestureRecognizer:swipeRight] ;

}
#pragma mark -手势方法
//左划
-(void)swipeLeft:(UISwipeGestureRecognizer *)swipe
{

    if (sectionSegment.selectedSegmentIndex==0)
    {
        sectionSegment.selectedSegmentIndex=1;
        [self.aidBaseTableV reloadData];

    }
    
}
-(void)swipeRight:(UISwipeGestureRecognizer *)swipe
{

    if (sectionSegment.selectedSegmentIndex==1)
    {
        sectionSegment.selectedSegmentIndex=0;
        [self.aidBaseTableV reloadData];
        
    }
}
//下拉刷新
-(void)headerRefresh
{
    [self loadData];
}

-(void)registerTableViewCell
{
    [self.aidBaseTableV registerClass:[AidHomeTableViewCell class] forCellReuseIdentifier:@"AidHomeTableViewCell"];
    [self.aidBaseTableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"base"];
    [self.aidBaseTableV registerClass:[AidNoImgTableViewCell class] forCellReuseIdentifier:@"AidNoImgTableViewCell"];
}
-(void)initSegmentController
{
    NSArray *items = @[@"图文推荐",@"精选推荐"];
    secStr1 = @"图文推荐";
    secStr2 = @"精选推荐";
    sectionSegment = [[UISegmentedControl alloc] initWithItems:items];
    sectionSegment.frame = CGRectMake(0, 64, DEVICE_W/3.0, 35);
    [sectionSegment addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    sectionSegment.tintColor = [UIColor whiteColor];
    sectionSegment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = sectionSegment;
}
-(void)valueChange:(UISegmentedControl *)segment
{
    [self.aidBaseTableV reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -重写父类的tableview协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (managerModel.homeDataArray.count != 0)
    {
        AidHomeDataModel *homeDataModel = [managerModel.homeDataArray objectAtIndex:0];
        return homeDataModel.list.count;
    }
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (managerModel.homeDataArray.count>0)
    {
        if (sectionSegment.selectedSegmentIndex== 0)
        {
            AidHomeDataModel *homeDataModel = managerModel.homeDataArray[0];
            
            if (homeDataModel.list.count>indexPath.row)
            {
                AidHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AidHomeTableViewCell"];
                //    cell.backgroundColor = [UIColor purpleColor];
                AidHomeInfoModel *infoModel = homeDataModel.list[indexPath.row];
                [cell setUIWithDataInfo:infoModel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            return cell;
        }
        else
        {
            AidHomeDataModel *homeDataModel = managerModel.homeDataArray[1];
            
            if (homeDataModel.list.count>indexPath.row)
            {
                AidNoImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AidNoImgTableViewCell"];

                //    cell.backgroundColor = [UIColor purpleColor];
                AidHomeInfoModel *infoModel = homeDataModel.list[indexPath.row];
                [cell setUIWithDataInfo:infoModel];
                return cell;
            }
            return cell;
        }
    }
    
    return cell;
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (sectionSegment.selectedSegmentIndex == 0)
    {
        return 240.0;
    }
    else
    {
        return 85.0;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AidBaseDetailViewController *detailVC = [[AidBaseDetailViewController alloc] init];
    
    if (managerModel.homeDataArray.count>0)
    {
        if (sectionSegment.selectedSegmentIndex== 0)
        {
            AidHomeDataModel *homeDataModel = managerModel.homeDataArray[0];
            
            if (homeDataModel.list.count>indexPath.row)
            {
              
                AidHomeInfoModel *infoModel = homeDataModel.list[indexPath.row];
                if (infoModel.thumb.length != 0)
                {
                    detailVC.imageUrl = infoModel.thumb;
                }
                
                detailVC.categoryName = infoModel.subcatename;
                detailVC.titleName = infoModel.title;
                detailVC.webUrlId = infoModel.ID;
            }
        }
        else
        {
            AidHomeDataModel *homeDataModel = managerModel.homeDataArray[1];
            
            if (homeDataModel.list.count>indexPath.row)
            {
            AidHomeInfoModel *infoModel = homeDataModel.list[indexPath.row];
                if (infoModel.thumb.length != 0)
                {
                    detailVC.imageUrl = infoModel.thumb;
                }
                detailVC.categoryName = infoModel.subcatename;
                detailVC.titleName = infoModel.title;
                detailVC.webUrlId = infoModel.ID;
            }
        }
    }
//    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];

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
