//
//  SellerCommentDetailViewControllerTableViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 10/3/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerCommentModel.h"

@interface SellerCommentDetailViewController : UIViewController
@property (nonatomic, retain) SellerCommentModel *model;
@property (nonatomic, strong) IBOutlet UIScrollView *contentView;

@end
