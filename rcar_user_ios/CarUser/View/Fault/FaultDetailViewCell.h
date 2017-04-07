//
//  FaultDetailViewCell.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-21.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface FaultDetailViewCell : SWTableViewCell {
    IBOutlet UILabel *label;
    IBOutlet UIImageView *image;
}

@property (strong, nonatomic) UIImageView *image;
@property (strong, nonatomic) UILabel *label;
@property (nonatomic, assign) NSString *section;
@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) NSInteger row;
@end
