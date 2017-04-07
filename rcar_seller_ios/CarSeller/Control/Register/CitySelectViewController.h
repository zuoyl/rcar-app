//
//  CitySelectViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 16/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CitySelectDelegate <NSObject>

- (void)citySelected:(NSString *)name;

@end

@interface CitySelectViewController : UIViewController
@property (nonatomic, retain) id<CitySelectDelegate> delegate;

@end
