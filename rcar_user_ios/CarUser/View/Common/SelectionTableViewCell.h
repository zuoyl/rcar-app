//
//  GeneralTableViewCell.h
//  CarSeller
//
//  Created by jenson.zuo on 31/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionTableViewCell : UITableViewCell{
    BOOL			m_checked;
    UIImageView*	m_checkImageView;
}
- (void)setChecked:(BOOL)checked;
- (void)hideSelectionImage:(BOOL)hide;
@end