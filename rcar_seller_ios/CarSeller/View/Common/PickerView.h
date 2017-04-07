//
//  PickerView.h
//  CarSeller
//
//  Created by jenson.zuo on 31/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickerView;

@protocol PickerViewDelegate <NSObject>
@optional
-(void)pickerViewDone:(PickerView *)pickView result:(NSString *)result;
@end

@interface PickerView : UIView

@property(nonatomic,weak) id<PickerViewDelegate> delegate;

-(instancetype)initPickviewWithPlistName:(NSString *)plistName isHaveNavControler:(BOOL)isHaveNavControler;
-(instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler;

-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler;

-(void)remove;
-(void)show;
-(void)setPickViewColer:(UIColor *)color;
-(void)setTintColor:(UIColor *)color;
-(void)setToolbarTintColor:(UIColor *)color;

@end
