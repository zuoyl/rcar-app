//
//  CommodityOutlineCell.m
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerCommodityCell.h"
#import "SellerModel.h"

@interface SellerCommodityCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *cImageView;
@property (nonatomic, strong) UILabel *bandLabel;
@property (nonatomic, strong) StarRateView *rateView;




@end

@implementation SellerCommodityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        
        // commodity image view
        self.cImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 60.f, 60.f)];
        [self addSubview:self.cImageView];
        // name
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80.f, 5, self.bounds.size.width - 80, 15.f)];
        self.nameLabel.font = [UIFont systemFontOfSize:15.f];
        [self addSubview:self.nameLabel];
        // band
        self.bandLabel = [[UILabel alloc]initWithFrame:CGRectMake(80.f, 25, self.bounds.size.width - 80, 15.f)];
        self.bandLabel.font = [UIFont systemFontOfSize:15.f];
        [self addSubview:self.bandLabel];
        
        // rate
        self.rateView = [[StarRateView alloc]initWithFrame:CGRectMake(80.f, 45.f, 50.f, 15.f)];
        [self addSubview:self.rateView];
        self.rateView.midMargin = 0;
        self.rateView.leftMargin = 0;
        self.rateView.rightMargin = 0;
        [self.rateView setMaxRate:5];
        [self.rateView setRate:1];
        
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    //self.imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self.placeholder action:@selector(commodityImageTap:)];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SellerCommodityModel *)model {
    self.nameLabel.text = model.name;
    [self.rateView setRate:model.rate.floatValue * self.rateView.maxRate ];
    self.bandLabel.text = model.brand;
    
    if (model.seller_id == nil) {
        model.seller_id = [SellerModel sharedClient].seller_id;
    }
    // set imageview frame size
    [self.imageView setFrame:CGRectMake(0, 0, 44.f, 44.f)];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    if (model.images == nil || model.images.count == 0) {
        // there are no images for this commodity
        //self.placeholder = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"business_default"]];
        self.cImageView.image = [UIImage imageNamed:@"business_default"];
       // [self addSubview:self.placeholder];
        return;
    }
    
    NSString *imageUrl = [model.images objectAtIndex:0];
    NSString *url = [[RCar imageServer] stringByAppendingString:imageUrl];
    url = [url stringByAppendingString:@"?target=user&seller=32x32&thumbnail=yes"];
    [self.cImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"adv_banner"] options:SDWebImageOption];
}




@end
