//
//  SellerServiceAddViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 23/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMStaticContentTableViewController.h"
#import "SellerServiceModel.h"

@protocol SellerServiceAddViewDelegate <NSObject>
@required
- (void)sellerServiceAddCompleted:(SellerServiceModel *)service;
@end

@interface SellerServiceAddViewController : JMStaticContentTableViewController
@property (nonatomic, strong) id<SellerServiceAddViewDelegate> delegate;

@end
