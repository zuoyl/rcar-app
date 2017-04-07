//
//  UITextField+ASTextField.h
//  CarUser
//
//  Created by jenson.zuo on 21/5/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ImageTextFieldTypeDefault,
    ImageTextFieldTypeRound
} ImageTextFieldType;

@interface ImageTextField : UITextField

@end


@interface UITextField ()
- (void)setupTextFieldWithIconName:(NSString *)name;
- (void)setupTextFieldWithType:(ImageTextFieldType)type withIconName:(NSString *)name;
@end
