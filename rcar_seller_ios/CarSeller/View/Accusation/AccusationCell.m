//
//  AccusationCell.m
//  CarSeller
//
//  Created by jenson.zuo on 12/5/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "AccusationCell.h"

@implementation AccusationCell


- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(AccusationModel *)model {
    self.textLabel.text = model.title;
    // check activities status
    if ([model.status isEqualToString: kAccusationStatusNew])
        self.detailTextLabel.text = @"新投诉";
    else if ([model.status isEqualToString: kAccusationStatusCompleted])
        self.detailTextLabel.text = @"结束";
    else if ([model.status isEqualToString:kAccusationStatusSellerWait])
        self.detailTextLabel.text = @"等待商家确认";
    else if ([model.status isEqualToString: kAccusationStatusSystemWait])
        self.detailTextLabel.text = @"等待系统确认";
    else
        self.detailTextLabel.text = @"未知状态";
    
    // check wether image is loaded
    if (model.images == nil) {
        [self.imageView setImage:[UIImage imageNamed:@"business_default"]];
        return;
    }
    if (model.images.count > 0) {
        NSString *url = [[RCar imageServer] stringByAppendingString:model.images[0]];
        url = [url stringByAppendingString:@"?target=seller&size=32x32&thumbnail=yes"];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"business_default"] options:SDWebImageOption ];
    }
}


@end
