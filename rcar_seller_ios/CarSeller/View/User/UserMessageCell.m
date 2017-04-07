//
//  UserMessageCell.m
//  CarSeller
//
//  Created by jenson.zuo on 24/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "UserMessageCell.h"
#import "UserMessageCellModel.h"
#import "UserMessageModel.h"
#import "UIImage+ResizeImage.h"


@implementation UserMessageCell {
    UILabel *_timeLabel;
    UIImageView *_iconView;
    UIButton *_textView;
    UserMessageCellModel *_model;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLabel];
        
        _iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];
        
        _textView = [UIButton buttonWithType:UIButtonTypeCustom];
        _textView.titleLabel.numberOfLines = 0;
        _textView.titleLabel.font = [UIFont systemFontOfSize:13];
        _textView.contentEdgeInsets = UIEdgeInsetsMake(textPadding, textPadding, textPadding, textPadding);
        [self.contentView addSubview:_textView];
    }
    return self;
}

- (void)setModel:(UserMessageCellModel *)model {
    _model = model;
    UserMessageModel *message = model.message;
    
    _timeLabel.frame = model.timeFrame;
    _timeLabel.text = message.time;
    
    _iconView.frame = model.iconFrame;
    NSString *iconStr = (message.flag == MessageTypeMe)? @"me" : @"other";
    _iconView.image = [UIImage imageNamed:iconStr];
    
    _textView.frame = model.textFrame;
    NSString *textBg = (message.flag == MessageTypeMe)? @"chat_receive_nor": @"chat_send_nor";
    UIColor *textColor = (message.flag == MessageTypeMe) ? [UIColor blackColor] : [UIColor whiteColor];
    [_textView setTitleColor:textColor forState:UIControlStateNormal];
    [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
    [_textView setTitle:message.content forState:UIControlStateNormal];
}

@end
