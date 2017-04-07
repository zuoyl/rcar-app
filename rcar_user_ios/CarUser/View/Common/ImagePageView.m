//
//  ImagePageView.m
//  CarUser
//
//  Created by jenson.zuo on 21/5/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "ImagePageView.h"

#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "MWPhotoProtocol.h"

@interface ImagePageView () <MWPhotoBrowserDelegate>

@end

@implementation ImagePageView {
    UIView *_animContainter;
    NSMutableArray *_pageViews;
    UIPageControl *_pageControl;
}

@synthesize imageArray;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _pageViews = [[NSMutableArray alloc] init];
        _animContainter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_animContainter];
        self.imageArray = [[NSMutableArray alloc]init];
        self.curPage = 0;
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(frame.size.width - 120, 10, 100, 10)];
        _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:_pageControl];
        [self bringSubviewToFront:_pageControl];
        
        // add tap recognizer
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClicked:)];
        [self addGestureRecognizer:tapRecognizer];
        
        // add swipe recognizer
        UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self     action:@selector(swipeGestureClicked:)];
        [self addGestureRecognizer:swipeRecognizer];

    }
    return self;
}

- (void)tapGestureClicked:(UITapGestureRecognizer*)recognizer {
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    browser.displayActionButton = NO;//分享按钮,默认是
    browser.displayNavArrows = NO;//左右分页切换,默认否
    browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = NO;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = YES;//是否全屏,默认是
    
    // get top view controller from self
    id target = self;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    UIViewController *controller = target;
    [controller.navigationController pushViewController:browser animated:YES];    
}

- (void)swipeGestureClicked:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if( _curPage > 0){
            _curPage--;
        }
    } else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if (_curPage < _pageViews.count - 1)
            _curPage++;
    }
    _pageControl.currentPage = _curPage;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animationTansition) object:nil ];
    if (_pageViews.count > 1) {
        [self performSelector:@selector(animationTansition) withObject:nil afterDelay:3.0];
    }
}

- (void)setImages:(NSArray *)images {
    if (images == nil || [images count] == 0) return;
    
    [self.imageArray addObjectsFromArray:images];
    self.curPage = 0;
    _pageControl.numberOfPages = images.count;
    // clear all page views
    for (int i = 0; i < _pageViews.count; i++) {
        [(UIView *)[_pageViews objectAtIndex:i] removeFromSuperview];
    }
    [_pageViews removeAllObjects];
    
    // load images
    for (int i = 0; i < images.count; i++) {
        NSString *image = [images objectAtIndex:i];
        if (image != nil) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            NSString *url = [[RCar imageServer] stringByAppendingString:image];
            url = [url stringByAppendingString:@"?target=seller"];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"adv_banner"] options:SDWebImageOption];
            [_animContainter addSubview:imageView];
            [imageView setHidden:(i!=0)];
            [_pageViews addObject:imageView];
        }
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animationTansition) object:nil ];
    if (_pageViews.count > 1) {
        [self performSelector:@selector(animationTansition) withObject:nil afterDelay:3.0];
    }
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self performSelector:@selector(animationTansition) withObject:nil afterDelay:3.0];
}

- (void)animationTansition{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    if( _curPage == _pageViews.count-1 ){
        _curPage= 0;
    }else{
        _curPage++;
    }
    _pageControl.currentPage = _curPage;
    for(int i = 0; i < _pageViews.count; i++){
        if (i != _curPage) {
            [(UIView *)[_pageViews objectAtIndex:i] setHidden:YES];
        }else{
            [(UIView *)[_pageViews objectAtIndex:i] setHidden:NO];
        }
    }
    animation.type = @"fade";
    animation.subtype = kCATransitionFromRight;
    [_animContainter.layer addAnimation:animation forKey:@"animation"];
}
#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _pageViews.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    UIImageView *imageView = [_pageViews objectAtIndex:index];
    MWPhoto *photo = [[MWPhoto alloc]initWithImage:imageView.image];
    return photo;
}


@end
