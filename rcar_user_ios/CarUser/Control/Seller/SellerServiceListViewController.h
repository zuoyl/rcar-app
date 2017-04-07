//
//  SellerServiceListViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 8/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerInfoListViewController.h"
#import "SellerServiceCell.h"

@interface SellerServiceListViewController : SellerInfoListViewController <SellerServiceDelegate>
- (void)setSellerModel:(SellerInfoModel *)model;

@end
