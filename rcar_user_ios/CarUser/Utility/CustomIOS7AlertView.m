//
//  CustomIOS7AlertView.m
//  CustomIOS7AlertView
//
//  Created by Richard on 20/09/2013.
//  Copyright (c) 2013 Wimagguc.
//
//  Lincesed under The MIT License (MIT)
//  http://opensource.org/licenses/MIT
//

#import "CustomIOS7AlertView.h"
const static CGFloat kCustomIOS7AlertViewDefaultButtonHeight       = 60;
const static CGFloat kCustomIOS7AlertViewDefaultButtonSpacerHeight = 1;
const static CGFloat kCustomIOS7AlertViewCornerRadius              = 7;
//const static CGFloat kCustomIOS7MotionEffectExtent                 = 10.0;

@implementation CustomIOS7AlertView

CGFloat buttonHeight = 0;
CGFloat buttonSpacerHeight = 0;

@synthesize parentView, containerView, dialogView, buttonView;
@synthesize delegate;
@synthesize buttonTitles;
@synthesize useMotionEffects;

- (id)initWithParentView: (UIView *)_parentView
{
    self = [super initWithFrame:_parentView.frame];
    
    if (self) {
        parentView = _parentView;
        delegate = self;
        useMotionEffects = false;
        buttonTitles = @[@"Close"];
        _yMotion = 80;
        _yMotionIPhone5 = 60;
    }
    return self;
}

// Create the dialog view, and animate opening the dialog
- (void)show
{
    self.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self addGestureRecognizer:tap];
    
    dialogView = [self createContainerView];
    
    if (useMotionEffects) {
        [self applyMotionEffects];
    }

    dialogView.layer.opacity = 0.5f;
    dialogView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);

    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    [self addSubview:dialogView];
    [parentView addSubview:self];

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         dialogView.layer.opacity = 1.0f;
                         dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
					 }
					 completion:^(BOOL finished) {
                         // 文本框自动获取焦点显示键盘
                         for(UIView *v in self.containerView.subviews){
                             if ([v isKindOfClass:[UITextField class]] ) {
                                 [v becomeFirstResponder];
                                 // 弹出键盘后，alert框上移
                                 [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                                                  animations:^{
                                                      CGRect f = dialogView.frame;
                                                      f.origin.y -= ([UIScreen mainScreen].bounds.size.height<=480?_yMotion:_yMotionIPhone5);
                                                      dialogView.frame = f;
                                                  } completion:nil
                                  ];
                                 break;
                             }
                         }
                     }
     ];
}

// Button has touched
- (IBAction)customIOS7dialogButtonTouchUpInside:(id)sender
{
   // [delegate customIOS7dialogButtonTouchUpInside:self clickedButtonAtIndex:[sender tag]];
}

// Default button behaviour
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Clicked! %d, %d", buttonIndex, [alertView tag]);
    [self close];
}

// Dialog close animation then cleaning and removing the view from the parent
- (void)close
{
    [self removeGestureRecognizer:self.gestureRecognizers[0]];
    dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
    dialogView.layer.opacity = 1.0f;

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         dialogView.layer.transform = CATransform3DMakeScale(0.6f, 0.6f, 1.0);
                         dialogView.layer.opacity = 0.0f;
					 }
					 completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
					 }
	 ];
}

- (void)setSubView: (UIView *)subView
{
    containerView = subView;
}

// Creates the container view here: create the dialog, then add the custom content and buttons
- (UIView *)createContainerView
{
    if ([buttonTitles count] > 0) {
        buttonHeight       = kCustomIOS7AlertViewDefaultButtonHeight;
        buttonSpacerHeight = kCustomIOS7AlertViewDefaultButtonSpacerHeight;
    } else {
        buttonHeight = 0;
        buttonSpacerHeight = 0;
    }

    if (containerView == NULL) {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    }

    CGFloat dialogWidth = containerView.frame.size.width;
    CGFloat dialogHeight = containerView.frame.size.height + buttonHeight + buttonSpacerHeight;

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

//    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
//    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
//        CGFloat tmp = screenWidth;
//        screenWidth = screenHeight;
//        screenHeight = tmp;
//    }

    // For the black background
    [self setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];

    // This is the dialog's container; we attach the custom content and the buttons to this one
    CGRect frame = CGRectMake((screenWidth - dialogWidth) / 2, (screenHeight - dialogHeight) / 2, dialogWidth,dialogHeight);
    UIView *dialogContainer = [[UIView alloc] initWithFrame:frame];

    if (self.background!=nil) {
        [dialogContainer setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:_background]]];
    }else{
        // First, we style the dialog to match the iOS7 UIAlertView >>>
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = dialogContainer.bounds;
        gradient.colors = [NSArray arrayWithObjects:
                           (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                           (id)[[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0f] CGColor],
                           (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                           nil];
        
        CGFloat cornerRadius = kCustomIOS7AlertViewCornerRadius;
        gradient.cornerRadius = cornerRadius;
        [dialogContainer.layer insertSublayer:gradient atIndex:0];
        
        dialogContainer.layer.cornerRadius = cornerRadius;
        dialogContainer.layer.borderColor = [[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f] CGColor];
        dialogContainer.layer.borderWidth = 1;
        dialogContainer.layer.shadowRadius = cornerRadius + 5;
        dialogContainer.layer.shadowOpacity = 0.1f;
        dialogContainer.layer.shadowOffset = CGSizeMake(0 - (cornerRadius+5)/2, 0 - (cornerRadius+5)/2);
    }
    

    // There is a line above the button
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, dialogContainer.bounds.size.height - buttonHeight - buttonSpacerHeight, dialogContainer.bounds.size.width, buttonSpacerHeight)];
//    lineView.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
//    [dialogContainer addSubview:lineView];
    // ^^^

    // Add the custom container if there is any
    [dialogContainer addSubview:containerView];

    // Add the buttons too
    [self addButtonsToView:dialogContainer];

    return dialogContainer;
}

- (void)addButtonsToView: (UIView *)container
{
    CGFloat buttonWidth = (container.bounds.size.width-20-(buttonTitles.count-1)*10) / [buttonTitles count];

    for (int i=0; i<[buttonTitles count]; i++) {

        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];

        [closeButton setFrame:CGRectMake(10+i*(buttonWidth+10), container.bounds.size.height - buttonHeight+10, buttonWidth, buttonHeight-20)];

        [closeButton addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTag:i];

        [closeButton setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        if (i%2==0) {
            [closeButton setBackgroundImage:[UIImage imageNamed:@"user_blue_btn"] forState:UIControlStateNormal];
            [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [closeButton setBackgroundImage:[UIImage imageNamed:@"user_white_btn"] forState:UIControlStateNormal];
            [closeButton setTitleColor:[UIColor colorWithHex:@"6e6e6e"] forState:UIControlStateNormal];
        }
        [closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [closeButton.layer setCornerRadius:kCustomIOS7AlertViewCornerRadius];

        [container addSubview:closeButton];
    }
}

// Add motion effects
- (void)applyMotionEffects {

//    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
//        return;
//    }
//
//    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
//                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
//    horizontalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
//    horizontalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);
//
//    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
//                                                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
//    verticalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
//    verticalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);
//
//    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
//    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];
//
//    [dialogView addMotionEffect:motionEffectGroup];
}

@end