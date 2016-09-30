//
//  MyCollectVC.m
//  Aid
//
//  Created by 张丽 on 15/10/14.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import "MyCollectVC.h"
#import "AIdBaseBarManager.h"
#import "FMDatabase.h"
#import "CollectDataModel.h"

//controller

#import "AidBaseDetailViewController.h"


#import "AIdPersonViewController.h"

@interface MyCollectVC ()
{
    NSString *savePath;
    NSMutableArray *dataArray;
}
@end

@implementation MyCollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [NSMutableArray array];
    [self initUI];
    [self loadData];
}
-(void)initUI
{
    self.navigationItem.titleView = [AIdBaseBarManager setNavigationItemTitleViewWith:self.titleName];
    [self initTableView];
}
#pragma mark -从沙盒目录下面获取数据
-(void)loadData
{
    savePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/AIDApp.db"];
    NSString *sql =@"SELECT *FROM AidDeatailTables WHERE id >0";
    FMDatabase *dataBase = [FMDatabase databaseWithPath:savePath];
    if ([dataBase open])
    {
        //        查询语句查询到的是一个集合
        FMResultSet *set = [dataBase executeQuery:sql];
        //        遍历查询到的结果集合
        while ([set next])
        {
            NSString *webID = [set stringForColumn:@"webUrlId"];
            NSString *imageUrl = [set stringForColumn:@"imageUrl"];
            NSString *webUrl = [set stringForColumn:@"webUrl"];
            NSString *categoryName = [set stringForColumn:@"categoryName"];
            NSString *titleName = [set stringForColumn:@"titleName"];
//            NSLog(@"ID=%@ name=%@ age=%@",webID,imageUrl,webUrl);
            CollectDataModel *infoModel = [[CollectDataModel alloc] init];
            infoModel.webID = webID;
            infoModel.imageUrl = imageUrl;
            infoModel.webUrl = webUrl;
            infoModel.categoryName = categoryName;
            infoModel.titleName = titleName;
            [dataArray addObject:infoModel];
            
        }
    }
    else
    {

    }
    [dataBase close];
    if (dataArray.count==0)
    {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"暂时没有收藏哦" message:@"赶紧去阅读收藏吧" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *  action) {
            
            AIdPersonViewController *personVC = [[AIdPersonViewController alloc] init];
            [self.navigationController pushViewController:personVC animated:YES];
            
        }];
        [alter addAction:cancel];
        [self presentViewController:alter animated:YES completion:^{
            
        }];
    }
    [self.aidBaseTableV reloadData];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -tableView
-(void)initTableView
{
    self.aidBaseTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DEVICE_W, DEVICE_H-64) style:UITableViewStylePlain];
    self.aidBaseTableV.dataSource = self;
    self.aidBaseTableV.delegate = self;
    [self.view addSubview:self.aidBaseTableV];
    self.aidBaseTableV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self registerTableViewCell];
    
    
}
-(void)registerTableViewCell
{
    [self.aidBaseTableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"base"];
}
#pragma mark -tableView协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArray.count>0)
    {
        return dataArray.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base"];
    if (dataArray.count>indexPath.row)
    {
        CollectDataModel *infoModel = dataArray[indexPath.row];
        cell.textLabel.text = infoModel.titleName;
    }

//    cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataArray.count>indexPath.row)
    {
        AidBaseDetailViewController *detailVC = [[AidBaseDetailViewController alloc] init];
        CollectDataModel *infoModel = dataArray[indexPath.row];
        detailVC.webUrlId = infoModel.webID;
        if (infoModel.imageUrl)
        {
            detailVC.imageUrl= infoModel.imageUrl;
        }
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
}
//这个函数调用了之后，cell可以左滑出现删除按钮，并且删除的事件在这个方法中响应
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    /**************先删数据后删cell****************/

    //    删除数据库里面的数据
    FMDatabase *dataBase = [FMDatabase databaseWithPath:savePath];
    
    CollectDataModel *infoModel = dataArray[indexPath.row];
    NSString *webID = infoModel.webID;
    NSLog(@"%@",webID);
    NSString *sql = @"DELETE FROM AidDeatailTables WHERE webUrlId = ?;";
    
    if ([dataBase open])
    {
        [dataBase executeUpdate:sql,webID];
    }
    else
    {
        NSLog(@"数据库打开失败");
    }
    [dataBase close];

    [dataArray removeAllObjects] ;
    
    [self loadData];
    [self.aidBaseTableV reloadData];
    

    
    
}

//返回NO，对cell的操作都将失效
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES ;
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
