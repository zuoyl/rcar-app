

#import "CheckBoxView.h"

#define Q_CHECK_ICON_WH                    (15.0)
#define Q_ICON_TITLE_MARGIN                (5.0)

@implementation CheckBoxView

@synthesize _checkDelegate = _delegate;
@synthesize checked = _checked;
@synthesize userInfo = _userInfo;

- (id)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        _checkDelegate = delegate;
        
        self.exclusiveTouch = YES;
        [self setImage:[UIImage imageNamed:@"checkbox1_unchecked.png"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"checkbox1_checked.png"] forState:UIControlStateSelected];
        [self addTarget:self action:@selector(checkboxBtnChecked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setChecked:(BOOL)checked {
    if (_checked == checked) {
        return;
    }
    
    _checked = checked;
    self.selected = checked;
    
    if (_checkDelegate && [_checkDelegate respondsToSelector:@selector(didSelectedCheckBox:checked:)]) {
        [_checkDelegate didSelectedCheckBox:self checked:self.selected];
    }
}

- (void)checkboxBtnChecked {
    self.selected = !self.selected;
    _checked = self.selected;
    
    if (_checkDelegate && [_checkDelegate respondsToSelector:@selector(didSelectedCheckBox:checked:)]) {
        [_checkDelegate didSelectedCheckBox:self checked:self.selected];
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, (CGRectGetHeight(contentRect) - Q_CHECK_ICON_WH)/2.0, Q_CHECK_ICON_WH, Q_CHECK_ICON_WH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(Q_CHECK_ICON_WH + Q_ICON_TITLE_MARGIN, 0,
                      CGRectGetWidth(contentRect) - Q_CHECK_ICON_WH - Q_ICON_TITLE_MARGIN,
                      CGRectGetHeight(contentRect));
}

- (void)dealloc {
    _checkDelegate = nil;
}

@end
