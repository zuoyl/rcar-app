//
//  BusinessItemCell.m
//  CarSeller
//
//  Created by jenson.zuo on 25/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "OrderItemCell.h"
#import "SellerServiceModel.h"
@implementation OrderItemCell {
    OrderModel *_model;
}

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

- (void)setModel:(OrderModel *)model {
    _model = model;
    //self.textLabel.text = model.title;
    //self.detailTextLabel.text = model.detail;
    
    // set image according to business type
    [self.imageView setImage:[UIImage imageNamed:[SellerServiceInfoList imageNameOfService:model.order_service_type]]];
    
    // create button according to business type
    if ([model.order_type isEqualToString:@"bidding"]) {
        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 30, 5, 20, 15)];
        [button1 setTitle:@"抢单" forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:12];
        [button1 addTarget:self action:@selector(businessBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button1.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:button1];
        
        UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 30, 25, 20, 15)];
        [button2 setTitle:@"忽略" forState:UIControlStateNormal];
        button2.titleLabel.font = [UIFont systemFontOfSize:12];
        [button2 addTarget:self action:@selector(skipBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button2.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:button2];
    }
}

- (void)businessBtnClicked:(id)sender {
    if ([self.bidDelegate respondsToSelector:@selector(orderExecute:)]) {
        [self.bidDelegate orderExecute:_model];
    }
    
}

- (void)skipBtnClicked:(id)sender {
    if ([self.bidDelegate respondsToSelector:@selector(orderSkip:)]) {
        [self.bidDelegate orderSkip:_model];
    }
}

@end
