//
//  RadioButton.h
//  CarSeller
//
//  Created by jenson.zuo on 31/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RadioButtonDelegate <NSObject>
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString*)groupId;
@end

@interface RadioButton : UIView {
    NSString *_groupId;
    NSUInteger _index;
    UIButton *_button;
}
@property(nonatomic,retain)NSString *groupId;
@property(nonatomic,assign)NSUInteger index;

-(id)initWithGroupId:(NSString*)groupId index:(NSUInteger)index;
- (void) setChecked:(BOOL)isChecked;
+(void)addObserverForGroupId:(NSString*)groupId observer:(id)observer;

@end
