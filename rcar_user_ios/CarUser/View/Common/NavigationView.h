//
//  DataArrayModel.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-15.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationView : UIView
{
    UIImageView *separatorLineRight;
}

@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;

-(void) setBackground:(NSString *)imageName;

- (void) addLeftButtonImage:(NSString *)image highlightImage:(NSString *)highlightImage;
- (void) addRightButtonImage:(NSString *)image highlightImage:(NSString *)highlightImage;

- (void) addLeftButtonImage:(NSString *)image highlightImage:(NSString *)highlightImage target:(id)target action:(SEL)selector;
- (void) addRightButtonImage:(NSString *)image highlightImage:(NSString *)highlightImage target:(id)target action:(SEL)selector;

- (void) setTitle:(NSString *)title;
-(void) setRightBtnCount:(NSString *)count;

- (void) addBackButtonWithTarget:(id)target action:(SEL)selector;
//- (UIButton *) addCustomButtonWithTarget:(id)target action:(SEL)selector;

- (void) hideRightButton;

@end
