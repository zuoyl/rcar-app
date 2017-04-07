//
//  SellerCommentCell.m
//  CarSeller
//
//  Created by jenson.zuo on 8/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerCommentCell.h"

@implementation SellerCommentCell

@synthesize timeLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.rateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 200, 15, 80, 20)];
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 120, 15, 100, 20)];
        self.rateLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.rateLabel];
        [self addSubview:self.timeLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SellerCommentModel *)model {
    self.textLabel.text = model.user;
    self.detailTextLabel.text = model.content;
    self.timeLabel.text = model.time;
    self.rateLabel.text = model.rate;;
    
    if (model.image_url != nil) {
        NSString *url = [[RCar imageServer] stringByAppendingString:model.image_url];
        url = [url stringByAppendingString:@"?target=seller"];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"train"] options:SDWebImageOption];
    }
    
}

@end
