//
//  ServiceTableViewCell.m
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-16.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import "ServiceTableViewCell.h"
#import "NILauncherView.h"
#import "NILauncherButtonView.h"
#import "NILauncherViewObject.h"

@implementation ServiceTableViewCell

@synthesize serviceLauncherView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
              model:(NILauncherViewModel *)model
           delegate:(NILauncherViewController *)delegate {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // service launcher view
        self.serviceLauncherView = [[NILauncherView alloc] initWithFrame:self.bounds];
        self.serviceLauncherView.autoresizingMask = UIViewAutoresizingFlexibleDimensions;
        [self addSubview:self.serviceLauncherView];
        self.serviceLauncherView.backgroundColor = [UIColor whiteColor];
        self.serviceLauncherView.dataSource = model;
        self.serviceLauncherView.delegate = delegate;
        self.serviceLauncherView.numberOfRows = 3;
        self.serviceLauncherView.numberOfColumns = 3;
        self.serviceLauncherView.buttonSize = CGSizeMake(64, 64);
        [self.serviceLauncherView setContentInsetForPages:UIEdgeInsetsMake(5,0,5,0)];
        [self.serviceLauncherView reloadData];
    }
    return self;
}

- (void)setModel:(NILauncherViewModel *)model {
    self.serviceLauncherView.dataSource = model;
}

@end
