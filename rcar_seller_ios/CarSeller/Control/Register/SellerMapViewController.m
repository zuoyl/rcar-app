//
//  SellerMapViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 30/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "SellerMapViewController.h"
#import "CitySelectViewController.h"
#import "LocationModel.h"

#define kBarHeight 44.f

@interface SellerMapViewController () <CitySelectDelegate, BMKGeoCodeSearchDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *cityBtn;


@end

@implementation SellerMapViewController {
    CLLocationManager *_locationMgr;
    BMKMapView *_mapView;
    NSString *_city;
    LocationModel *_location;
}

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"标记商铺位置";
    
    CGFloat startX = self.navigationController.navigationBar.frame.size.height + 20.f;
    
    // create the city button
    self.cityBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, startX, 80, kBarHeight)];
    self.cityBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
    [self.cityBtn setTitle:@"城市" forState:UIControlStateNormal];
    self.cityBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.cityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cityBtn addTarget:self action:@selector(cityBtnClicked:) forControlEvents:UIControlEventTouchUpInside ];
    [self.view addSubview:self.cityBtn];
   
    // create search bar
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(80, startX, self.view.frame.size.width-80, kBarHeight)];
    [self.searchBar setBarTintColor:[UIColor colorWithHex:@"509400"]];
    CALayer *layer = [self.searchBar layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:0.0];
    [layer setBorderWidth:1];
    UIColor *color = [UIColor colorWithHex:@"509400"];
    [layer setBorderColor:color.CGColor];
    
    [self.view addSubview:self.searchBar];
    
    // create baidu map
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, kBarHeight + startX, self.view.frame.size.width, self.view.frame.size.height - (kBarHeight + startX))];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeMap:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    // get location
    if ([CLLocationManager locationServicesEnabled]) {
        _locationMgr = [[CLLocationManager alloc] init];
        [_locationMgr setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationMgr.delegate = self;
        _locationMgr.distanceFilter = 1000.0f;
        [_locationMgr startUpdatingLocation];
        [self setCurrentState:ViewStatusCalling];
    } else {
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"不能取得地理未知信息" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        [alert show:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    if (_mapView) {
        _mapView.delegate = nil;
        _mapView = nil;
    }
}


- (void)cityBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"city_selector" sender:self];
}

- (void)completeMap:(id)sender {
    if (_city == nil) {
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"没有选择城市" delegate:self cancelButtonTitle:@"重新设定" otherButtonTitles:@"知道了", nil];
        [alert show:self];
        return;
    }
    
    if (_location == nil) {
#if 0
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"没有设定商铺地理位置" delegate:self cancelButtonTitle:@"重新设定" otherButtonTitles:@"知道了", nil];
        [alert show:self];
#else 
        if (self.delegate) {
            CLLocationCoordinate2D location;
            location.latitude = 100.0;
            location.longitude = 20.0;
            [self.delegate locationSelected:_city locaiton:location];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
#endif
        return;
    }
    // set the location in seller model
    
    // exit current view
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -UIAct
- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -LocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self setCurrentState:ViewStatusCallFinished];
    CLLocation *location = [locations objectAtIndex:0];
    [_locationMgr stopUpdatingLocation];
    [_mapView setCenterCoordinate:location.coordinate];
    // display city name
    BMKGeoCodeSearch *search = [[BMKGeoCodeSearch alloc]init];
    search.delegate = self;
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc]init];
    option.reverseGeoPoint = location.coordinate;
    [search reverseGeoCode:option];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *controller = segue.destinationViewController;
    if ([controller respondsToSelector:@selector(setDelegate:)])
        [controller setValue:self forKey:@"delegate"];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

#pragma mark - CitySelectDelegate
- (void)citySelected:(NSString *)city {
    if (![_city isEqualToString:city]) {
        _city = city;
        [self.cityBtn setTitle:_city forState:UIControlStateNormal];
        BMKGeoCodeSearch *search = [[BMKGeoCodeSearch alloc]init];
        search.delegate = self;
        BMKGeoCodeSearchOption *option = [[BMKGeoCodeSearchOption alloc]init];
        option.city = _city;
        option.address = nil;
        [self setCurrentState:ViewStatusCalling];
        [search geoCode:option];
    }
}

#pragma makr - BMKGeoSearchDelegate
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    [self setCurrentState:ViewStatusCallFinished];
    if (error == BMK_SEARCH_NO_ERROR) {
        [_mapView setCenterCoordinate:result.location];
    } else {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"不能切换到选择的城市地图，请检查网络" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        [alert show:self];
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    [self setCurrentState:ViewStatusCallFinished];
    if (error == BMK_SEARCH_NO_ERROR) {
        [self.cityBtn setTitle:result.addressDetail.city forState:UIControlStateNormal];
    } else {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"不能取得当前位置信息" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        [alert show:self];
    }
    
}

@end
