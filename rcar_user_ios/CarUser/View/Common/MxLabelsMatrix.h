

#import <UIKit/UIKit.h>

@interface MxLabelsMatrix : UIView {
    NSArray *columnsWidths;
    uint numRows;
    uint dy;
}

- (id)initWithFrame:(CGRect)frame andColumnsWidths:(NSArray*)columns;
- (void)addRecord:(NSArray*)record;
- (void)clear;
@end