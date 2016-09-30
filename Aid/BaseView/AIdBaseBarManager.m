//
//  AIdBaseBarManager.m
//  Aid
//
//  Created by 张丽 on 15/10/14.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import "AIdBaseBarManager.h"

@implementation AIdBaseBarManager

+(UILabel *)setNavigationItemTitleViewWith:(NSString *)titleName
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = titleName;
    return label;
}

@end
