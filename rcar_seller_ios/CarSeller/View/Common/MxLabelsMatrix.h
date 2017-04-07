

#import <UIKit/UIKit.h>

@interface MxLabelsMatrix : UIView
@property (nonatomic, strong) NSArray *columnsWidths;
@property (nonatomic, assign) NSInteger numRows;
@property (nonatomic, assign) NSInteger dy;

- (id)initWithFrame:(CGRect)frame andColumnsWidths:(NSArray*)columns;
- (void)addRecord:(NSArray*)record;
@end