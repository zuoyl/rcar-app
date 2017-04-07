//
//  BusinessItemCell.h
//  CarSeller
//
//  Created by jenson.zuo on 25/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "SWTableViewCell.h"

@protocol OrderDelegate <NSObject>
@optional
- (void)orderExecute:(OrderModel *)model;
- (void)orderSkip:(OrderModel *)model;
- (void)orderCancel:(OrderModel *)model;

@end

@interface OrderItemCell : SWTableViewCell
@property (nonatomic, strong) id<OrderDelegate> bidDelegate;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setModel:(OrderModel *)model;

@end
