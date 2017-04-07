//
//  MxAlertView.m
//  CarSeller
//
//  Created by jenson.zuo on 7/1/2016.
//  Copyright © 2016 Cloud Stone Technology. All rights reserved.
//

#import "MxAlertView.h"

@interface MxAlertView ()
@property (nonatomic, strong) UIAlertController *alertController;
@end

@implementation MxAlertView

@synthesize delegate;

-(instancetype) initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id)delegate cancelButtonTitle:(nullable NSString *)cancelTitle otherButtonTitles:(nullable NSString *)otherTitles,... {
    self.alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    self.delegate = delegate;
    __block MxAlertView *blockself = self;
    if (cancelTitle != nil) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSInteger index = [blockself.alertController.actions indexOfObject:action];
            if (blockself.delegate)
                [blockself.delegate alertView:blockself clickedButtonAtIndex:index];
            
        }];
        [self.alertController addAction:action];
    }
    if (otherTitles != nil) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:otherTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSInteger index = [blockself.alertController.actions indexOfObject:action];
            if (blockself.delegate)
                [blockself.delegate alertView:blockself clickedButtonAtIndex:index];
            
        }];
        [self.alertController addAction:action];
    }
    return self;
}

-(void)show:(UIViewController *)controller {
    if (controller)
        [controller presentViewController:self.alertController animated:YES completion:nil];
}

@end
