//
//  SizesableImageTableViewCell.h
//  CarUser
//
//  Created by jenson.zuo on 30/1/2016.
//  Copyright © 2016 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SizeableImageTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageSize:(CGSize)imageSize;

@end
