//
//  CarKindViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 31/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCarKindViewModeSingle;
extern NSString *const kCarKindViewModeMutiply;

@protocol CarKindViewDelegate <NSObject>
@required
- (void)carKindViewComplete:(NSString *)brand types:(NSArray *)types;
@end

@interface CarKindViewController : UITableViewController
@property (nonatomic, strong) id<CarKindViewDelegate> delegate;
@property (nonatomic, strong) NSString *viewMode;
@property (nonatomic, strong) UIViewController *rootViewController;

@end
