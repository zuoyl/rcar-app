//
//  ActivityOutlineCell.m
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerActivityCell.h"

@implementation SellerActivityCell

@synthesize  endLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.endLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 120, 15, 100, 20)];
        self.endLabel.font = [UIFont systemFontOfSize:12.f];
        [self addSubview:endLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(SellerActivityModel *)model {
    if (model.end_date != nil)
        self.endLabel.text = [@"截止" stringByAppendingString:model.end_date];
    self.textLabel.text = model.title;
    self.detailTextLabel.text = model.detail;
    
    if (model.url == nil || [model.url isEqualToString:@""])
        self.accessoryType = UITableViewCellAccessoryNone;
    
    if (model.image != nil && ![model.image isEqualToString:@""]) {
        NSString *url = [[RCar imageServer] stringByAppendingString:model.image];
        url = [url stringByAppendingString:@"?target=seller"];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"adv_banner"] options:SDWebImageOption];
    }
}

@end
