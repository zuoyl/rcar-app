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
@property (nonatomic, retain) UIViewController *controller;

- (void)setModel:(SellerCommentModel *)model;
+ (CGSize)sizeOfCommentCell:(SellerCommentModel *)model;

@end
