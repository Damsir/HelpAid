//
//  takePhoto.m
//  TakePicture
//
//  Created by yitonghou on 15/8/5.
//  Copyright (c) 2015年 移动事业部. All rights reserved.
//
/*
 作者：景泰蓝   bug联系QQ：840737320  微信：housenkui
 
  从民国的青帮，到文革的红卫兵，
  再到城市化建设的城管，以及现在软件行业的产品经理，无一不是社会深刻变革的产物。
 
 */
#define AppRootView  ([[[[[UIApplication sharedApplication] delegate] window] rootViewController] view])

#define AppRootViewController  ([[[[UIApplication sharedApplication] delegate] window] rootViewController])

#import "takePhoto.h"

@implementation takePhoto
{
    NSUInteger sourceType;
}

+ (takePhoto *)sharedModel{
    static takePhoto *sharedModel = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        sharedModel = [[self alloc] init];
    });
    return sharedModel;
}

+(void)sharePicture:(sendPictureBlock)block{
    
    takePhoto *tP = [takePhoto sharedModel];
    
    tP.sPictureBlock =block;
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"设置头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
     // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
            
            [tP clickCameraSheet];
        }];
        [alter addAction:camera];
    }
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从相册中获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        
        [tP clickPhotoSheet];
        
    }];
    [alter addAction:photo];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *  action) {
        
    }];
    [alter addAction:cancel];
    
    [AppRootViewController presentViewController:alter animated:YES completion:^{
        
    }];
}
#pragma mark -点击相机
-(void)clickCameraSheet
{
//    判断相机可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    // 跳转到相机或相册页面
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    
    [AppRootViewController presentViewController:imagePickerController animated:YES completion:NULL];
}
-(void)clickPhotoSheet
{
    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 跳转到相机或相册页面
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    
    [AppRootViewController presentViewController:imagePickerController animated:YES completion:NULL];
}

#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    takePhoto *TPhoto = [takePhoto sharedModel];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

    [TPhoto sPictureBlock](image);
    
}


@end
