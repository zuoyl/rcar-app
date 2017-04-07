//
//  CarAddViewController.h
//  CarUser
//
//  Created by huozj on 1/19/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInfoModel.h"
#import "JMStaticContentTableViewController.h"

@protocol CarAddViewDelegae <NSObject>
@required
- (void)carAddViewCompleted:(CarInfoModel *)car;

@end

@interface CarAddViewController : JMStaticContentTableViewController
@property (nonatomic, strong) id<CarAddViewDelegae> delegate;
@property (nonatomic, strong) CarInfoModel *model;

@end
