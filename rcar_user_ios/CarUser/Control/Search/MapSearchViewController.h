//
//  MapSearchViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 25/11/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapSearchViewController : UIViewController <BMKMapViewDelegate>

@property (nonatomic, strong) NSMutableArray *tableArray;
//@property (nonatomic, strong) IBOutlet UISearchBar* searchBar;
//@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;

- (void)searchWithName:(NSString *)input withCondition:(NSMutableDictionary *)condition;

-(NSString *)title;

@end
