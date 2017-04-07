//
//  AdvertiseViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 27/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertisementModel.h"
#import "JMStaticContentTableViewController.h"

@interface AdvertiseViewController : JMStaticContentTableViewController

@property (nonatomic, strong) AdvertisementModel *model;

@end
