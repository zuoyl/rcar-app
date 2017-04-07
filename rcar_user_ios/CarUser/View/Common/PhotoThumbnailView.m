//
//  PhotoThumbnailView.m
//  CarSeller
//
//  Created by jenson.zuo on 25/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "PhotoThumbnailView.h"
#import <QuartzCore/QuartzCore.h>

@interface PhotoThumbnailView ()
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation PhotoThumbnailView
@synthesize photo;
@synthesize fullImage;

- (id)initWithAsset:(PHAsset *)asset {
    if (self = [super init]) {
        self.asset = asset;
    }
    return self;
}

- (id)initWithPhoto:(MWPhoto *)aphoto size:(CGSize)size {
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self) {
        self.photo = aphoto;
        UIImage *photoImage = [self.photo underlyingImage];
        if (!photoImage) {
            [self setImage:[UIImage imageNamed:@"thumbnail_default"]];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(handleCXPhotoImageDidFinishLoad:)
                                                         name:MWPHOTO_LOADING_DID_END_NOTIFICATION
                                                       object:photo];
            
            [self.photo loadUnderlyingImageAndNotify];
        } else {
            self.fullImage = photoImage;
            UIGraphicsBeginImageContext(self.frame.size);
            [photoImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            self.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    return self;
}

- (void)handleCXPhotoImageDidFinishLoad:(NSNotification *)notification {
    id <MWPhoto> aphoto = [notification object];
    if (aphoto != self.photo) return;
    
    UIImage *photoImage = [photo underlyingImage];
    
    if (photoImage != nil) {
        UIGraphicsBeginImageContext(self.frame.size);
        [photoImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.fullImage = photoImage;
    }
}

#pragma mark - PV
- (void)displayLoading {
    if (!self.indicator) {
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.indicator setCenter:self.center];
        [self.indicator setHidesWhenStopped:YES];
        [self addSubview:self.indicator];
    }
    [self.indicator startAnimating];
}

- (void)displayFailure {
    [self.indicator stopAnimating];
}


@end
