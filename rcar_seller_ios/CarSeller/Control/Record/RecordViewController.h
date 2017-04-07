//
//  RecordViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 27/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMStaticContentTableViewController.h"
#import "RecordModel.h"

@interface RecordViewController : JMStaticContentTableViewController
@property (nonatomic, strong) RecordModel *model;

@end
