//
//  CommodityCommentListViewController.h
//  CarUser
//
//  Created by jenson.zuo on 23/5/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerCommodityModel.h"
#import "SSTextView.h"

@interface CommodityCommentListViewController : UITableViewController
@property (nonatomic, weak) SellerCommodityModel *model;
@property (nonatomic, strong) SSTextView *textView;
@property (nonatomic, strong) UIView *panelView;
@end
