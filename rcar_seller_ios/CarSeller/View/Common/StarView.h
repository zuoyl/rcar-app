//
//  StarView.h
//  CarSeller
//
//  Created by jenson.zuo on 19/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartView : UIView
@property(nonatomic) CGFloat radius;
@property(nonatomic) CGFloat value; // form 0.0 to 1.0
@property(nonatomic,strong) UIColor *startColor;
@property(nonatomic,strong) UIColor *boundsColor;

@end
