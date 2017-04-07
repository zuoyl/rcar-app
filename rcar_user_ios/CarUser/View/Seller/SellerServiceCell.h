//
//  ServiceOutlineCell.h
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerServiceModel.h"
#import "SellerServiceDelegate.h"



@interface SellerServiceCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, assign) id serviceDelegate;

- (void)setSelectableMode:(BOOL)on;
- (void)setModelAndFrame:(SellerServiceModel *)model frame:(CGRect)frame;

@end
