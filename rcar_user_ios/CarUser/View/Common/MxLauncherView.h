//
//  MMScrollPresenter.h
//  MMScrollPresenter
//
//  Created by Malleo, Mitch on 10/31/14.
//

#import <UIKit/UIKit.h>

@class MxLauncherView;

@protocol MxLauncherViewDelegate <NSObject>
@required
- (void) launcherView:(MxLauncherView *)view page:(NSInteger)page index:(NSInteger)index;
@end

@interface MxLauncherView : UIView
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) NSInteger padding;
@property (nonatomic, retain) id<MxLauncherViewDelegate> delegate;

- (void)addImageArray:(NSArray *)imageArray;

@end
