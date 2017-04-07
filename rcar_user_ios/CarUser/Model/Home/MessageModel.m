//
//  MessageModel.m
//  CarUser
//
//  Created by jenson.zuo on 15/1/2016.
//  Copyright © 2016 CloudStone Tech. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

@end

@implementation MessageDetailModel

- (NSString *)formatMessageContent {
    if ([self.source isEqualToString:RCarNotificationSourceSeller]) {
        if ([self.kind isEqualToString:RCarNotificationKindOrder]) {
            // get seller name
            NSString *seller = nil;
            if (self.seller_name != nil && ![self.seller_name isEqualToString:@""])
                seller = self.seller_name;
            else
                seller = self.seller_id;
            // get message reason
            NSString *result = nil;
            if ([self.title isEqualToString:@"agree"])
                result = [NSString stringWithFormat:@"商家%@接受了您的订单", seller];
            else if ([self.title isEqualToString:@"decline"])
                result = [NSString stringWithFormat:@"商家%@拒绝了您的订单", seller];
            else if ([self.title isEqualToString:@"canceled"])
                result = [NSString stringWithFormat:@"商家%@取消了您的订单", seller];
            else
                result = [NSString stringWithFormat:@"商家%@改变了您的订单状态", seller];
            
            return result;
        }
    } else if ([self.source isEqualToString:RCarNotificationSourceSystem]) {
        if (self.title != nil && ![self.title isEqualToString:@""])
            return self.title;
        else
            return @"您收到了系统通知";
        
    }else if ([self.source isEqualToString:RCarNotificationSourceUser]) {
        return @"错误消息";
    }
    return @"错误消息";
    
}

@end

@implementation MessageRepleyModel

@end
