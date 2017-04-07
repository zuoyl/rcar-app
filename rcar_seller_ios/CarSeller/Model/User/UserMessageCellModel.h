//
//  UserMessageCellModel.h
//  CarSeller
//
//  Created by jenson.zuo on 24/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserMessageModel;

#define textPadding 15

@interface UserMessageCellModel : APIResponseModel

@property (nonatomic, strong) UserMessageModel *message;

@property (nonatomic, assign, readonly) CGRect timeFrame;
@property (nonatomic, assign, readonly) CGRect iconFrame;
@property (nonatomic, assign, readonly) CGRect textFrame;
@property (nonatomic, assign, readonly) CGFloat cellHeght;

@end
