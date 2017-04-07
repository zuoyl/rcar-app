//
//  SellerInfoListViewController.h
//  CarUser
//
//  Created by jenson.zuo on 1/2/2016.
//  Copyright © 2016 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerInfoModel.h"

@class SellerInfoListViewController;

@protocol SellerInfoListDelegate <NSObject>
@optional
-(void)sellerInfoList:(SellerInfoListViewController *)controller menu:(NSArray *)menu;
@end

@interface SellerInfoListViewController : UITableViewController
@property (nonatomic, strong) SellerInfoModel *model;
@property (nonatomic, retain) id<SellerInfoListDelegate> delegate;

- (void)setSellerModel:(SellerInfoModel *)model;
- (NSArray *)getMenuItems;


@end
