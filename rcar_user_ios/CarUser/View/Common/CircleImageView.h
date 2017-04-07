//
//  RadioButton.h
//  CarSeller
//
//  Created by jenson.zuo on 31/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface CircleImageView : UIImageView

@property (nonatomic, assign, getter = isCacheEnabled) BOOL cacheEnabled;

- (id)initWithFrame:(CGRect)frame backgroundProgressColor:(UIColor *)backgroundProgresscolor progressColor:(UIColor *)progressColor;
- (void)setImageURL:(NSString *)URL;

@end
