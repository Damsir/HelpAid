//
//  AidSareView.h
//  Aid
//
//  Created by 张丽 on 15/10/15.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  AidSareViewDelegate<NSObject>

-(void)shareTheMessageTo:(NSInteger)tag;

@end

@interface AidSareView : UIView
@property(nonatomic,assign)id<AidSareViewDelegate>delegate;
@end
