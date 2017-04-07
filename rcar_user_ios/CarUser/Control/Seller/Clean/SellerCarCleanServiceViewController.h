//
//  SellerCarCleanServiceViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 17/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerServiceModel.h"

@interface SellerCarCleanServiceViewController : UIViewController < UIActionSheetDelegate>
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@property (nonatomic, retain) ServiceContactModel *model;

@end
