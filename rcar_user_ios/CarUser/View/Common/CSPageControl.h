//
//  DataArrayModel.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-15.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSPageControl : UIControl<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIImageView *slider;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, assign) int numberOfPages, currentPage, lastPageIndex;
@property (nonatomic, strong) NSArray *pages;
@property (nonatomic) Boolean scrollable;
@property (nonatomic) float tagWidth;
@property (nonatomic, assign,getter = isAnimating) BOOL animating;

- (id)initWithFrame:(CGRect)frame background:(NSString *)backgroundImage slider:(NSString *)sliderImage pages:(NSArray *)pages scrollable:(Boolean)scrollable tagWidth:(float)tagWidth;
- (id)initWithFrame:(CGRect)frame background:(NSString *)backgroundImage slider:(NSString *)sliderImage pages:(NSArray *)pages;
- (void)setCurrentPage:(int)_currentPage animated:(BOOL)animated;
- (void) setTitleFontSize:(CGFloat) size;
@end
