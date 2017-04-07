//
//  SizesableImageTableViewCell.m
//  CarUser
//
//  Created by jenson.zuo on 30/1/2016.
//  Copyright © 2016 CloudStone Tech. All rights reserved.
//

#import "SizeableImageTableViewCell.h"

@interface SizeableImageTableViewCell()
@property (nonatomic, assign) CGSize imageSize;
@end

@implementation SizeableImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageSize:(CGSize)imageSize {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.imageSize = imageSize;
        [self.imageView setContentMode:UIViewContentModeScaleToFill];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 8.0;
        
        
        
        return self;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(5 , 5, self.imageSize.width - 10, self.imageSize.height - 10);
}

@end
