//
//  MxAlertView.h
//  CarSeller
//
//  Created by jenson.zuo on 7/1/2016.
//  Copyright © 2016 Cloud Stone Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MxAlertView;
@protocol MxAlertViewDelegate <NSObject>
- (void)alertView:(nullable MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface MxAlertView : UIView
@property (nonatomic, strong) _Nullable id<MxAlertViewDelegate> delegate;

-(instancetype) initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id)delegate cancelButtonTitle:(nullable NSString *)cancelTitle otherButtonTitles:(nullable NSString *)otherTitles,...;

-(void)show:(nonnull UIViewController *)controller;

@end
