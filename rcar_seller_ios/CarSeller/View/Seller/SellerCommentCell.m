//
//  SellerCommentCell.m
//  CarSeller
//
//  Created by jenson.zuo on 8/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerCommentCell.h"
#import "NSString+Extension.h"
#import "SSLineView.h"
#import "PhotoAlbumView.h"

@interface SellerCommentCell ()
@property (nonatomic, strong) PhotoAlbumView *photoAlbumView;
@end

@implementation SellerCommentCell {
    SellerCommentModel *_model;
}

@synthesize controller;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(SellerCommentModel *)model {
    _model = model;
    [self initializeCommentCell];
    
#if 0
    [self.userImageView setImageWithURL:[NSURL URLWithString:[RCAR_SERVER stringByAppendingString:model.image_url]] placeholderImage:[UIImage imageNamed:@"adv_banner"] options:SDWebImageOption success:^(UIImage *image, BOOL cached) {
        if(!cached){    // 非缓存加载时使用渐变动画
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
            //[blockImageView.layer addAnimation:transition forKey:nil];
        }
    //    [self.activity stopAnimating];
    } failure:^(NSError *error) {
        NSLog(@"failt to load fault detail images");
      //  [self.activity stopAnimating];
    }];
#endif
    
}

- (void)initializeCommentCell {
    // user label on left
    UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.frame.size.height - 20, 60, 20)];
    if (_model.user == nil || [_model.user isEqualToString:@""])
        userLabel.text = @"匿名用户";
    else
        userLabel.text = _model.user;
    userLabel.font = [UIFont systemFontOfSize:10.f];
    [self addSubview:userLabel];
    
    // time label on right
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 120, self.frame.size.height - 20, 120, 20)];
    timeLabel.text = _model.time;
    timeLabel.font = [UIFont systemFontOfSize:10.f];
    [self addSubview:timeLabel];
    
    // display content
    CGSize size = [_model.content sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(self.frame.size.width, 60)];
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.frame.size.width - 10, size.height)];
    contentLabel.font = [UIFont systemFontOfSize:12.f];
    contentLabel.text = _model.content;
    [self addSubview:contentLabel];
    
    CGFloat height = size.height + 30.f;
    // draw image if it exist
    if (_model.images.count > 0) {
        CGRect albumRect = CGRectMake(5, 30 + size.height, self.frame.size.width - 10, 90);
        self.photoAlbumView = [PhotoAlbumView initWithViewController:controller frame:albumRect mode:PhotoAlbumMode_View];
        self.photoAlbumView.maxOfImage = 4;
        [self.photoAlbumView loadImages:_model.images];
        [self addSubview:self.photoAlbumView];
        height += 90.f;
    }
    
}

+(CGSize)sizeOfCommentCell:(SellerCommentModel *)model {
    // display the comment title
    CGSize size = [model.content sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(320, 60)];
    CGFloat height = size.height + 40;
    if (model.images.count > 0)
        height += 90.f;
    
    return CGSizeMake(size.width, height);
}

@end
