//
//  MyViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 8/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    ReachabilityModeOverlay,  //  The banner view overlay the content of the view of the viewcontroller
    ReachabilityModeResize,   //  The banner banner appear at the topo of the view container and resize the view of the viewcontroller
    
} ReachabilityMode;



@interface ReachabilityViewController : UIViewController {
    @protected
    UIView *_bannerView;
}

/**
 *  The view to display when there is not internet connection, the width should be the same of the view of the view controller
 */
@property (nonatomic, strong) UIView *bannerView;

/**
 *  the MMReachabilityMode can't not be change after that the view has been loaded
 *  set it after the init of the view controllor or overwriting the viewDidLoad in your subclass 
 *  just before calling [super viewDidLoad]
 */
@property (nonatomic, assign) ReachabilityMode mode;

/**
 *  The time in seconds that the banner will be visible before disappear automatically
 *  0 or negative values will make the banner permanet untill the internet connection will be available again
 */
@property (nonatomic, assign) float visibilityTime;

/**
 *  ARC forbids message send 'dealloc' so it's not possible to call [super dealloc] on subclasses, instead you can call onDealloc
 *  this will tear down all has been setted up (NSNotification observer etc...)
 */
- (void)onDealloc;

@end
