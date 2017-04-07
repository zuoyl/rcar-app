//
//  CitySelectViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 16/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CitySelectDelegate <NSObject>

- (void)citySelected:(NSString *)name;

@end

@interface CitySelectViewController : UITableViewController
@property (nonatomic, strong) NSMutableDictionary *cities;

@property (nonatomic, strong) NSMutableArray *keys; //城市首字母
@property (nonatomic, strong) NSMutableArray *arrayCitys;   //城市数据
@property (nonatomic, strong) NSMutableArray *arrayHotCity;
@property (nonatomic, retain) id delegate;

@end
