//
//  AidHomeTableViewCell.m
//  Aid
//
//  Created by 张丽 on 15/10/10.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import "AidHomeTableViewCell.h"

#import "UIImageView+AFNetworking.h"

@interface AidHomeTableViewCell ()
{
    UILabel *titleLab;
    UIImageView *imageV;
    UILabel *subCateNameLab;
}

@end


@implementation AidHomeTableViewCell


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
//        
//        titleLab.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:titleLab];
        
        imageV = [[UIImageView alloc] initWithFrame:CGRectMake(titleLab.frame.origin.x, CGRectGetMaxY(titleLab.frame)+5, DEVICE_W-20, 150)];
        imageV.image = [UIImage imageNamed:@"abs_pic"];
        [self.contentView addSubview:imageV];
        
        subCateNameLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(imageV.frame)+5, DEVICE_W-20, 20)];
        subCateNameLab.font = [UIFont systemFontOfSize:12];
        subCateNameLab.textColor = [UIColor lightGrayColor];
//        subCateNameLab.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:subCateNameLab];
        
        
    }
    return self;
}

-(void)setUIWithDataInfo:(AidHomeInfoModel *)infoModel
{
    titleLab.text = infoModel.title;
    [imageV setImageWithURL:[NSURL URLWithString:infoModel.thumb] placeholderImage:[UIImage imageNamed:@"abs_pic"]];
    subCateNameLab.text = [NSString stringWithFormat:@"分类:%@",infoModel.subcatename];
}

-(void)setUIwITHCategoryDataInfo:(AidCategoryInfoModel *)infoModel
{
    titleLab.text = infoModel.title;
    [imageV setImageWithURL:[NSURL URLWithString:infoModel.thumb] placeholderImage:[UIImage imageNamed:@"abs_pic"]];
    subCateNameLab.text = [NSString stringWithFormat:@"分类:%@",infoModel.subcatename];
}

-(void)setUIWithCollectDataInfo:(CollectDataModel *)infoModel
{
    titleLab.text = infoModel.titleName;
    [imageV setImageWithURL:[NSURL URLWithString:infoModel.imageUrl] placeholderImage:[UIImage imageNamed:@"abs_pic"]];
    subCateNameLab.text = [NSString stringWithFormat:@"分类:%@",infoModel.categoryName];
}

@end
