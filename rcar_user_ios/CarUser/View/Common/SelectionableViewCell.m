//
//  GeneralTableViewCell.h
//  CarSeller
//
//  Created by jenson.zuo on 31/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "SelectionTableViewCell.h"

@implementation SelectionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self creat];
    }
    return self;
}

- (void)creat{
    if (m_checkImageView == nil) {
        m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unselected.png"]];
        m_checkImageView.frame = CGRectMake(self.frame.size.width - 40, 10, 30, 30);
        [self addSubview:m_checkImageView];
    }
}



- (void)setChecked:(BOOL)checked{
    if (checked) {
		m_checkImageView.image = [UIImage imageNamed:@"Selected.png"];
		self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
	}
	else {
		m_checkImageView.image = [UIImage imageNamed:@"Unselected.png"];
		self.backgroundView.backgroundColor = [UIColor whiteColor];
	}
	m_checked = checked;
}

- (void)setFrame:(CGRect)frame {
    m_checkImageView.frame = CGRectMake(frame.size.width - 40, 10, 30, 30);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)hideSelectionImage:(BOOL)hide {
    [m_checkImageView setHidden:hide];
}

@end