//
//  FaultReportView.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-19.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimbusPagingScrollView.h"
#import "QBImagePickerController.h"
#import "MJPhotoBrowser.h"

@interface FaultReportView : UIView <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, QBImagePickerControllerDelegate, MJPhotoBrowserDelegate>

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;
@end
