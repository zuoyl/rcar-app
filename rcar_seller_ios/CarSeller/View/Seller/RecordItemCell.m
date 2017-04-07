//
//  RecordItemCell.m
//  CarSeller
//
//  Created by jenson.zuo on 21/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "RecordItemCell.h"
#import "OrderModel.h"
#import "SellerServiceModel.h"

@implementation RecordItemCell

@synthesize dateLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}

- (void)awakeFromNib {
    // Initialization code
   }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(RecordModel *)model {
    // set image
    [self.imageView setImage:[UIImage imageNamed:[SellerServiceInfoList imageNameOfService:model.type]]];
    
    self.textLabel.text = model.title;
    self.detailTextLabel.text = model.detail;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // date label
    if (!self.dateLabel) {
        self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 12, 100, 15)];
        self.dateLabel.textColor = [UIColor blackColor];
        self.dateLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.dateLabel];

    }
    self.dateLabel.text = model.date;
    
}
@end
