//
//  GeneralTableViewCell.h
//  CarSeller
//
//  Created by jenson.zuo on 31/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView* checkedImageView;

- (void)enableMultiSelection:(BOOL)enable;
- (void)setSelected:(BOOL)selected;
@end