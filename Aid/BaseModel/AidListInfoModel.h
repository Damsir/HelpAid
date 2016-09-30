//
//  AidListInfoModel.h
//  Aid
//
//  Created by 张丽 on 15/10/10.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import "JSONModel.h"

@interface AidListInfoModel : JSONModel

@property (nonatomic, copy) NSString *subcatename;
@property (nonatomic, copy) NSString *catename;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *thumb_2;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *jianjie;
@property (nonatomic, copy) NSString *views;
@property (nonatomic, copy) NSString *edittime;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, copy) NSString *ID;

@end
