//
//  AidHomeManagerModel.h
//  Aid
//
//  Created by 张丽 on 15/10/10.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^freshInfoList)(BOOL isSuccess,NSError *error);

@interface AidHomeManagerModel : NSObject

@property(nonatomic,strong)NSMutableArray *homeDataArray;

-(void)loadHomeDataInfo:(freshInfoList)block;

@end
