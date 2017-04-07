//
//  CarInfoCardViewCell.h
//  CarUser
//
//  Created by huozj on 1/20/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarInfoCardViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *brandLabel; //车辆型号
@property (nonatomic, strong) IBOutlet UILabel *numberLabel; //车牌号码
@property (nonatomic, strong) IBOutlet UILabel *productLabel; //出厂日期
@property (nonatomic, strong) IBOutlet UILabel *mileageLabel; //行驶里程

@end
