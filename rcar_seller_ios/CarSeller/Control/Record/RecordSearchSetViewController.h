//
//  RecordSearchSetViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 21/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMStaticContentTableViewController.h"

extern NSString * const kRecordSearchType_Time;
extern NSString * const kRecordSearchKey_TimeStart;
extern NSString * const kRecordSearchKey_TimeEnd;

extern NSString * const kRecordSearchType_User;
extern NSString * const kRecordSearchType_Service;
extern NSString * const kRecordSearchType_Keyword;

@protocol RecordSearchSetViewDelegate <NSObject>
@required
- (void)recordSearchSetCompleted:(NSDictionary *)result;
@end

@interface RecordSearchSetViewController : JMStaticContentTableViewController
@property (nonatomic, strong) id<RecordSearchSetViewDelegate> delegate;

@end
