//
//  AidCategoryViewController.m
//  Aid
//
//  Created by 张丽 on 15/10/10.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import "AidCategoryViewController.h"


//model
#import "AidCategManagerModel.h"


//cell

#import "AidHomeTableViewCell.h"
#import "AidNoImgTableViewCell.h"

@interface AidCategoryViewController ()<UISearchBarDelegate>
{
    AidCategManagerModel *catemanagerModel;
    
    UITableView *categoryTableV;
    
    NSString *subCategName;
    // 是否显示
    BOOL isShowLeftTableView;
    
    //    定义一个全局变量
//    UISearchDisplayController *displayController;
    
    NSMutableArray *resultArray;
    
    BOOL isSearchStatus; //标记是否在搜索状态
    UISearchBar *aidSearchBar;
   
}
@end

@implementation AidCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    catemanagerModel = [[AidCategManagerModel alloc] init];
//    初始化放结果的数组
    resultArray = [NSMutableArray array];
    
    subCategName = [[NSString alloc] init];
    
    subCategName = @"日常急救";
    
    [self loadDataWithTitle:subCategName];
    [self loadCategoryListData];
    [self initUI];
    
}


-(void)loadCategoryListData
{
    [catemanagerModel loadCategoryListData:^(BOOL isSuccess, NSError *error) {
        if (isSuccess)
        {
            [categoryTableV reloadData];
        }
        else
        {
        }
    }];
}

#pragma mark -加载网络数据
-(void)loadDataWithTitle:(NSString *)title
{
    [self show];
    __weak typeof( *&self)weakSelf = self;
    [catemanagerModel loadCategoryInfo:^(BOOL isSuccess, NSError *error) {
        [weakSelf.aidBaseTableV headerEndRefreshing];
        if (isSuccess)
        {
            [weakSelf.aidBaseTableV reloadData];
        }
        else
        {
        }
        [weakSelf hidden];
    } andWithTitle:title];
}
#pragma mark -刷新数据
-(void)headerRefresh
{
    [self loadDataWithTitle:subCategName];
}
-(void)footerLoadMore
{
    [self show];
    __weak typeof(*&self)weakSelf = self;
    [catemanagerModel loadMoreCategoryInfo:^(BOOL isSuccess, NSError *error) {
        [weakSelf.aidBaseTableV footerEndRefreshing];
        if (isSuccess)
        {
            [weakSelf.aidBaseTableV reloadData];
        }
        else
        {
        }
        [weakSelf hidden];
        
    } andWithTitle:subCategName];
}
#pragma mark -添加视图
-(void)initUI
{
    [self initNavigationBar];
    [self initCategoryTableView];
    [self initBaseTableView];
    [self initSearchBar];
}
#pragma mark -创建一个搜索框
-(void)initSearchBar
{
    aidSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 150, 35)];
    aidSearchBar.searchBarStyle = UISearchBarStyleProminent;
    aidSearchBar.placeholder = @"请输入关键字";
    aidSearchBar.showsCancelButton = YES;
    aidSearchBar.delegate = self;
    self.navigationItem.titleView = aidSearchBar;

}
#pragma mark -UISearchBarDelegat协议方法
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{

}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    收起键盘功能
    [searchBar resignFirstResponder];
    isSearchStatus = YES;
    if (resultArray.count)
    {
        [resultArray removeAllObjects];

    }
    NSString *string = searchBar.text;
    //    剔除空格符
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    if (catemanagerModel.categoryInfoArray.count>0)
    {
        for (AidCategoryInfoModel *infoModel in catemanagerModel.categoryInfoArray)
        {
            NSString *tempStr = infoModel.title;
            
            if ([tempStr rangeOfString:string].location != NSNotFound)
            {
                [resultArray addObject:infoModel];
            }
        }
    }
    [self.aidBaseTableV reloadData];
//    ----------------


}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{

//    收起键盘
    [aidSearchBar resignFirstResponder];
    isSearchStatus = NO;
    [self.aidBaseTableV reloadData];
}

-(void)initNavigationBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list_1"] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBtn)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
-(void)clickLeftBtn
{
    isShowLeftTableView = !isShowLeftTableView;
    [self showOrHideCategoryTableView];
}
-(void)showOrHideCategoryTableView
{
    //    CGRect frame = self.baseTableV.frame;
    CGRect frame = self.aidBaseTableV.frame;
    if (isShowLeftTableView)
    {
        frame.origin.x = 135.0;
    }
    else
    {
        frame.origin.x = 0.0;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.aidBaseTableV.frame = frame;
        
    }];

}
-(void)initCategoryTableView
{
    //    侧边的分类的tableview
    categoryTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 135, DEVICE_H) style:UITableViewStyleGrouped];
    categoryTableV.dataSource = self;
    categoryTableV.delegate = self;
    categoryTableV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:categoryTableV];
    //    注册cell
    [self registerTableViewCell];
    
    

    
}
-(void)initBaseTableView
{
    self.aidBaseTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DEVICE_W, DEVICE_H-64-49) style:UITableViewStylePlain];
    self.aidBaseTableV.dataSource = self;
    self.aidBaseTableV.delegate = self;
    self.aidBaseTableV.layer.borderWidth = 0.5;
    self.aidBaseTableV.layer.borderColor = [UIColor blackColor].CGColor;

    [self.view addSubview:self.aidBaseTableV];
    
//    给tableview添加上拉加载更多，下拉刷新的方法
    [self.aidBaseTableV addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.aidBaseTableV addFooterWithTarget:self action:@selector(footerLoadMore)];
    
    [self registerTableViewCell];
    //添加左滑手势
    UISwipeGestureRecognizer * swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)] ;
    //设置左滑方式
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft ;
    
    [self.aidBaseTableV addGestureRecognizer:swipeLeft] ;
    
    //添加右滑手势
    UISwipeGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)] ;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight ;
    //这种添加只是告诉view你有滑动手势，并没有执行方法
    [self.aidBaseTableV addGestureRecognizer:swipeRight] ;

}
#pragma mark -手势

-(void)swipe:(UISwipeGestureRecognizer *)swipe
{
    [self clickLeftBtn];
}
-(void)registerTableViewCell
{
    [categoryTableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"base"];
    [self.aidBaseTableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"base"];
    
    [self.aidBaseTableV registerClass:[AidHomeTableViewCell class] forCellReuseIdentifier:@"AidHomeTableViewCell"];
    [self.aidBaseTableV registerClass:[AidNoImgTableViewCell class] forCellReuseIdentifier:@"AidNoImgTableViewCell"];

    
}


#pragma mark -tableView协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (categoryTableV == tableView)
    {
        return 4;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (categoryTableV == tableView)
    {
        return 1;
    }
    else if (self.aidBaseTableV == tableView)
    {
        if(isSearchStatus)
        {
            return resultArray.count;
        }
        else
        {
            if (catemanagerModel.categoryInfoArray.count>0)
            {
                return catemanagerModel.categoryInfoArray.count;
            }
            return 10;
        }
        
    }
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (categoryTableV == tableView)
    {
        if (catemanagerModel.categoryListArray.count>indexPath.section)
        {
            AidLeftCategoryModel *infoModel = catemanagerModel.categoryListArray[indexPath.section];
            cell.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.layer.borderWidth = 4;
            cell.layer.cornerRadius = 5;
            cell.clipsToBounds = YES;
            cell.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:30.0/255.0 blue:35.0/255.0 alpha:0.2];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.text = infoModel.title;
        }
    }
    else if (self.aidBaseTableV == tableView)
    {
        if (isSearchStatus)
        {
            AidCategoryInfoModel *infoModel = resultArray[indexPath.row];
            if (infoModel.thumb.length==0)
            {
                AidNoImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AidNoImgTableViewCell"];
                [cell setUIWithCategoryDataInfo:infoModel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else
            {
                AidHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AidHomeTableViewCell"];
                [cell setUIwITHCategoryDataInfo:infoModel];
                
                return cell;
            }
        }
        else
        {
            if (catemanagerModel.categoryInfoArray.count>indexPath.row)
        
            {
                AidCategoryInfoModel *infoModel = catemanagerModel.categoryInfoArray[indexPath.row];
                if (infoModel.thumb.length==0)
                {
                    AidNoImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AidNoImgTableViewCell"];
                    [cell setUIWithCategoryDataInfo:infoModel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else
                {
                    AidHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AidHomeTableViewCell"];
                    [cell setUIwITHCategoryDataInfo:infoModel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (categoryTableV==tableView)
    {
        return 45;
    }
    else if (self.aidBaseTableV == tableView)
    {
        if (isSearchStatus)
        {
            AidCategoryInfoModel *infoModel = resultArray[indexPath.row];
            if (infoModel.thumb.length==0)
            {
                return 85;
            }
            else
            {
                return 240;
            }
        }
        else
        {
            if (catemanagerModel.categoryInfoArray.count>indexPath.row)
                
            {
                AidCategoryInfoModel *infoModel = catemanagerModel.categoryInfoArray[indexPath.row];
                if (infoModel.thumb.length==0)
                {
                    return 85;
                }
                else
                {
                    return 240;
                }
            }
        }
    }
    return 44.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (categoryTableV == tableView)
    {
        if (catemanagerModel.categoryListArray.count>indexPath.section)
        {
        AidLeftCategoryModel *infoModel = catemanagerModel.categoryListArray[indexPath.section];
            
            subCategName = infoModel.title;
            
        [self loadDataWithTitle:infoModel.title];
            
        }
    }
    else if (self.aidBaseTableV == tableView)
    {
        AidBaseDetailViewController *detailVC =[[AidBaseDetailViewController alloc] init];
        
        if (catemanagerModel.categoryInfoArray.count>indexPath.row)
        {
            AidCategoryInfoModel *infoModel = catemanagerModel.categoryInfoArray[indexPath.row];
            if (infoModel.thumb.length != 0)
            {
               detailVC.imageUrl = infoModel.thumb;
            }
            detailVC.categoryName = infoModel.subcatename;
            detailVC.titleName = infoModel.title;
            detailVC.webUrlId = infoModel.ID;
        }
//        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
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
