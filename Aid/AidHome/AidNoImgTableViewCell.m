//
//  AidNoImgTableViewCell.m
//  Aid
//
//  Created by 张丽 on 15/10/10.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import "AidNoImgTableViewCell.h"

@interface AidNoImgTableViewCell ()
{
    UILabel *titleLab;
    UILabel *subCategoryLab;
}

@end

@implementation AidNoImgTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, DEVICE_W-20, 40)];
        titleLab.numberOfLines = 2;
        titleLab.font = [UIFont systemFontOfSize:18];
        titleLab.textColor = [UIColor blackColor];
        [self.contentView addSubview:titleLab];
        
        subCategoryLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.frame.origin.x, CGRectGetMaxY(titleLab.frame)+5, DEVICE_W-20, 20)];
        subCategoryLab.font = [UIFont systemFontOfSize:12];
        subCategoryLab.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:subCategoryLab];
    }
    return self;
}

-(void)setUIWithDataInfo:(AidListInfoModel *)infoModel
{
    titleLab.text = infoModel.title;
    subCategoryLab.text = [NSString stringWithFormat:@"分类:%@",infoModel.subcatename];
}
-(void)setUIWithCategoryDataInfo:(AidCategoryInfoModel *)infoModel
{
    titleLab.text = infoModel.title;
    subCategoryLab.text = [NSString stringWithFormat:@"分类:%@",infoModel.subcatename];
}

-(void)setUIWithCollectDataInfo:(CollectDataModel *)infoModel
{
    titleLab.text = infoModel.titleName;
    subCategoryLab.text = [NSString stringWithFormat:@"分类:%@",infoModel.categoryName];
}

@end
