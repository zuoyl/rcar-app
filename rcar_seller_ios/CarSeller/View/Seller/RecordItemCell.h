//
//  RecordItemCell.h
//  CarSeller
//
//  Created by jenson.zuo on 21/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordModel.h"

@interface RecordItemCell : UITableViewCell
@property (nonatomic, strong) UILabel *dateLabel;

- (void)setModel:(RecordModel *)model;

@end
