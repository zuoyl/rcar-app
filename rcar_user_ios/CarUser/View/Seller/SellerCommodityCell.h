//
//  CommodityOutlineCell.h
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerCommodityModel.h"
#import "MWPhotoBrowser.h"
#import "SWTableViewCell.h"

@interface SellerCommodityCell : SWTableViewCell < MWPhotoBrowserDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *cImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *rateLabel;
@property (nonatomic, strong) UILabel *bandLabel;
@property (nonatomic, strong) UILabel *cutoffLabel;
@property (nonatomic, strong) UITapGestureRecognizer *imageTap;

- (void)setModel:(SellerCommodityModel *)model;

@end
