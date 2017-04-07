//
//  AdvertiseTableViewCell.m
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-12.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import "AdvertiseTableViewCell.h"
#import "AdvertisementModel.h"

#define Adv_Cell_Height 100



@implementation AdvertiseTableViewCell {
    UIView *_animContainter;
    NSMutableArray *_pageViews;
    UIPageControl *_pageControl;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _pageViews = [[NSMutableArray alloc] init];
        
        _animContainter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self.contentView addSubview:_animContainter];
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.frame.size.width - 120, self.frame.origin.y + self.frame.size.height - 20, 100, 10)];
        _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        [self.contentView addSubview:_pageControl];
        
    }
    return self;
}

- (void)setDataArrayWithRect:(NSArray *)dataArray rect:(CGRect)rect {
    self.datas = dataArray;
    self.frame = rect;
    [_pageControl setFrame:CGRectMake(self.frame.size.width - 120, self.frame.size.height - 20, 100, 20)];
    
    _currentPage = 0;
    for (int i = 0; i < _pageViews.count; i++) {
        [(UIView *)[_pageViews objectAtIndex:i] removeFromSuperview];
    }
    [_pageViews removeAllObjects];
    _pageControl.numberOfPages = dataArray.count;

    for (int i = 0; i < dataArray.count; i++) {
        NSString *image = ((AdvertisementModel *)[dataArray objectAtIndex:i]).images[0];
        if (image == nil) continue;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        NSString *url = [[RCar imageServer] stringByAppendingString:image];
        url = [url stringByAppendingString:@"?target=seller"];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"adv_banner"] options:SDWebImageOption ];
        [_animContainter addSubview:imageView];
        [imageView setHidden:(i!=0)];
        [_pageViews addObject:imageView];
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


@end
