//
//  ServiceTableViewCell.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-16.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NILauncherView;
@class NILauncherViewModel;
@class NILauncherViewController;

@interface ServiceTableViewCell : UITableViewCell

@property (nonatomic, strong)NILauncherView *serviceLauncherView;
@property (nonatomic, readwrite, retain) NILauncherViewModel *model;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(NILauncherViewModel *)model delegate:(NILauncherViewController *)delegate;
- (void)setModel:(NILauncherViewModel *)model;
@end
