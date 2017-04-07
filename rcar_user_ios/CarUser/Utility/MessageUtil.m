//
//  MessageUtil+MessageUtil.m
//  CarUser
//
//  Created by huozj on 1/8/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "MessageUtil.h"
#import "CommonUtil.h"

@implementation MessageUtil

+ (void) showErrMessage:(NSString *)message owner:(UIViewController *)owner {
    [CommonUtil showHintHUD:message inView:owner.view originY:50];
}

@end
