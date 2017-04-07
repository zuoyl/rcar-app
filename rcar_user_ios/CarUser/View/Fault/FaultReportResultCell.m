//
//  FaultReportResultCell.m
//  CarUser
//
//  Created by jenson.zuo on 18/5/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "FaultReportResultCell.h"

@implementation FaultReportResultCell

@synthesize priceLabel;
@synthesize rateLabel;
@synthesize distanceLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 100, 20, 80, 20)];
        self.priceLabel.font = [UIFont systemFontOfSize:15.f];
        
        self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.distanceLabel.font = [UIFont systemFontOfSize:10.f];
        self.rateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.rateLabel.font = [UIFont systemFontOfSize:10.f];
        
        [self addSubview:self.priceLabel];
        [self addSubview:self.rateLabel];
        [self addSubview:self.distanceLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(SellerServiceInquiryModel *)model {
    [self.priceLabel setFrame:CGRectMake(self.frame.size.width - 100, 20, 80, 20)];
    [self.distanceLabel setFrame:CGRectMake(15, self.frame.size.height - 20, 100, 20)];
    [self.rateLabel setFrame:CGRectMake(120, self.frame.size.height - 20, 100, 20)];
    
    self.priceLabel.text = model.price;
    
    self.distanceLabel.text = model.distance;
    
    if (model.distance == nil || [model.distance isEqualToString:@""])
        self.distanceLabel.text = @"距离:无";
    else {
        self.distanceLabel.text = @"距离:";
        self.distanceLabel.text = [self.distanceLabel.text stringByAppendingString:model.distance];
    }
    self.textLabel.text = model.seller_name;
    self.detailTextLabel.text = model.address;
    
}

@end
