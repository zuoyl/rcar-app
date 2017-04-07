//
//  SellerInfoCell.h
//  CarSeller
//
//  Created by jenson.zuo on 8/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerInfoModel.h"
#import "SWTableViewCell.h"
#import "SellerSelectDelegate.h"


@interface SellerInfoCell : SWTableViewCell

- (void)setModel:(SellerInfoModel *)model;

@end
