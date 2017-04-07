//
//  CreditExchangeItemCell.h
//  CarSeller
//
//  Created by jenson.zuo on 13/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditExchangeItemModel.h"

@interface CreditExchangeItemCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UILabel *startLabel;
@property (nonatomic, strong) IBOutlet UILabel *endLabel;
@property (nonatomic, strong) IBOutlet UILabel *countLabel;

- (void)setModel: (CreditExchangeItemModel *)model;

@end
