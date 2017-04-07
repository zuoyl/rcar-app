//
//  ImagePageView.h
//  CarUser
//
//  Created by jenson.zuo on 21/5/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePageView : UIView
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, assign) NSInteger curPage;

- (void)setImages:(NSArray *)images;

@end
