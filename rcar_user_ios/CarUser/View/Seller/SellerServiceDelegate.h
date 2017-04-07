//
//  SellerServiceDelegate.h
//  CarSeller
//
//  Created by jenson.zuo on 18/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SellerServiceModel.h"

@protocol SellerServiceDelegate <NSObject>
@required
- (void)selectSellerService:(SellerServiceModel *)model forState:(BOOL)selected;
@end
