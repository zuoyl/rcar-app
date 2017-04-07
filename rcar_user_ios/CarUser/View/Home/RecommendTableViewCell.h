//
//  RecommendTableViewCell.h
//  CarUser
//
//  Created by jenson.zuo on 21/10/2015.
//  Copyright © 2015 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"

@interface RecommendTableViewCell : UITableViewCell
- (void)setModelWithinFrame:(RecommendModel *)model frame:(CGRect)frame;
@end
