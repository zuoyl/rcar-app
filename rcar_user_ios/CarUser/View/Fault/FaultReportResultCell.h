//
//  FaultReportResultCell.h
//  CarUser
//
//  Created by jenson.zuo on 18/5/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerServiceInquiryModel.h"

@interface FaultReportResultCell : UITableViewCell
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *rateLabel;

- (void)setModel:(SellerServiceInquiryModel *)model;
@end
