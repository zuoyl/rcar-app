//
//  FaultViewController.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-15.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTextView.h"


@interface FaultReportViewController : UITableViewController 
@property (nonatomic, strong) UITextField *posTextField;
@property (nonatomic, strong) SSTextView *infoTextView;

@end
