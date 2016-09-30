//
//  AidNearByViewController.m
//  Aid
//
//  Created by 张丽 on 15/10/11.
//  Copyright © 2015年 张丽. All rights reserved.
//

#import "AidNearByViewController.h"

#import <MapKit/MapKit.h>

#import <CoreLocation/CoreLocation.h>


@interface AidNearByViewController ()<MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate,UITextFieldDelegate>
{
    UISearchBar *locationSearchBar;
    MKMapView *aidMapView;
}
//定位测试
@property (strong, nonatomic)  UILabel *lblMessage;
@property (strong, nonatomic)  UIImageView *imgView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *recentLocation;

//经纬度解析器
@property(strong,nonatomic)CLGeocoder *geocoder;

@end

@implementation AidNearByViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if ([CLLocationManager locationServicesEnabled])
    {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestAlwaysAuthorization];
        
        [self.locationManager requestWhenInUseAuthorization];
        //    ---------------------------
        
        self.locationManager.delegate = self;

        [self.locationManager startUpdatingLocation];
    }
    
    
    
    
    [self initUI];
    
    
}
#pragma mark -创建视图
-(void)initUI
{
    locationSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 35)];
    locationSearchBar.delegate = self;
    locationSearchBar.showsCancelButton = YES;
    locationSearchBar.searchBarStyle = UISearchBarStyleProminent;
    locationSearchBar.placeholder = @"请输入站点";
    self.navigationItem.titleView = locationSearchBar;
    locationSearchBar.showsSearchResultsButton = YES;
    locationSearchBar.keyboardType = UIKeyboardTypeDefault;
    locationSearchBar.keyboardAppearance = UIKeyboardAppearanceAlert;

}

#pragma mark -searchBar的协议方法

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{

//    收起键盘
    [locationSearchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    [searchBar resignFirstResponder];
    
    [self searchLocationwithAdressName:searchBar.text];
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}
//文本框将要清除文字的时候
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

//创建搜索位置的文本输入框
//将有意义的地址转化为经纬度
-(void)searchLocationwithAdressName:(NSString *)adressName
{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"找不到您输入的地址" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleCancel handler:^(UIAlertAction *  action) {
        
    }];
    [alter addAction:cancel];
    _geocoder = [[CLGeocoder alloc] init];
    [_geocoder geocodeAddressString:adressName completionHandler:^(NSArray*  placemarks, NSError *  error) {
        if ([placemarks count]>0 && error==nil)
        {

            CLPlacemark *firstPlaceMark = [placemarks objectAtIndex:0];
        
            [self creatPointWithlatitude:firstPlaceMark.location.coordinate.latitude andWithlatitude:firstPlaceMark.location.coordinate.longitude andWithTitle:adressName];
        }
        else if([placemarks count]==0 && error==nil)
        {
            [self presentViewController:alter animated:YES completion:^{
                
            }];
        }
        else
        {
            [self presentViewController:alter animated:YES completion:^{
                
            }];

        }
    }];

}

#pragma mark -创建一个大头针
-(void)creatPointWithlatitude:(float)latitude andWithlatitude:(float)longitude andWithTitle:(NSString*)title
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(longitude,latitude);
    MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
    [point setTitle:title];
    [point setCoordinate:coordinate];
    [aidMapView addAnnotation:point];
    
}



//处理定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *curLocation = [locations lastObject];
    
//    定位结束
    [self.locationManager stopUpdatingLocation];
    
    //    解析经纬度，将经纬度解析为有意义的值
    
    //    初始化一个经纬度解析器
    self.geocoder = [[CLGeocoder alloc] init];
    
    //    解析经纬度值
    [_geocoder reverseGeocodeLocation:curLocation completionHandler:^(NSArray *  placemarks, NSError *  error) {
        
        CLPlacemark *placeMark = placemarks[0];
//        将字典信息拼接起来
        NSArray *arr =
        [placeMark.addressDictionary valueForKey:@"FormattedAddressLines"] ;
        for (NSString *locatedAt in arr)
        {
        }
  
    }];
    
    
    
    
//    ---------------------直接显示用户当前位置
    
    aidMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, DEVICE_W, DEVICE_H-64)];
    
    
    aidMapView.delegate = self;
    aidMapView.showsUserLocation=YES;
    
    aidMapView.mapType = MKMapTypeStandard;
//    是否显示用户所在位置
    aidMapView.showsUserLocation = YES;
    MKCoordinateSpan span = {0.02,0.02};
    MKCoordinateRegion region = {curLocation.coordinate,span};
    [aidMapView setRegion:region];
    [self.view addSubview:aidMapView];
    
    
}

//处理定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    if(error.code == kCLErrorLocationUnknown)
    {
      
    }
    else if(error.code == kCLErrorNetwork)
    {
      
    }
    else if(error.code == kCLErrorDenied)
    {
        [self.locationManager stopUpdatingLocation];
        self.locationManager = nil;
    }
}
-(void)initLocation
{
    //    使用定位,允许定位的两句话
    //    NSLocationAlwaysUsageDescription
    
    //    NSLocationWhenInUseUsageDescription
    //    在info.plist里面添加这两句话
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
    
    [self.locationManager requestWhenInUseAuthorization];
    //    ---------------------------

    self.locationManager.delegate = self;
    
//    在启动更新前设置属性distanceFilter，它指定设备(水平或垂直)移动多少米后才将另一个更新发送给委托。下面的代码使用适合跟踪长途跋涉者的设置启动位置管理器：
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;//m为单位
    self.locationManager.distanceFilter = 200; //1英里≈1609米

    [self.locationManager startUpdatingLocation];
    
}



//--------------------------定位测试

#pragma mark -----------地图的代理回调方法

// 将要加载地图
- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView{
    
}

//加载地图完成
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{
    
    // 地图加载错误,出错
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    //    MKAnnotationView  这个是 大头针的定义样式
        MKPinAnnotationView *view=[[MKPinAnnotationView alloc]init];
    //    // 是否带动画
        [view setAnimatesDrop:YES];
    //    // 设置大头针的颜色
//        [view setPinColor:MKPinAnnotationColorPurple];
    //
    //    // 弹出小标题
        [view setCanShowCallout:YES];
    
    
    // 大头针的复用机制,不用重复创建相同的大头针
//    static NSString *identifier=@"test";
//    
//        MKPinAnnotationView *view=(MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//    //
//        if(!view){
//    
//            view=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
//    
//            [view setCanShowCallout:YES];
//            [view setAnimatesDrop:YES];
//            [view setImage:[UIImage imageNamed:@"地图"]];
//    
//        }
    return view;
    
    
}

// 选择大头针
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    
}

// 取消选择大头针
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    
    
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
