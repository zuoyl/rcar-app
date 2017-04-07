//
//  SellerSelectDelegate.h
//  CarUser
//
//  Created by huozj on 3/1/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#ifndef CarUser_SellerSelectDelegate_h
#define CarUser_SellerSelectDelegate_h

#import <Foundation/Foundation.h>
#import "SellerInfoModel.h"

@protocol SellerSelectDelegate <NSObject>
@required
- (void)selectSeller:(SellerInfoModel *)model forState:(BOOL)selected;
@end


#endif
