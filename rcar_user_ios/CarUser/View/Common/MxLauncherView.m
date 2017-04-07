//
//  MMScrollPresenter.m
//  MMScrollPresenter
//
//  Created by Malleo, Mitch on 10/31/14.
//

#import "MxLauncherView.h"


@interface MxLauncherView()
@property (strong, nonatomic) NSMutableArray *pageArray;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation MxLauncherView

#pragma mark - Public methods

- (instancetype)init {
    self = [super init];
    if(self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.pageArray = [[NSMutableArray alloc]init];
        self.currentPage = 0;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        self.pageArray = [[NSMutableArray alloc]init];
        UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipePage:)];
        [swipeLeftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
        
        UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipePage:)];
        [swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
        
        [self addGestureRecognizer:swipeLeftGesture];
        [self addGestureRecognizer:swipeRightGesture];
        self.currentPage = 0;
        self.userInteractionEnabled = YES;
    }
    return self;
    
}
- (UIView *)createPage:(NSInteger)pageIndex images:(NSArray *)images {
    CGFloat heigh = (self.frame.size.height - self.edgeInsets.top - self.edgeInsets.bottom - (self.row -1)*self.padding)/self.row;
    CGFloat width = (self.frame.size.width - self.edgeInsets.left - self.edgeInsets.right - (self.column - 1) *self.padding)/ self.column;
    // create a new page
    UIView *pageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    NSInteger col, row;
    for (row = 0; row < self.row; row++) {
        for (col = 0; col < self.column; col++) {
            // get index
            NSInteger index = row * self.column + col;
            if ((pageIndex *self.row *self.column + index) >= images.count)
                break;
            
            index = pageIndex *self.row * self.column + row * self.column + col;
            NSLog(@"Page:%lu, [%lu, %lu] = %lu, %@", pageIndex, row, col, index, images[index]);
            
            CGFloat x = self.edgeInsets.left + col * width + col*self.padding;
            CGFloat y = self.edgeInsets.top + row *heigh + row*self.padding;
            // create image view
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:images[index]]];
            [imageView setFrame:CGRectMake(x, y, width, heigh)];
            [imageView setImage:[UIImage imageNamed:images[index]]];
            imageView.tag = index;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapped:)];
            [imageView addGestureRecognizer:tap];
            
            [pageView addSubview:imageView];
        }
    }
    return pageView;
}

- (void)addImageArray:(NSArray *)imageArray {
    if (imageArray == nil || imageArray.count == 0)
        return;
    
    // create tap recognizer
    NSInteger pageCount = imageArray.count/(self.row *self.column) + 1;
    for (NSInteger page = 0; page < pageCount ; page++) {
        UIView *pageView = [self createPage:page images:imageArray];
        [self addSubview:pageView];
        [self.pageArray addObject:pageView];
    }
    [self bringSubviewToFront:self.pageArray[self.currentPage]];
}


- (void)swipePage:(UISwipeGestureRecognizer *)swipe {
    UIView *currentView = [self.pageArray objectAtIndex:self.currentPage];
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.currentPage < self.pageArray.count - 1)
            self.currentPage++;
        
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self.currentPage > 0)
            self.currentPage--;
        
    }
    
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.8f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    
    UIView *newView = [self.pageArray objectAtIndex:self.currentPage];
    [newView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [currentView setHidden:YES];
    [newView setHidden:NO];
    [self bringSubviewToFront:newView];
    
    [UIView commitAnimations];
}


- (void)imageTapped:(UITapGestureRecognizer *)tap {
    UIImageView *imageView = (UIImageView *)tap.view;
    NSInteger index = imageView.tag;
    if (self.delegate)
       [self.delegate launcherView:self page:self.currentPage index:index];
    
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentX = self.currentPage *self.frame.size.width;
    
    if (scrollView.contentOffset.x > currentX && self.currentPage < (self.pageArray.count -1)) { // move right
        [scrollView setContentOffset:CGPointMake(currentX + self.frame.size.width, 0)];
        self.currentPage++;
        return;
    } else if (scrollView.contentOffset.x < currentX && self.currentPage > 1) {
        [scrollView setContentOffset:CGPointMake(currentX - self.frame.size.width,  0)];
        self.currentPage--;
        return;
        
    }
}

@end
