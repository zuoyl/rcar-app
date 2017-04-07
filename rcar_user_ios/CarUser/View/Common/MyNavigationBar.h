//
//  MyNavigationBar.h
//  CarSeller
//
//  Created by jenson.zuo on 3/3/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface MyNavigationBar : UINavigationBar

@property (strong, nonatomic) IBInspectable UIColor *color;

-(void)setNavigationBarWithColor:(UIColor *)color;
-(void)setNavigationBarWithColors:(NSArray *)colours;

@end
