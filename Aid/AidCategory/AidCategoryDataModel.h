//
//  AidCategoryDataModel.h
//  Aid
//
//  Created by 张丽 on 15/10/10.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import "JSONModel.h"

#import "AidListInfoModel.h"


@protocol AidCategoryInfoModel <NSObject>


@end

@interface AidCategoryDataModel : JSONModel

@property (nonatomic, strong) NSNumber *nowpage;
@property (nonatomic, strong) NSNumber *resultCount;
@property (nonatomic, copy) NSString *totalCount;
@property (nonatomic, strong) NSNumber *pagesize;
@property (nonatomic, strong) NSNumber *totalpage;

@property(nonatomic,strong)NSArray<AidCategoryInfoModel> *results;

@end


@interface AidCategoryInfoModel : AidListInfoModel


@end