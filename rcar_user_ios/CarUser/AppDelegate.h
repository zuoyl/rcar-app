//
//  AppDelegate.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-12.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKBaseComponent.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>  {
    BMKMapManager* _mapManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *cachePath;


@end

