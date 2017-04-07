//
//  SellerServiceEditViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 23/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerServiceModel.h"
#import "JMStaticContentTableViewController.h"
#import "SellerServiceAddViewController.h"

@interface SellerServiceViewController : JMStaticContentTableViewController
@property (nonatomic, strong) SellerServiceModel *model;
@property (nonatomic, strong) id<SellerServiceAddViewDelegate> delegate;

@end
