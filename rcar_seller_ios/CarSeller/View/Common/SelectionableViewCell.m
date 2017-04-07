//
//  GeneralTableViewCell.h
//  CarSeller
//
//  Created by jenson.zuo on 31/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "SelectionTableViewCell.h"



@implementation SelectionTableViewCell

@synthesize checkedImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self creat];
    }
    return self;
}

- (void)creat{
    if (self.checkedImageView == nil) {
        self.checkedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unselected.png"]];
        self.checkedImageView.frame = CGRectMake(self.frame.size.width - 40, 10, 30, 30);
        [self addSubview:self.checkedImageView];
    }
}

- (void)enableMultiSelection:(BOOL)enable {
    [self.checkedImageView setHidden:!enable];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.checkedImageView.image = [UIImage imageNamed:@"Selected.png"];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
    }
    else {
        self.checkedImageView.image = [UIImage imageNamed:@"Unselected.png"];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    
}

@end