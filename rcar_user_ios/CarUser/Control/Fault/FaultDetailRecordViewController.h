//
//  FaultDetailRecordViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 25/11/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAlbumView.h"

@interface FaultDetailRecordViewController : UITableViewController
@property (nonatomic, strong)   NSString *order_id;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;

@end
