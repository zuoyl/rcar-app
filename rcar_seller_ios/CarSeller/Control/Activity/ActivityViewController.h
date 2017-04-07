//
//  SellerActivityEditViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 23/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerActivityModel.h"
#import "JMStaticContentTableViewController.h"

@interface ActivityViewController : JMStaticContentTableViewController
@property (nonatomic, strong) SellerActivityModel *model;

@end
