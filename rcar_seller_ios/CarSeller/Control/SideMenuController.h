

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SideMenuControllerDelegate <NSObject>

- (void)menuItemClicked:(NSInteger)index;

@end

@interface SideMenuController : NSObject
{
    UIView              *_backgroundMenuView;
    UIButton            *_menuButton;
    NSMutableArray      *_buttonList;
}


@property (nonatomic, retain) UIColor *menuColor;
@property (nonatomic) BOOL isOpen;

@property (nonatomic, retain) id<SideMenuControllerDelegate> delegate;

- (SideMenuController*)initWithImages:(NSArray*)buttonList;
- (void)insertMenuButtonOnView:(UIView*)view atPosition:(CGPoint)position;

@end
