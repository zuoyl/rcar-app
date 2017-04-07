//
//  OverlapView.h
//  CarUser
//
//  Created by huozj on 1/10/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OverlapViewDelegate <NSObject>
@optional
- (void) onTouchBegan:(CGPoint)point withEvent:(UIEvent *)event;

@end



@interface OverlapView : UIView

-(id)initWithDelegate:(id)_delegate;
    
@property (nonatomic,assign) id<OverlapViewDelegate> delegate;

@end