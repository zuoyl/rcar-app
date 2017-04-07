//
//  AdvertiseTableViewCell.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-12.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvertiseTableViewCell : UITableViewCell

@property (nonatomic,strong) NSArray *datas;
@property (nonatomic,assign) int currentPage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setDataArrayWithRect:(NSArray *)dataArray rect:(CGRect)rect;

@end
