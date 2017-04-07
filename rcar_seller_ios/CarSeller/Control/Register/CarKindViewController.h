//
//  CarKindViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 31/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CarSelectionModeSingle,
    CarSelectionModeMultiply,
} CarSelectionMode;

typedef enum {
    CarSelectionKindOnly,
    CarSelectionKindWithType,
} CarSelectionType;

@class CarKindViewController;

@protocol CarSelectionViewDelegate <NSObject>
@optional
- (CarSelectionMode)onGetCarSelectionMode;
- (CarSelectionType)onGetCarSelectionType;
@required
- (void)carSelectionCompleted:(NSArray *)result;
@end

@interface CarKindViewController : UITableViewController
@property (nonatomic, strong) NSArray *presetCars;
@property (nonatomic, assign) UIViewController *rootController;
@property (nonatomic, strong) id<CarSelectionViewDelegate> delegate;

@end
