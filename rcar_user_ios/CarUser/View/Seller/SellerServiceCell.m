//
//  ServiceOutlineCell.m
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerServiceCell.h"

@implementation SellerServiceCell {
    SellerServiceModel *_serviceModel;
    BOOL _selectableMode;
}

@synthesize priceLabel;
@synthesize selectBtn;
@synthesize serviceDelegate;
@synthesize myImageView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        _selectableMode = false;
        
        // image view
        self.myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
        self.myImageView.layer.masksToBounds = YES;
        self.myImageView.layer.cornerRadius = 8.0;
        [self addSubview:self.myImageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 15, self.frame.size.width - 150, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [self addSubview:self.titleLabel];
        
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 100, 15, 80, 20)];
        //[self.priceLabel setContentMode:UIViewContentModeCenter];
        self.priceLabel.font = [UIFont systemFontOfSize:17.f];
        
        self.selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 30, 15, 20, 20)];
        
        [self.selectBtn addTarget:self action:@selector(selectBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"Unselected.png"] forState:UIControlStateNormal];
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"Selected.png"] forState:UIControlStateSelected];
        [self.selectBtn setHidden:true];
        self.selectBtn.enabled = false;
        
        
        [self addSubview:self.selectBtn];
        [self addSubview:priceLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)selectBtnTaped:(id)sender {
    [selectBtn setSelected:!selectBtn.selected];
    if (_selectableMode && self.serviceDelegate != nil) {
        [self.serviceDelegate selectSellerService:_serviceModel forState:selectBtn.selected];
    }
}

- (void)setSelectableMode:(BOOL)on {
    [self.selectBtn setHidden:false];
    self.selectBtn.enabled = true;
    [self bringSubviewToFront:self.selectBtn];
    
    _selectableMode = on;
    if (_selectableMode) {
        selectBtn.enabled = true;
    }
}

- (void)setModelAndFrame:(SellerServiceModel *)model frame:(CGRect)frame {
    if (model == nil) return;
    [self.priceLabel setFrame:CGRectMake(frame.size.width - 100, 15, 70, 20)];
    [self.selectBtn setFrame:CGRectMake(frame.size.width - 30, 15, 20, 20)];
    
    self.titleLabel.text = model.title;

    self.priceLabel.contentMode = UIControlContentVerticalAlignmentCenter;
    self.priceLabel.font = [UIFont systemFontOfSize:15.f];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceLabel.text = [NSString stringWithFormat:@"%@元", model.price];
    
    
    _serviceModel = model;
    
    if (model.images != nil && model.images.count > 0) {
        NSString *url = [[RCar imageServer] stringByAppendingString:model.images[0]];
        url = [url stringByAppendingString:@"?target=seller&thumbnail=yes&size=32x32"];
        [self.myImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"adv_banner"] options:SDWebImageOption];
    } else {
        [self.myImageView setImage:[UIImage imageNamed:@"train"]];
    }
}
@end
