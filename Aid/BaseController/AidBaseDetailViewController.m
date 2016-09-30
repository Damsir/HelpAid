//
//  AidBaseDetailViewController.m
//  Aid
//
//  Created by 张丽 on 15/10/11.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import "AidBaseDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UMSocial.h"
#import "FMDatabase.h"
#import "AIdBaseBarManager.h"
#import "AidSareView.h"
#import "WXApi.h"
#import "WeiboSDK.h"


@interface AidBaseDetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate,UMSocialUIDelegate,AidSareViewDelegate>
{
    UIWebView *AidDetailwebView;
    UIScrollView *scrollV;
    CGFloat scrollV_Oringrl_Y;
    CGFloat scrollV_Final_Y;
    
    NSString *webUrl;
    
//    存储路径
    NSString *savePath;
    
    NSString *titleStr;
    NSString *shareStr;
    UMSocialUrlResource *imgResource;
    UIImage *shareImage;
}
@end

@implementation AidBaseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    webUrl = [[NSString alloc] init];
    webUrl =[NSString stringWithFormat:@"%@id=%@",AID_DETAILURL,self.webUrlId];
    
    imgResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:self.imageUrl];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.imageUrl]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        shareImage = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    
    
    [self initUI];
    
    //    创建数据库
    [self creatMyDataBase];
    //    创建表
    [self creatmyTables];

    
}
#pragma mark -数据库
-(void)creatMyDataBase
{
    savePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/AIDApp.db"];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:savePath];
    if ([dataBase open])
    {
    }
    else
    {
    }
    [dataBase close];

}
-(void)creatmyTables
{
    FMDatabase *dataBase = [FMDatabase databaseWithPath:savePath];
    NSString *sql = @"CREATE TABLE AidDeatailTables (id INTEGER PRIMARY KEY AUTOINCREMENT,webUrlId VARCHAR(20),imageUrl VARCHAR(20),webUrl VARCHAR(20),categoryName VARCHAR(20),titleName VARCHAR(20));";
    if ([dataBase open])
    {
        [dataBase executeUpdate:sql];
    }
    else
    {
    }
    [dataBase close];
 
}
-(void)insertDataToTables
{
    
    FMDatabase *dataBase = [FMDatabase databaseWithPath:savePath];
    NSString *sql = @"INSERT INTO AidDeatailTables (webUrlId,imageUrl,webUrl,categoryName,titleName) VALUES (?,?,?,?,?);";
    if ([dataBase open])
    {
        if (![self isHas:webUrl])
        {
            [dataBase executeUpdate:sql,self.webUrlId,self.imageUrl,webUrl,self.categoryName,self.titleName];
        }
        else
        {
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"已经收藏过了哦" message:@"可以在我的收藏里面直接查看" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *  action) {
                
            }];
            [alter addAction:cancel];
            [self presentViewController:alter animated:YES completion:^{
                
            }];
        }

    }
    else
    {
    }

}
//--------------------------------判断是否插入----------------------
-(BOOL)isHas:(NSString *)webUrlId
{
    FMDatabase *dataBase = [FMDatabase databaseWithPath:savePath];
    NSString *sql = @"SELECT *FROM AidDeatailTables WHERE webUrlId = ?;";
    
    
    if ([dataBase open])
    {
        FMResultSet *set = [dataBase executeQuery:sql,self.webUrlId];
        while ([set next])
        {
            [dataBase close];
            return YES;
        }
    }
    else
    {
    }
    [dataBase close];

    return NO;
    
}

#pragma mark -创建视图
-(void)initUI
{
    [self initWebView];
    [self initNavigationBar];
 
}
-(void)initWebView
{
    AidDetailwebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_W, DEVICE_H)];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@id=%@",AID_DETAILURL,self.webUrlId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [AidDetailwebView loadRequest:request];
    AidDetailwebView.delegate = self;
    [self.view addSubview:AidDetailwebView];
}
-(void)initNavigationBar
{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(clickRightBtn)];
}
-(void)clickRightBtn
{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"分享" message:@"赶紧收藏分享吧" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        
        [self saveItToHomeDictionary];
    }];
    [alter addAction:save];
    UIAlertAction *share = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {

//        [self shareTheMessage];
        [self creatShareView];
       
    }];
    [alter addAction:share];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *  action) {

    }];
    [alter addAction:cancel];
    
    [self presentViewController:alter animated:YES completion:^{
        
    }];
    
    
}



#pragma mark -分享
-(void)creatShareView
{
    
    AidSareView *shareView = [[AidSareView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_W, DEVICE_H)];
    shareView.delegate = self;
    [UIView  animateWithDuration:0.01 animations:^{
       
        [self.view addSubview:shareView];
    }];
}
-(void)shareTheMessageTo:(NSInteger)tag
{

    switch (tag)
    {
        case 100:

            [self shareMessageToSina];
            break;
        case 101:
            [self shareMessageToQQ];
            break;
        case 102:
            [self shareMessageToQQZone];
            break;
        case 103:
            [self shareMessageToWeChat];
            break;
        case 104:
            [self shareMessageToWeChatCircle];
            break;
        case 105:
            [self shareMessageToWeChatCollect];
            break;
        default:
            break;
    }
}
//分享到新浪
-(void)shareMessageToSina
{
       //判断是否授权
    if ( [WeiboSDK isWeiboAppInstalled]) {
        
        //进入授权页面
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //获取微博用户名、uid、token等
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                //进入你的分享内容编辑页面
                

                [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",titleStr,webUrl] shareImage:shareImage socialUIDelegate:self];        //设置分享内容和回调对象
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
                
                
            }
        });

    }
    else
    {
    //进入授权页面
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            //获取微博用户名、uid、token等
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];

            //进入你的分享内容编辑页面
            
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:shareStr image:nil location:nil urlResource:imgResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                }
            }];
            
            
        }
    });
    }
    
}
//分享到QQ
-(void)shareMessageToQQ
{
    [UMSocialData defaultData].extConfig.qqData.title = titleStr;
    [UMSocialData defaultData].extConfig.qqData.url = webUrl;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:[NSString stringWithFormat:@"%@%@",titleStr,webUrl] image:shareImage location:nil urlResource:imgResource presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {

        }
    }];
    
    
}
//分享到空间
-(void)shareMessageToQQZone
{
    [UMSocialData defaultData].extConfig.qzoneData.title = titleStr;
    [UMSocialData defaultData].extConfig.qzoneData.url = webUrl;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:[NSString stringWithFormat:@"%@%@",titleStr,webUrl] image:shareImage location:nil urlResource:imgResource presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {

        }
    }];

}
//分享到微信聊天
-(void)shareMessageToWeChat
{
    if ([WXApi isWXAppInstalled])
    {
      
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = webUrl;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = titleStr;

        //使用UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite分别代表微信好友、微信朋友圈、微信收藏
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:titleStr image:shareImage location:nil urlResource:imgResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {

            }
        }];
    }
    else
    {
        
    }
 
}
//分享到朋友圈
-(void)shareMessageToWeChatCircle
{
    if ([WXApi isWXAppInstalled])
    {

        [UMSocialData defaultData].extConfig.wechatTimelineData.url =webUrl;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = titleStr;

        //使用UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite分别代表微信好友、微信朋友圈、微信收藏
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:titleStr image:shareImage location:nil urlResource:imgResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
            }
        }];
    }
    else
    {
        
    }

}
//分享到微信收藏
-(void)shareMessageToWeChatCollect
{
    if ([WXApi isWXAppInstalled])
    {
        
        //使用UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite分别代表微信好友、微信朋友圈、微信收藏
        [UMSocialData defaultData].extConfig.wechatFavoriteData.url = webUrl;
         [UMSocialData defaultData].extConfig.wechatFavoriteData.title = titleStr;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatFavorite] content:titleStr image:shareImage location:nil urlResource:imgResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {

            }
        }];
    }
    else
    {
        
    }

}
//分享到微信
-(void)shareMessageToWeiXin
{
    if ([WXApi isWXAppInstalled])
    {
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"5615d1b067e58ecae9000277"
                                          shareText:@"这个分享功能到底是特么怎么回事撒！！！能不能好好用了"
                                         shareImage:nil
                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite]
                                           delegate:self];
        
        
    }
    else
    {
        
    }
    
}

#pragma mark -实现回调方法
//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        
    }
}
#pragma mark -友盟协议方法
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}
#pragma mark -收藏
//收藏就存储到沙盒
-(void)saveItToHomeDictionary
{
    [self insertDataToTables];
}

#pragma mark -webView协议方法
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (AidDetailwebView == webView)
    {

        scrollV = webView.scrollView;
        scrollV.delegate = self;
        //     获得web 页面的头title
        //     通过获得web html 页面的 "document.title"  js代码获取
        titleStr =[AidDetailwebView stringByEvaluatingJavaScriptFromString:@"document.title"];
        //    UIImageView *imageV = [[UIImageView alloc] init];
        shareStr = [NSString stringWithFormat:@"%@%@",titleStr,webUrl];
        self.navigationItem.titleView = [AIdBaseBarManager setNavigationItemTitleViewWith:titleStr];
    }
}
#pragma mark -scroll协议方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{

    [UIView animateWithDuration:0.1 animations:^{
        
        if (scrollV_Oringrl_Y<scrollV_Final_Y)
        {
            self.navigationController.navigationBar.hidden = YES;
            self.tabBarController.tabBar.hidden = YES;
        }
        else
        {
            self.navigationController.navigationBar.hidden = NO;
            self.tabBarController.tabBar.hidden = NO;
        }

    }];
    
    scrollV_Oringrl_Y = scrollV_Final_Y;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    scrollV_Final_Y = scrollV.contentOffset.y;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
