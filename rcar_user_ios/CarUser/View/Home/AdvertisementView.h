//
//  AdvertiseTableViewCell.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-12.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvertisementView : UIView

@property (nonatomic,strong) NSArray *datas;
@property (nonatomic,assign) int currentPage;

- (void)setDataArray:(NSArray *)dataArray;
- (void)setImageArray:(NSArray *)dataArray;

@end
