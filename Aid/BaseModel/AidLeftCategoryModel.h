//
//  AidLeftCategoryModel.h
//  Aid
//
//  Created by 张丽 on 15/10/10.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import "JSONModel.h"

@interface AidLeftCategoryModel : JSONModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *apiurl;

@end
