//
//  UserMessageCellModel.m
//  CarSeller
//
//  Created by jenson.zuo on 24/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "UserMessageCellModel.h"

#import "UserMessageModel.h"
#import "NSString+Extension.h"

#define timeH 40
#define padding 10
#define iconW 40
#define iconH 40
#define textW 150

@implementation UserMessageCellModel

- (void)setMessage:(UserMessageModel *)message {
    _message = message;
    CGRect frame = [UIScreen mainScreen].bounds;
    
    //1.时间的Frame
    if (message.showTime) {
        CGFloat timeFrameX = 0;
        CGFloat timeFrameY = 0;
        CGFloat timeFrameW = frame.size.width;
        CGFloat timeFrameH = timeH;
        _timeFrame = CGRectMake(timeFrameX, timeFrameY, timeFrameW, timeFrameH);
    }
    
    //2.头像的Frame
    CGFloat iconFrameX = (message.flag == MessageTypeMe)? padding : (frame.size.width - padding - iconW);
    CGFloat iconFrameY = CGRectGetMaxY(_timeFrame);
    CGFloat iconFrameW = iconW;
    CGFloat iconFrameH = iconH;
    _iconFrame = CGRectMake(iconFrameX, iconFrameY, iconFrameW, iconFrameH);
    
    //3.内容的Frame
    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
    CGSize textSize = [message.content sizeWithFont:[UIFont systemFontOfSize:14.0] maxSize:textMaxSize];
    CGSize textRealSize = CGSizeMake(textSize.width + textPadding * 2, textSize.height + textPadding * 2);
    CGFloat textFrameY = iconFrameY;
    CGFloat textFrameX = (message.flag == MessageTypeMe) ? (2 * padding + iconFrameW) : (frame.size.width - (padding * 2 + iconFrameW + textRealSize.width));
    _textFrame = (CGRect){textFrameX, textFrameY, textRealSize};
    
    //4.cell的高度
    _cellHeght = MAX(CGRectGetMaxY(_iconFrame), CGRectGetMaxY(_textFrame)) + padding;
}

@end
