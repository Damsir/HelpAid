//
//  AidHomeManagerModel.m
//  Aid
//
//  Created by 张丽 on 15/10/10.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import "AidHomeManagerModel.h"
#import "AidHomeDataModel.h"

#import "AFNetworking.h"

@implementation AidHomeManagerModel

-(instancetype)init
{
    if (self = [super init])
    {
        _homeDataArray = [NSMutableArray array];
    }
    return self;
}

-(void)loadHomeDataInfo:(freshInfoList)block
{
//     http://iapi.ipadown.com/api/yangshen/index.api.php?
//   siteid=2&catename=%E7%94%9F%E6%B4%BB%E6%80%A5%E6%95%91
    NSDictionary *dict = @{@"siteid":@"2",@"catename":@"生活急救"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:AID_HOMELIST_HOST parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        AIdHomeJsonModel *homeJsonModel = [[AIdHomeJsonModel alloc] initWithData:operation.responseData error:nil];
        for (AidHomeDataModel *homeDataModel in homeJsonModel.list)
        {
            [_homeDataArray addObject:homeDataModel];
        }
        
        block(YES,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(NO,error);
    }];
}

@end
