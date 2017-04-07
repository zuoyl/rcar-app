//
//  MapSearchViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 25/11/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "MapSearchViewController.h"
#import "SearchResultModel.h"
#import "DataArrayModel.h"

@interface MapSearchViewController ()

@end

@implementation MapSearchViewController {
    BMKMapView *_mapView;
    //NSArray *_annotationArray;
    CLLocationCoordinate2D _userCoordinate;
}

@synthesize tableArray;
//@synthesize searchBar;
//@synthesize activity;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // create baidu map
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 450)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    [_mapView setShowsUserLocation:YES];//开启定位功能
    
    //_userLocation = [[BMKUserLocation alloc] init];
    //[_userLocation.location initWithLatitude:39.02 longitude:121.31];
    //    CLLocationCoordinate2D coordinate;      //设定经纬度
    _userCoordinate.latitude = 39.027283;        //纬度
    _userCoordinate.longitude = 121.313217;      //经度
    [_mapView setCenterCoordinate:_userCoordinate];
    
    //    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(_userCoordinate, BMKCoordinateSpanMake(1.0, 1.0));
    //    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    //    [_mapView setRegion:adjustedRegion animated:YES];
    
    // add current place annotation
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    item.coordinate = _userCoordinate;//经纬度
    item.title = @"当前位置";    //标题
    //item.subtitle = @"subtitle";//子标题
    [_mapView addAnnotation:item];
    
    //    [searchBar setPlaceholder:@"Enter Name"];
    //    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    //    [activity stopAnimating];
    
    [self nearbysearch];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[_mapView removeAnnotations:_mapView.annotations];
    _mapView.delegate = nil;
    _mapView = nil;
    //self.delegate = nil;
    //[searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *用户位置更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 新的用户位置
 */
-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    // remove old annotation
    for (NSInteger i = 0; i < [[_mapView annotations] count]; i++) {
        BMKPointAnnotation *item = [_mapView.annotations objectAtIndex:i];
        if (item.coordinate.latitude == _userCoordinate.latitude &&
            item.coordinate.longitude == _userCoordinate.longitude) {
            [_mapView removeAnnotation:item];
            break;
        }
    }
    _userCoordinate = userLocation.location.coordinate;
    
    // add new annotation
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    item.coordinate = _userCoordinate;//经纬度
    item.title = @"当前位置";    //标题
    //item.subtitle = @"subtitle";//子标题
    [_mapView addAnnotation:item];
}

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
#if 0
    static NSString *AnnotationViewID = @"annotationViewID";
    
    BMKAnnotationView *annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
        annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_location.png"]];//气泡框左侧显示的View,可自定义
        
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectButton setFrame:(CGRect){260,0,50,annotationView.frame.size.height}];
        [selectButton setTitle:@"确定" forState:UIControlStateNormal];
        annotationView.rightCalloutAccessoryView =selectButton;//气泡框右侧显示的View 可自定义
        [selectButton setBackgroundColor:[UIColor redColor]];
        [selectButton setShowsTouchWhenHighlighted:YES];
        [selectButton addTarget:self action:@selector(selectPointAnnotation:) forControlEvents:UIControlEventTouchUpInside];
    }
    //以下三行代码用于将自定义视图和标记绑定,一一对应,目的是当点击,右侧自定义视图时,能够知道点击的是那个标记
//    annotationView.rightCalloutAccessoryView.tag = _cacheAnnotationTag;
//    [_cacheAnnotationMDic setObject:annotation forKey:[NSNumber numberWithInteger:_cacheAnnotationTag]];
//    _cacheAnnotationTag++;
    
    //如果是我的位置标注,则允许用户拖动改标注视图,并赋予绿色样式 处于
    if ([annotation.title isEqualToString:@"title"]) {
        ((BMKPinAnnotationView *)annotationView).pinColor = BMKPinAnnotationColorGreen;//标注呈绿色样式
        [annotationView setDraggable:YES];//允许用户拖动
        [annotationView setSelected:YES animated:YES];//让标注处于弹出气泡框的状态
    }else
    {
        ((BMKPinAnnotationView *)annotationView).pinColor = BMKPinAnnotationColorRed;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));//不知道干什么用的
    annotationView.annotation = annotation;//绑定对应的标点经纬度
    annotationView.canShowCallout = TRUE;//允许点击弹出气泡框
    return annotationView;
#else
    static NSString *AnnotationViewID = @"annotationViewID";
    
    BMKAnnotationView *annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    
    //如果是我的位置标注,则允许用户拖动改标注视图,并赋予绿色样式 处于
    if ([annotation.title isEqualToString:@"当前位置"]) {
        ((BMKPinAnnotationView *)annotationView).pinColor = BMKPinAnnotationColorGreen;//标注呈绿色样式
        //[annotationView setDraggable:YES];//允许用户拖动
        [annotationView setSelected:YES animated:YES];//让标注处于弹出气泡框的状态
    }else
    {
        ((BMKPinAnnotationView *)annotationView).pinColor = BMKPinAnnotationColorRed;
    }
    
    return annotationView;
#endif
}

//- not use
- (void)selectPointAnnotation:(id)sender {
    
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
//    [self.delegate searchComplete:[self.tableArray objectAtIndex:indexPath.row]];
}

- (void)searchWithName:(NSString *)input withCondition:(NSMutableDictionary *)condition {
    // get search param
    NSDictionary *params = @{@"role":@"user",
                             @"user_id":@"piao",
                             @"type":@"name",
                             @"param":input,
                             @"num":[NSNumber numberWithInteger:10],
                             @"offset":[NSNumber numberWithInteger:0]};
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[SearchResultModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
//    [activity startAnimating];
    // start search
#if 0
    __block MapSearchViewController *blockSelf = self;
    [RCar callService:rcar_api_user_search modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            NSArray *data = dataModel.data;
            for (int i = 0; i < data.count; i++) {
                [blockSelf.tableArray addObject:[data objectAtIndex:i]];
            }
            //        [activity stopAnimating];
            [blockSelf refreshAnnotations:blockSelf.tableArray];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:0];
        }
        
    }failure:^(NSString *errorStr) {
        [CommonUtil showHintHUD:errorStr inView:self.view originY:0];
    }];
#endif

}

- (void) nearbysearch {
    // get search param
    //NSString *input = @"temp";
    NSDictionary *params = @{@"role":@"user",
                             @"user_id":@"piao",
                             @"type":@"name",
    //                         @"param":input,
                             @"num":[NSNumber numberWithInteger:10],
                             @"offset":[NSNumber numberWithInteger:0]};
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[SearchResultModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
//    [activity startAnimating];
    // start search
#if 0
    __block MapSearchViewController *blockSelf = self;
    [RCar callService:rcar_api_user_search modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            NSArray *data = dataModel.data;
            for (int i = 0; i < data.count; i++) {
                [blockSelf.tableArray addObject:[data objectAtIndex:i]];
            }
            //        [activity stopAnimating];
            [blockSelf refreshAnnotations:blockSelf.tableArray];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:0];
        }
    }failure:^(NSString *errorStr) {
        [CommonUtil showHintHUD:errorStr inView:self.view originY:0];
    }];
#endif
}

-(NSString *)title {
    return @"地图检索";
}

- (void) refreshAnnotations : (NSMutableArray *)data {
    // remove all annotations
    if (_mapView.annotations != nil) {
        [_mapView removeAnnotations:_mapView.annotations];
    }
    
    // add current place annotation
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    item.coordinate = _userCoordinate;//经纬度
    item.title = @"当前位置";    //标题
    //item.subtitle = @"subtitle";//子标题
    [_mapView addAnnotation:item];
    
    // add sells annotations
    CLLocationCoordinate2D coordinate;
    for (int i = 0; i < data.count; i++) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        SearchResultModel *model = [data objectAtIndex:i];
        item.coordinate = coordinate;//经纬度
        item.title = model.intro;    //标题
        //item.subtitle = @"subtitle";//子标题
        [_mapView addAnnotation:item];
    }
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
