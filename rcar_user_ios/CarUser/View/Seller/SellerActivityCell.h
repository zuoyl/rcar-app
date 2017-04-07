//
//  ActivityOutlineCell.h
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerActivityModel.h"

@interface SellerActivityCell : UITableViewCell
@property (nonatomic, strong) UILabel *endLabel;

- (void)setModel:(SellerActivityModel *)model;


@end
