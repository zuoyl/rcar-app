//
//  CarTypeViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 31/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarKindViewController.h"

@interface CarTypeViewController : UITableViewController
@property (nonatomic, assign) UIViewController *rootController;
@property (nonatomic, assign) NSDictionary *cars;
@property (nonatomic, retain) id<CarSelectionViewDelegate> delegate;

@end
