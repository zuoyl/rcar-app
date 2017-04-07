//
//  MyViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 8/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusView.h"
#import "ReachabilityViewController.h"

@interface MyViewController : ReachabilityViewController


- (void) setCurrentState:(ViewStatusType)status;

@end
