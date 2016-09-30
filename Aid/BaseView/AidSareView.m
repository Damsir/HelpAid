//
//  AidSareView.m
//  Aid
//
//  Created by 张丽 on 15/10/15.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import "AidSareView.h"

@implementation AidSareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithRed:13.0/255.0 green:13.0/255.0 blue:13.0/255.0 alpha:0.2];
        NSArray *imageArray = @[@"_sina",@"_share_qq",@"_share_qq_zone",@"_weixin",@"_share_wechat_circle",@"_share_wechat"];
        NSArray *titleArray = @[@"新浪",@"QQ",@"空间",@"微信",@"朋友圈",@"微信收藏"];
        for (int i= 0; i<2; i++)
        {
            for (int j=0; j<3; j++)
            {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(j*(DEVICE_W/3.0)+30, 200+i*100, 80, 80);
                [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon%@",imageArray[i*3+j]]] forState:UIControlStateNormal];
                button.tag = 100+i*3+j;
                [button addTarget:self action:@selector(pressShareBtn:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:titleArray[i*3+j] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.titleEdgeInsets = UIEdgeInsetsMake(80, -70, 0, 0);
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
                [self addSubview:button];

            }
            
//            UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
////            cancelBtn.frame = CGRectMake(DEVICE_W/2.0-8, CGRectGetMaxY(button.frame)+25, 32, 32);
//            [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
//            [cancelBtn addTarget:self action:@selector(pressCancelShareBtn:) forControlEvents:UIControlEventTouchUpInside];
//            [self addSubview:cancelBtn];
            
            UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
            [self addGestureRecognizer:tapView];
        }
    }
    return self;
}
-(void)pressShareBtn:(UIButton *)btn
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(shareTheMessageTo:)]) {
        [self.delegate shareTheMessageTo:btn.tag];
    }
}
-(void)tapView:(UITapGestureRecognizer *)tap
{

    [self removeFromSuperview];
}
-(void)pressCancelShareBtn:(UIButton *)cancel
{
    [self removeFromSuperview];
}
@end
