//
//  FaultReportTargetViewController.h
//  CarUser
//
//  Created by jenson.zuo on 21/7/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMStaticContentTableViewController.h"
#import "FaultModel.h"

@interface FaultReportTargetViewController : JMStaticContentTableViewController
@property (nonatomic, strong) FaultModel *faultModel;

@end
