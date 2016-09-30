//
//  AIdPersonViewController.m
//  Aid
//
//  Created by 张丽 on 15/10/11.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import "AIdPersonViewController.h"

#import "ParallaxHeaderView.h"


#import "takePhoto.h"

//Controller
#import "MyMessageVC.h"
#import "MyCollectVC.h"


#import "AIdBaseBarManager.h"

@interface AIdPersonViewController ()
{
    UIImage *backImage;
//    tableHeaderView
    ParallaxHeaderView *headerView;
//    iconBtn
    UIButton *iconBtn;
    
    
    NSArray *array;
    
}
@end

@implementation AIdPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    array = [[NSArray alloc] init];
    [self initUI];
    [self insertData];

}
#pragma mark -放入数据
-(void)insertData
{
    array = @[@"我的收藏",@"清除缓存",@"更多设置"];
}
#pragma mark -创建视图
-(void)initUI
{
    self.navigationItem.titleView = [AIdBaseBarManager setNavigationItemTitleViewWith:@"我的"];
    [self initTableView];
    headerView = [ParallaxHeaderView parallaxHeaderViewWithCGSize:CGSizeMake(DEVICE_W, 200)];
    
    headerView.headerTitleLabel.text = @"点击换头像";
    backImage= [UIImage imageNamed:@"1.jpg"];
    headerView.headerImage = backImage;
    [self.aidBaseTableV setTableHeaderView:headerView];
    iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iconBtn.frame = CGRectMake(DEVICE_W/2.0-50, headerView.frame.size.height/2.0-50, 100, 100);
//    iconBtn.backgroundColor = [UIColor yellowColor];
    [iconBtn setImage:[[UIImage imageNamed:@"star-on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [iconBtn addTarget:self action:@selector(clickTestBtn) forControlEvents:UIControlEventTouchUpInside];
    iconBtn.layer.cornerRadius = 50;
    iconBtn.layer.borderWidth = 1;
    iconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self setIconImage];
    [headerView addSubview:iconBtn];
    
    headerView.headerTitleLabel.frame = CGRectMake(0, CGRectGetMaxY(iconBtn.frame)+5, DEVICE_W, 30);
    headerView.headerTitleLabel.font = [UIFont systemFontOfSize:15];

}
-(void)clickTestBtn
{
    [takePhoto sharePicture:^(UIImage *image) {
       
//        ----------------------------
//        取完图片之后存放到本地方法
         UIImageWriteToSavedPhotosAlbum(image, self,  @selector(image:didFinishSavingWithError:contextInfo:), nil);

        NSUserDefaults *iconImage = [NSUserDefaults standardUserDefaults];
        [iconImage setObject:UIImageJPEGRepresentation(image, 1.0) forKey:@"iconImage"];
        [iconImage synchronize];
        
        [self setIconImage];
        
    }];

}


#pragma mark -保存本地图片回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示" message:msg delegate:self
cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)initTableView
{
    self.aidBaseTableV = [[UITableView alloc] initWithFrame:CGRectMake(0,64, DEVICE_W, DEVICE_H-64)];
    self.aidBaseTableV.dataSource = self;
    self.aidBaseTableV.delegate  =self;
    self.aidBaseTableV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.aidBaseTableV];
    [self.aidBaseTableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"base"];
}
//设置头像图片
-(void)setIconImage
{
    NSUserDefaults *iconImage = [NSUserDefaults standardUserDefaults];
    NSData* imageData = [iconImage objectForKey:@"iconImage"];
    UIImage* image = [UIImage imageWithData:imageData];
    iconBtn.clipsToBounds = YES;
    [iconBtn setImage:image forState:UIControlStateNormal];
}
//是否隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark -关键一句话
//当下拉scrollview的时候，图片方法，字逐渐消失
//上滑得时候，图片变得模糊效果
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.aidBaseTableV)
    {
        [(ParallaxHeaderView *)self.aidBaseTableV.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -tableView的协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base"];
    if (array.count >indexPath.row)
    {
        if (indexPath.row==2)
        {
            NSFileManager *fm = [NSFileManager defaultManager];
            NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/jerrygo.Aid/fsCachedData"];
            NSDictionary *dict =  [fm attributesOfItemAtPath:path error:nil];
            //获得文件的大小
            NSNumber *size = [dict  objectForKey:@"NSFileSize"];
            //把NSNumber对象拆开成整型
            int a = [size  intValue];
            cell.textLabel.text = [NSString stringWithFormat:@"%@               %dKB",array[indexPath.row],a];
        }
        else
        {
        cell.textLabel.text = array[indexPath.row];
        }
    }
    cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      if (indexPath.row ==0)
    {
        MyCollectVC *collectVC =[[MyCollectVC alloc] init];
        collectVC.titleName = array[0];
        [self.navigationController pushViewController:collectVC animated:YES];
    }
    else if (indexPath.row == 1)
    {
        [self clearSaveData];
    }
    else
    {

    }
    
}
-(void)clearSaveData
{
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"清除缓存" message:@"您确定要清除所有缓存吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [self deleteSave];
    }];
    [alter addAction:sureAction];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *  action) {
        
    }];
    [alter addAction:cancel];

    [self presentViewController:alter animated:YES completion:^{
        
    }];
}
-(void)deleteSave
{
    //    创建文件管理对象（是一个单例对象）
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/jerrygo.Aid/fsCachedData"];
    NSArray *fileArray =   [fm contentsOfDirectoryAtPath:path error:nil];
    
    
    for (NSString * str in fileArray)
    {
        NSString *removePath = [path stringByAppendingPathComponent:str];
        BOOL ret4 = [fm  removeItemAtPath:removePath error:nil];
        if (ret4) {

        }else{

        }
        
    }
    [self.aidBaseTableV reloadData];
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
