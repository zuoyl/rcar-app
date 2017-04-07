//
//  SellerCommentCell.h
//  CarSeller
//
//  Created by jenson.zuo on 8/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerCommentModel.h"

@interface SellerCommentCell : UITableViewCell
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *rateLabel;
- (void)setModel:(SellerCommentModel *)model;

@end
