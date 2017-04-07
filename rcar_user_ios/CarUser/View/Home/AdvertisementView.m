//
//  AdvertiseTableViewCell.m
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-12.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import "AdvertisementView.h"
#import "AdvertisementModel.h"
#import "SellerInfoViewController.h"


@implementation AdvertisementView {
    UIView *_animContainter;
    UIPageControl *_pageControl;
    NSMutableArray *_pageViews;
}



- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _pageViews = [[NSMutableArray alloc] init];
        _animContainter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(frame.size.width - 120, frame.size.height - 20, 100, 10)];
        _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:_animContainter];
        [self addSubview:_pageControl];
        [self bringSubviewToFront:_pageControl];
        
        // add tap recognizer
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClicked:)];
        [self addGestureRecognizer:tapRecognizer];
        
        // add swipe recognizer
        UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self     action:@selector(swipeGestureClicked:)];
        [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:swipeLeftRecognizer];
        
        UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self     action:@selector(swipeGestureClicked:)];
        [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:swipeRightRecognizer];

        
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray{
    if (dataArray == nil || [dataArray count] <= 0) return;
    
    self.datas = dataArray;
    _currentPage = 0;
    _pageControl.numberOfPages = dataArray.count;
    for (int i = 0; i < _pageViews.count; i++) {
        [(UIView *)[_pageViews objectAtIndex:i] removeFromSuperview];
    }
    [_pageViews removeAllObjects];
    for (int i = 0; i < dataArray.count; i++) {
        AdvertisementModel *ads = [dataArray objectAtIndex:i];
        if (ads.images != nil && ads.images.count > 0) {
            if (ads.images[0] == nil)continue;
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            
            NSString *url = [[RCar imageServer] stringByAppendingString:ads.images[0]];
            url = [url stringByAppendingString:@"?target=seller"];
            //SDWebImageManager *manager = [SDWebImageManager sharedManager];
            //[manager.imageDownloader setValue:@"user" forHTTPHeaderField:@"target"];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"adv_banner"] options:SDWebImageOption ];
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

- (void)setImageArray:(NSArray *)dataArray {
    if (dataArray == nil || [dataArray count] <= 0) return;
    self.datas = dataArray;
    
    _currentPage = 0;
    _pageControl.numberOfPages = dataArray.count;
    for (int i = 0; i < _pageViews.count; i++) {
        [(UIView *)[_pageViews objectAtIndex:i] removeFromSuperview];
    }
    [_pageViews removeAllObjects];
    for (int i = 0; i < dataArray.count; i++) {
        UIImage *image = [dataArray objectAtIndex:i];
        if (image != nil) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [imageView setImage:image];
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
    if( _currentPage == _pageViews.count-1 ){
        _currentPage= 0;
    }else{
        _currentPage++;
    }
    _pageControl.currentPage = _currentPage;
    for(int i = 0; i < _pageViews.count; i++){
        if (i != _currentPage) {
            [(UIView *)[_pageViews objectAtIndex:i] setHidden:YES];
        }else{
            [(UIView *)[_pageViews objectAtIndex:i] setHidden:NO];
        }
    }
    animation.type = @"fade";
    animation.subtype = kCATransitionFromRight;
    [_animContainter.layer addAnimation:animation forKey:@"animation"];
}

- (void)swipeGestureClicked:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if( _currentPage > 0){
            _currentPage--;
        }
    } else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if (_currentPage < _pageViews.count - 1)
            _currentPage++;
    }
    _pageControl.currentPage = _currentPage;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animationTansition) object:nil ];
    if (_pageViews.count > 1) {
        [self performSelector:@selector(animationTansition) withObject:nil afterDelay:3.0];
    }
}

- (void)tapGestureClicked:(UITapGestureRecognizer*)recognizer {
    AdvertisementModel *advertisement = [self.datas objectAtIndex:self.currentPage];
    // get top view controller from self
    id target = self;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    UIViewController *controller = target;
    if ([advertisement.type isEqualToString:@"seller"]
        && advertisement.seller_id != nil && ![advertisement.seller_id isEqualToString:@""]) {
        // get seller info
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
        UIViewController *destController = [storyboard instantiateViewControllerWithIdentifier:@"SellerInfoViewController"];
        [destController setValue:advertisement.seller_id forKey:@"sellerId"];
        [controller.navigationController pushViewController:destController animated:YES];
        return;
    }
}


@end
