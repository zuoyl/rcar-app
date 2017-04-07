//
//  SOSViewController.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-15.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKMapView.h"

@interface SOSViewController : UIViewController <CLLocationManagerDelegate, MxAlertViewDelegate, BMKMapViewDelegate>

@property (nonatomic, strong) BMKMapView *mapView;;
@property (nonatomic, strong) UIButton *publicateBtn;
@end
