//
//  SellerInfoCell.h
//  CarSeller
//
//  Created by jenson.zuo on 8/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerInfoModel.h"
//#import "MJPhotoBrowser.h"
#import "SWTableViewCell.h"




@interface SellerInfoCell : SWTableViewCell <UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *serivceLabel;
@property (nonatomic, strong) IBOutlet UILabel *envLabel;
@property (nonatomic, strong) IBOutlet UIButton *contactBtn;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UITextView *detailText;
@property (nonatomic, strong) IBOutlet UIImageView *placeholder;
@property (nonatomic, strong) UITapGestureRecognizer *imageTap;
@property (nonatomic, strong) NSIndexPath *path;
@property (nonatomic, strong) id serviceDelegate;

- (void)setModel:(SellerInfoModel *)model;
- (void)setDetailInfoModel:(SellerDetailInfoModel*)model;

@end
