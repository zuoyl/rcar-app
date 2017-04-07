//
//  SellerInfoCell.m
//  CarSeller
//
//  Created by jenson.zuo on 8/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerInfoCell.h"

@implementation SellerInfoCell {
    NSMutableArray *_imagePages;
    NSInteger _curPage;
    NSMutableArray *_images;
    SellerInfoModel *_model;
    SellerDetailInfoModel *_detailModel;
    NSString *_sellerId;
}


@synthesize imageTap;
@synthesize activity;
@synthesize serivceLabel;
@synthesize envLabel;
@synthesize contactBtn;
@synthesize nameLabel;
@synthesize detailText;
@synthesize placeholder;
@synthesize path;
@synthesize serviceDelegate;

- (void)awakeFromNib {
    // Initialization code
    _imagePages = [[NSMutableArray alloc]init];
    _images = [[NSMutableArray alloc]init];
    self.imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self.placeholder action:@selector(sellerImageTap:)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)contactBtnTaped:(id)sender {

}

- (void)setModel:(SellerInfoModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.detailText.text = model.intro;
    //if (model.services.count == 0)
    [self.contactBtn setHidden:NO];
    
    if (model.image != nil) {
        _sellerId = model.seller_id;
        [_images addObject:model.image];
        [self.activity startAnimating];
        [self loadImages];
    }
}

- (void)setDetailInfoModel:(SellerDetailInfoModel*)model {
    _detailModel = model;
    self.nameLabel.text = model.name;
    self.detailText.text = model.intro;
    _sellerId = model.seller_id;
    
    [self.contactBtn setHidden:YES];
    if (model.images.count > 0) {
        [_images addObjectsFromArray:model.images];
        [self.activity startAnimating];
        [self loadImages];
    }
}


- (void)loadImages {
    for (NSInteger index = 0; index < _images.count; index++) {
        NSString *imageUrl = [_images objectAtIndex:index];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.placeholder.frame];
        
        NSString *url = [[RCar imageServer] stringByAppendingString:imageUrl];
        url = [url stringByAppendingString:@"?target=seller&size=32x32&thumbnail=yes"];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"adv_banner"] options:SDWebImageOption ];
        [self addSubview:imageView];
        [imageView setHidden:(index != 0)];
        [_imagePages addObject:imageView];
    }
}



@end
