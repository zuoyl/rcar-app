//
//  GeneralTableViewCell.h
//  CarSeller
//
//  Created by jenson.zuo on 31/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *image;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *idxLabel;

- (void)setTitle:(NSString *)icon title:(NSString *)title;

@end
