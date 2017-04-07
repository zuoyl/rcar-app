//
//  CommodityOutlineCell.m
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerCommodityCell.h"
#import "MWPhoto.h"

@implementation SellerCommodityCell

@synthesize priceLabel;
@synthesize rateLabel;
@synthesize bandLabel;
@synthesize cutoffLabel;
@synthesize imageTap;
@synthesize cImageView;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.cImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, frame.size.height - 10, frame.size.height - 10 )];
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.cImageView.frame.origin.x + self.cImageView.frame.size.width + 5, 5, 120, 20)];
        self.descLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.cImageView.frame.origin.x + self.cImageView.frame.size.width + 5, 25, 200, 20)];
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.cImageView.frame.origin.x + self.cImageView.frame.size.width + 5, 50, 80, 20)];
        self.rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.cImageView.frame.origin.x + self.cImageView.frame.size.width + 90, 50, 100, 20)];
        self.cutoffLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.cImageView.frame.size.width + 180, 50, 180, 20)];
        self.bandLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 100, 5, 100, 20)];
        
        self.imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self.cImageView action:@selector(commodityImageTap:)];
        
        // set font
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.descLabel.font = [UIFont systemFontOfSize:12];
        self.priceLabel.font = [UIFont systemFontOfSize:12];
        self.rateLabel.font = [UIFont systemFontOfSize:12];
        self.cutoffLabel.font = [UIFont systemFontOfSize:12];
        self.bandLabel.font = [UIFont systemFontOfSize:12];
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.descLabel];
        [self addSubview:priceLabel];
        [self addSubview:self.rateLabel];
        [self addSubview:self.cutoffLabel];
        [self addSubview:self.bandLabel];
        [self addSubview:self.cImageView];
        
        [self bringSubviewToFront:self.cImageView];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SellerCommodityModel *)model {
    self.nameLabel.text = model.name;
    self.descLabel.text = model.desc;
    
    // price
    if (model.price != nil) {
        self.priceLabel.text = [@"价格:" stringByAppendingString:model.price];
        self.priceLabel.text = [self.priceLabel.text stringByAppendingString:@"¥"];
    } else {
        self.priceLabel.text = @"价格:不详";
    }
    // cutoff
    if (model.cutoff != nil) {
        self.cutoffLabel.text = [@"优惠:" stringByAppendingString:model.cutoff];
    } else {
        self.cutoffLabel.text = @"优惠:无";
    }
    // rate
    if (model.rate != nil) {
        self.rateLabel.text = [@"评价:" stringByAppendingString:model.rate];
    }
    
    self.bandLabel.text = model.band;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (model.seller_id == nil) {
        self.accessoryType = UITableViewCellAccessoryNone;
        return;
    }
#if 0
    NSString *imagePath = RCAR_SERVER;
    imagePath = [imagePath stringByAppendingString:@"seller/"];
    imagePath = [imagePath stringByAppendingString:model.seller_id];
    imagePath = [imagePath stringByAppendingString:@"/"];
    imagePath = [imagePath stringByAppendingPathComponent:model.cid];
    imagePath = [imagePath stringByAppendingPathComponent:@"/"];
    
    if (model.images == nil || model.images.count == 0) {
        [self.cImageView setImage:[UIImage imageNamed:@"train"]];
    }
#endif
    
#if 0
    
    for (NSInteger index = 0; index < model.images.count; index++) {
        NSString *imageUrl = [model.images objectAtIndex:index];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.placeholder.frame];
        __block UIImageView *blockImageView = imageView;
        [imageView setImageWithURL:[NSURL URLWithString:[imagePath stringByAppendingString:imageUrl]] placeholderImage:[UIImage imageNamed:@"adv_banner"] options:SDWebImageOption success:^(UIImage *image, BOOL cached) {
            if(!cached){    // 非缓存加载时使用渐变动画
                CATransition *transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionFade;
                [blockImageView.layer addAnimation:transition forKey:nil];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"failt to load seller commodity detail images");
        }];
        [self addSubview:imageView];
        [imageView setHidden:(index != 0)];
        [_imagePages addObject:imageView];
    }
#endif
}


- (void)commodityImageTap:(UITapGestureRecognizer *)tap {
}


@end
