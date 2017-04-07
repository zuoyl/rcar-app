//
//  CommodityOutlineCell.h
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerCommodityModel.h"
#import "SWTableViewCell.h"
#import "StarRateView.h"


#define SellerCommodityCellHeight (70.f)

@interface SellerCommodityCell : SWTableViewCell
- (void)setModel:(SellerCommodityModel *)model;

@end
