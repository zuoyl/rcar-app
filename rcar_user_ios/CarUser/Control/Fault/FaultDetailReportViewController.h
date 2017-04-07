//
//  FaultDetailViewController.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-21.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaultDetailViewDelegate <NSObject>
@required
-(void)faultItemSelected:(NSArray *)decs;
@end

@interface FaultDetailViewController : UITableViewController
@property (nonatomic, strong) id<FaultDetailViewDelegate> delegate;

@end
