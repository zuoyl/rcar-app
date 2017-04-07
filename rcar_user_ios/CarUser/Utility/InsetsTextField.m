

#import "InsetsTextField.h"

@implementation  InsetsTextField
//控制  placeHolder 的位置，左右缩 5
-  (CGRect)textRectForBounds:(CGRect)bounds {
    return  CGRectInset( bounds , 5 , 5 );
}

//  控制文本的位置，左右缩 5
-  (CGRect)editingRectForBounds:(CGRect)bounds {
    return  CGRectInset( bounds , 5 , 5 );
}
@end
