//
//  MxTextField.m
//  CarSeller
//
//  Created by jenson.zuo on 9/3/2016.
//  Copyright © 2016 Cloud Stone Technology. All rights reserved.
//

#import "MxTextField.h"
#import "TooltipView.h"
#import "InvalidTooltipView.h"
#import "ValidTooltipView.h"
#import "QuartzCore/QuartzCore.h"


@interface MxTextField () <UITextFieldDelegate>
@property (nonatomic, strong) Validator *validator;
@property (nonatomic, strong) TooltipView *tooltipView;

@end

@implementation MxTextField
@synthesize name;
@synthesize group;
@synthesize mxDelegate;
@synthesize isValid;


- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.delegate = self;
        self.validator = [[Validator alloc]init];
        self.validator.delegate = self;
        self.isValid = YES;
    }
    return self;
}

- (void)addRule:(Rule *)rule {
    [self.validator putRule:rule];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.tooltipView != nil) {
        [self.tooltipView removeFromSuperview];
        self.tooltipView = nil;
    }
    [self.validator validate];
}

#pragma mark - ValidatorDelegate

- (void) preValidation{
    self.layer.borderWidth = 0;
}

- (void)onValidatorSuccess:(NSArray *)rules {
    if (self.tooltipView != nil) {
        [self.tooltipView removeFromSuperview];
        self.tooltipView  = nil;
    }
    self.isValid = YES;
    if (self.mxDelegate != nil && [self.mxDelegate respondsToSelector:@selector(mxTextFieldDidEndEditing:)])
        [self.mxDelegate mxTextFieldDidEndEditing:self];
}

- (void)onValidatorFailure:(Rule *)failedRule {
    NSLog(@"Failed");
    self.isValid = NO;
    failedRule.textField.layer.borderColor   = [[UIColor redColor] CGColor];
    failedRule.textField.layer.cornerRadius  = 5;
    failedRule.textField.layer.borderWidth   = 2;
    
    CGPoint point           = [failedRule.textField convertPoint:CGPointMake(0.0, failedRule.textField.frame.size.height - 4.0) toView:self];
    CGRect tooltipViewFrame = CGRectMake(6.0, point.y, 309.0, _tooltipView.frame.size.height);
    
    _tooltipView       = [[InvalidTooltipView alloc] init];
    _tooltipView.frame = tooltipViewFrame;
    _tooltipView.text  = [NSString stringWithFormat:@"%@",failedRule.failureMessage];
    _tooltipView.rule  = failedRule;
    [self addSubview:_tooltipView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
