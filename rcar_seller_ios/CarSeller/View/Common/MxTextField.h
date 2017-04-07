//
//  MxTextField.h
//  CarSeller
//
//  Created by jenson.zuo on 9/3/2016.
//  Copyright © 2016 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Validator.h"

@class MxTextField;

@protocol MxTextFieldDelegate <NSObject>
@optional
-(void)mxTextFieldDidEndEditing:(MxTextField *)textField;
@end


@interface MxTextField : UITextField <ValidatorDelegate>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *group;
@property (nonatomic, assign) BOOL isValid;
@property (nonatomic, retain) id<MxTextFieldDelegate> mxDelegate;

- (void)addRule:(Rule *)rule;

@end
