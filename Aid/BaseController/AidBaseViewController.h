//
//  AidBaseViewController.h
//  Aid
//
//  Created by 张丽 on 15/10/10.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJRefresh.h"
#import "MBProgressHUD.h"

//controller
#import "AidBaseDetailViewController.h"

@interface AidBaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *aidBaseTableV;


//下拉刷新
-(void)headerRefresh;
//上拉加载更多
-(void)footerLoadMore;

//显示或者隐藏小菊花
-(void)show;
-(void)hidden;

@end
