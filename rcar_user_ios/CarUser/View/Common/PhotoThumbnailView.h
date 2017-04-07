//
//  PhotoThumbnailView.h
//  CarSeller
//
//  Created by jenson.zuo on 25/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CXPhotoLoadingViewProtocol.h"
#import "MWPhoto.h"


@interface PhotoThumbnailView : UIImageView
@property (nonatomic, strong) UIImage *fullImage;
@property (nonatomic, retain) MWPhoto *photo;
@property (nonatomic, weak) PHAsset *asset;

- (id)initWithPhoto:(MWPhoto *)photo size:(CGSize)size;
- (id)initWithAsset:(PHAsset *)asset;
@end
