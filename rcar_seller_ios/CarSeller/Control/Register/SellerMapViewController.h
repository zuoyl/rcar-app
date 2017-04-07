//
//  SellerMapViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 30/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyViewController.h"

@protocol SellerMapViewDelegate <NSObject>

@required
- (void) locationSelected:(NSString *)address locaiton:(CLLocationCoordinate2D)location;

@end

@interface SellerMapViewController : MyViewController <BMKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, MxAlertViewDelegate>
@property (nonatomic, retain) id<SellerMapViewDelegate> delegate;

@end
