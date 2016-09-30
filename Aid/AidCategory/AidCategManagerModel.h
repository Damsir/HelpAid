//
//  AidCategManagerModel.h
//  Aid
//
//  Created by 张丽 on 15/10/10.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AidCategoryDataModel.h"

#import "AidLeftCategoryModel.h"

typedef void(^freshInfoList)(BOOL isSuccess,NSError *error);

@interface AidCategManagerModel : NSObject

@property(nonatomic,strong)NSMutableArray *categoryInfoArray;

@property(nonatomic,strong)NSMutableArray *categoryListArray;

@property(nonatomic,assign)NSInteger page;

-(void)loadCategoryInfo:(freshInfoList )block andWithTitle:(NSString *)title;

-(void)loadCategoryListData:(freshInfoList )block;

-(void)loadMoreCategoryInfo:(freshInfoList)block andWithTitle:(NSString *)title;

@end
