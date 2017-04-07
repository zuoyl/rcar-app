//
//  SelectionButton.m
//  CarSeller
//
//  Created by jenson.zuo on 30/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "SelectionButton.h"

@implementation SelectionButton {
    BOOL _isSelected;
    UIImageView *_imageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if(self) {
        
        /*--------------------------------------------------------------------------
         This type of button is created by default.
         --------------------------------------------------------------------------*/
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"001"]];
        _imageView.frame = CGRectMake(self.frame.origin.x + 5, self.frame.origin.y + 5, 30, 30);
        [self addSubview:_imageView];
        [self bringSubviewToFront:_imageView];
        [_imageView setHidden:YES];
        _isSelected = false;
        
        //[self setStyleType:ACPButtonGrey];
    }
    return self;
}


- (void)setSelected:(BOOL)selected {
    _isSelected = selected;
    [_imageView setHidden:!_isSelected];
}

- (BOOL)isSelected {
    return _isSelected;
}

@end
