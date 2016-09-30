//
//  AidNoImgTableViewCell.h
//  Aid
//
//  Created by 张丽 on 15/10/10.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AidHomeDataModel.h"
#import "AidCategoryDataModel.h"

#import "CollectDataModel.h"


@interface AidNoImgTableViewCell : UITableViewCell


-(void)setUIWithDataInfo:(AidListInfoModel *)infoModel;


-(void)setUIWithCategoryDataInfo:(AidCategoryInfoModel *)infoModel;

-(void)setUIWithCollectDataInfo:(CollectDataModel *)infoModel;


@end
