//
//  MaintenancePublicateSellerSelectViewController.h
//  CarUser
//
//  Created by huozj on 3/12/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGRadioView.h"
#import "SellerListViewController.h"
#import "ServicePublicateModel.h"
#import "JMStaticContentTableViewController.h"

@interface MTPublicateStep2ViewController : JMStaticContentTableViewController<BGRadioViewDelegate, SellerListSelectDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) ServicePublicateModel *model;
@end
