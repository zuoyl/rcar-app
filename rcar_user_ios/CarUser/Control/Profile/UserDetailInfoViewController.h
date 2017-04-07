//
//  UserDetailInfoViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 10/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileModel.h"
#import "CitySelectViewController.h"

@interface UserDetailInfoViewController : UITableViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,CitySelectDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) IBOutlet UITextField *idField;
@property (nonatomic, strong) IBOutlet UITextField *homeCityField;
@property (nonatomic, strong) IBOutlet UITextField *addressField;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityView;


@end
