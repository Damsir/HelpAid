//
//  AidHomeDataModel.h
//  Aid
//
//  Created by 张丽 on 15/10/10.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import "JSONModel.h"
#import "AidListInfoModel.h"

@protocol AidHomeInfoModel <NSObject>



@end
@interface AidHomeInfoModel :AidListInfoModel


@end


@protocol AidHomeDataModel <NSObject>


@end

@interface AidHomeDataModel : JSONModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;

@property(nonatomic,strong)NSArray<AidHomeInfoModel>*list;

@end


@interface AIdHomeJsonModel : JSONModel

@property(nonatomic,strong)NSArray<AidHomeDataModel>*list;

@end
