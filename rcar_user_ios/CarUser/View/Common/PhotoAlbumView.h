//
//  PhotoAlbumView.h
//  CarSeller
//
//  Created by jenson.zuo on 29/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    PhotoAlbumMode_View,
    PhotoAlbumMode_Edit,
} PhotoAlbumMode;


@interface PhotoAlbumView :UIView
@property (nonatomic, assign) NSInteger maxOfImage;
@property (nonatomic, assign) NSInteger numberOfImage;

+ (instancetype)initWithViewController:(UIViewController *)controller frame:(CGRect)frame mode:(PhotoAlbumMode)mode;
- (void)loadImagesFromTarget:(NSArray *)imageNameArray target:(NSString *)target;
- (void)loadImageData:(NSArray *)imageDataArray;
- (void)changeMode:(PhotoAlbumMode)mode;
- (NSArray *)getImageDatasWithJpegCompress:(CGFloat)compressionQuality;
@end
