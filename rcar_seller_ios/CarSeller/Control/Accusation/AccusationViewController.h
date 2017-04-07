//
//  AccusationViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 27/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccusationModel.h"
#import "JMStaticContentTableViewController.h"

@interface AccusationViewController : JMStaticContentTableViewController

@property (nonatomic, strong) AccusationModel *model;
@end
