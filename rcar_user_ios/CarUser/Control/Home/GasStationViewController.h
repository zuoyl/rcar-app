//
//  GasStationViewController.h
//  CarSeller
//
//  Created by suyang on 12/17/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKBaseComponent.h"
#import "BMKMapView.h"

@interface GasStationViewController : UIViewController<BMKMapViewDelegate, BMKPoiSearchDelegate, BMKLocationServiceDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKPoiSearch *poiSearch;
@property (nonatomic, strong) BMKLocationService* locService;
@property (nonatomic,retain) CLLocationManager* locationManager;

@end
