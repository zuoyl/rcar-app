//
//  SellerInfoCell.m
//  CarSeller
//
//  Created by jenson.zuo on 8/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerInfoCell.h"


@interface SellerInfoCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) UILabel *addrLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIImageView *myImageView;
@end

@implementation SellerInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 55.f, 55.f)];
        [self.myImageView setContentMode:UIViewContentModeScaleToFill];
        
        [self addSubview:self.myImageView];
        // name label
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70.f, 5, 240.f, 15.f)];
        self.nameLabel.font = [UIFont systemFontOfSize:15.f];
        [self addSubview:self.nameLabel];
        
        // intro label
        self.introLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 25.f, 240.f, 15.f)];
        self.introLabel.font = [UIFont systemFontOfSize:13.f];
        [self addSubview:self.introLabel];
        // name label
        self.addrLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 45.f, 240.f, 15.f)];
        self.addrLabel.font = [UIFont systemFontOfSize:13.f];
        [self addSubview:self.addrLabel];
        
        // type label
        self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 40, 5, 40, 20)];
        self.typeLabel.font = [UIFont systemFontOfSize:12.f];
        self.typeLabel.textColor = [UIColor blueColor];
        [self addSubview:self.typeLabel];
        
        return self;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [self.typeLabel setFrame:CGRectMake(frame.size.width - 40.f, 5, 40, 20)];
}

- (void)setModel:(SellerInfoModel *)model {
    self.nameLabel.text = model.name;
    self.introLabel.text = model.intro;
    self.addrLabel.text = model.address;
    
    if ([model.type isEqualToString:@"normal"]) {
        self.typeLabel.hidden = false;
        self.typeLabel.text = @"商家";
    } else {
        self.typeLabel.hidden = false;
        self.typeLabel.text = @"4S";
    }
    
    // image view
    if (model.images != nil && model.images.count > 0){
        NSString *url = [[RCar imageServer] stringByAppendingString:model.images[0]];
        url = [url stringByAppendingString:@"?target=seller"];
        
        [self.myImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"train"] options:SDWebImageOption];
    } else {
        [self.myImageView setImage:[UIImage imageNamed:@"bus"]];
    }
}

@end
