//
//  FaultHistoryView.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-19.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimbusPagingScrollView.h"

@interface FaultHistoryView : UIView

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;
- (void) loadDataFromNetwork;
@end
