//
//  CarListViewController.h
//  CarUser
//
//  Created by huozj on 1/19/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInfoModel.h"

typedef enum {
    CarInfoViewModeNormal,
    CarInfoViewModeSelection,
} CarInfoViewMode;


@protocol CarSelectDelegate <NSObject>
@optional
- (void)carSelected:(CarInfoModel *)carInfo index:(NSInteger)index;
@end


@interface CarListViewController : UITableViewController <MxAlertViewDelegate>
@property (nonatomic, strong) CarInfoModel *model;
@property (nonatomic, assign) CarInfoViewMode mode; 
@property (nonatomic, retain) id<CarSelectDelegate> delegate;

@end
