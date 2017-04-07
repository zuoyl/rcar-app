//
//  RegisterViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 29/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMStaticContentTableViewController.h"

@protocol RegisterViewDelegate <NSObject>
@required
- (void)registerView:(NSString *)user_id pwd:(NSString *)pwd;

@end

@interface RegisterViewController : JMStaticContentTableViewController
@property (nonatomic, weak) id<RegisterViewDelegate> delegate;
@end
