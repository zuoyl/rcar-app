

#import <UIKit/UIKit.h>

@protocol CheckBoxViewDelegate;

@interface CheckBoxView : UIButton {
    id<CheckBoxViewDelegate> _checkDelegate;
    BOOL _checked;
    id _userInfo;
}

@property(nonatomic, assign)id<CheckBoxViewDelegate> _checkDelegate;
@property(nonatomic, assign)BOOL checked;
@property(nonatomic, retain)id userInfo;

- (id)initWithDelegate:(id)delegate;

@end

@protocol CheckBoxViewDelegate <NSObject>

@optional

- (void)didSelectedCheckBox:(CheckBoxView *)checkbox checked:(BOOL)checked;

@end
