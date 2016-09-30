//
//  AidCategManagerModel.m
//  Aid
//
//  Created by 张丽 on 15/10/10.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import "AidCategManagerModel.h"

#import "AFNetworking.h"


@implementation AidCategManagerModel


-(instancetype)init
{
    if (self = [super init])
    {
        _categoryInfoArray = [NSMutableArray array];
        _categoryListArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark -获取对应分类的数据
-(void)loadCategoryInfo:(freshInfoList )block andWithTitle:(NSString *)title
{
    [_categoryInfoArray removeAllObjects];
//  siteid=2&catename=%E7%94%9F%E6%B4%BB%E6%80%A5%E6%95%91&subcatename=%E6%97%A5%E5%B8%B8%E6%80%A5%E6%95%91&p=1&pagesize=20
    self.page = 1;
    NSString *pageStr = [NSString stringWithFormat:@"%ld",self.page];
    
    NSDictionary *dict = @{@"siteid":@"2",@"catename":@"生活急救",@"subcatename":title,@"p":pageStr,@"pagesize":@"20"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:AID_CATEGORYLIST_HOST parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        AidCategoryDataModel *categDataModel = [[AidCategoryDataModel alloc] initWithData:operation.responseData error:nil];
        for (AidCategoryInfoModel *infoModel in categDataModel.results)
        {
            [_categoryInfoArray addObject:infoModel];
        }
        
        block(YES,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(NO,error);
    }];
    


}

-(void)loadMoreCategoryInfo:(freshInfoList)block andWithTitle:(NSString *)title
{
    self.page++;
    NSString *pageStr = [NSString stringWithFormat:@"%ld",self.page];
    
    NSDictionary *dict = @{@"siteid":@"2",@"catename":@"生活急救",@"subcatename":title,@"p":pageStr,@"pagesize":@"20"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:AID_CATEGORYLIST_HOST parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        AidCategoryDataModel *categDataModel = [[AidCategoryDataModel alloc] initWithData:operation.responseData error:nil];
        for (AidCategoryInfoModel *infoModel in categDataModel.results)
        {
            [_categoryInfoArray addObject:infoModel];
        }
        
        block(YES,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(NO,error);
    }];

}

#pragma mark -获取列表组名
-(void)loadCategoryListData:(freshInfoList)block
{
//     http://iapi.ipadown.com/api/yangshen/left.category.api.php?
//   siteid=2&catename=%E7%94%9F%E6%B4%BB%E6%80%A5%E6%95%91&type=0
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dict = @{@"siteid":@"2",@"catename":@"生活急救",@"type":@"0"};
    
    [manager GET:AID_LEFTCATEGORY_HOST parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *list = [AidLeftCategoryModel arrayOfModelsFromData:operation.responseData error:nil];
        int i=0;
        for (AidLeftCategoryModel *infoModel in list)
        {
            if (i>0 && i<5)
            {
                [_categoryListArray addObject:infoModel];
            }
            i++;
        }
        
        block(YES,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(NO,error);
    }];
}

@end
