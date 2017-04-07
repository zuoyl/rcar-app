//
//  OverlapView.m
//  CarUser
//
//  Created by huozj on 1/10/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OverlapView.h"

@implementation OverlapView

@synthesize delegate;


-(id)initWithDelegate:(id)_delegate {
    self = [self initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.delegate = _delegate;
    //self.userInteractionEnabled = false;
    
    return self;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (delegate != nil) {
        [delegate onTouchBegan:point withEvent:event];
    }
    return NO;
}




@end