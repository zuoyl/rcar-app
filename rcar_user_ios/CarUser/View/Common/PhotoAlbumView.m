//
//  PhotoAlbumView.m
//  CarSeller
//
//  Created by jenson.zuo on 29/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "PhotoAlbumView.h"
#import "QBImagePickerController.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "MWPhotoProtocol.h"
#import "CSImageView.h"
#import "PhotoThumbnailView.h"
@import AssetsLibrary;

#define Line_Padding 10.0f
#define Image_Width 68.0f
#define Image_Max_Num 8
#define Image_Base_Tag 1000

@interface PhotoAlbumView () <UIActionSheetDelegate, UIImagePickerControllerDelegate, QBImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIImageView *addView;
@property (nonatomic, assign) UIViewController *container;
@property (nonatomic, assign) PhotoAlbumMode mode;
@property (nonatomic, assign) CGFloat x, y;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *images;
@end


@implementation PhotoAlbumView {
    int _startX;
    int _startY;
    NSMutableArray *_thumbnails;
}

@synthesize maxOfImage;
@synthesize images;
@synthesize numberOfImage;

+ (instancetype)initWithViewController:(UIViewController *)controller frame:(CGRect)frame mode:(PhotoAlbumMode)mode {
    PhotoAlbumView *album = [[PhotoAlbumView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, Image_Width + 20)];
    if (album) {
        album.userInteractionEnabled = YES;
        album.container = controller;
        album.addView = [[UIImageView alloc]initWithFrame:CGRectMake(10.f, 10.f, Image_Width, Image_Width)];
        [album.addView setImage:[UIImage imageNamed:@"album_add_image"]];
        album.addView.userInteractionEnabled = true;
        UITapGestureRecognizer *addBtnGesture = [[UITapGestureRecognizer alloc] initWithTarget:album action:@selector(addImage:)];
        [album.addView addGestureRecognizer:addBtnGesture];
        [album addSubview:album.addView];
        album.maxOfImage = 4;
        [album initialize];
        album.mode = mode;
        album.images = [[NSMutableArray alloc]init];
        album.photos = [[NSMutableArray alloc]init];
        
        [album.addView setHidden:(mode == PhotoAlbumMode_View)];
    }
    return album;
}

- (void) initialize {
    _startX = self.addView.frame.origin.x;
    _startY = self.addView.frame.origin.y;
    self.numberOfImage = 0;
    _thumbnails = [[NSMutableArray alloc]init];
}

- (NSInteger)getNumberOfImage {
    return self.images.count;
}

- (UIImageView *)initializeThumbnail:(PhotoThumbnailView *)thumbnail {
    thumbnail.contentMode = UIViewContentModeScaleAspectFill;
    thumbnail.backgroundColor = [UIColor whiteColor];
    thumbnail.layer.borderWidth = 1;
    thumbnail.layer.borderColor = [UIColor whiteColor].CGColor;
    thumbnail.clipsToBounds = YES;
    thumbnail.userInteractionEnabled = YES;
    [thumbnail addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)]];
    thumbnail.userInteractionEnabled = YES;
    
    return thumbnail;
}

- (void)changeMode:(PhotoAlbumMode)mode {
    self.mode = mode;
    if (_thumbnails.count < self.maxOfImage) {
        [self.addView setHidden:(mode != PhotoAlbumMode_Edit)];
        // add just last thumbnail position
        PhotoThumbnailView *lastView = [_thumbnails lastObject];
        if (lastView) {
            CGFloat x = lastView.frame.origin.x + Image_Width + 10.f;
            CGFloat y = lastView.frame.origin.y;
            if ((x + Image_Width) > self.frame.size.width) {
                x = 10.f;
                y += Image_Width + 10.f;
            }
            self.addView.frame = CGRectMake(x, y, Image_Width, Image_Width);
        }
    }
}

- (void)urlPhotoLoaded:(NSNotification*) notification {
    id<MWPhoto> photo = [notification object];
    
    if ([photo underlyingImage]) {
        PhotoThumbnailView *thumbnail = [[PhotoThumbnailView alloc]initWithPhoto:photo size:CGSizeMake(Image_Width, Image_Width)];
        [self initializeThumbnail:thumbnail];
        
        [thumbnail setFrame:CGRectMake(_startX, _startY, Image_Width, Image_Width)];
        
        _startX += Image_Width + 10;
        if (_startX > self.frame.size.width) {
            _startX = 10.f;
            _startY += Image_Width + 10.f;
        }
        
        thumbnail.tag = Image_Base_Tag + _thumbnails.count;
        [self addSubview:thumbnail];
        [_thumbnails addObject:thumbnail];
        [self.images addObject:thumbnail.fullImage];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:MWPHOTO_LOADING_DID_END_NOTIFICATION object:photo];
    }
}

- (void)loadImagesFromTarget:(NSArray *)imageNameArray target:(NSString *)target {
    if (!imageNameArray || imageNameArray.count == 0)
        return;
    
    for (int i = 0; i < imageNameArray.count && i < self.maxOfImage; i++) {
        // create photo and thumbnail
        NSString *url = [NSString stringWithFormat:@"%@%@?target=%@", [RCar imageServer], imageNameArray[i], target];
        MWPhoto *photo = [MWPhoto photoWithURL:[[NSURL alloc]initWithString:url]];
        [_photos addObject:photo];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(urlPhotoLoaded:) name:MWPHOTO_LOADING_DID_END_NOTIFICATION object:photo];
        [photo performLoadUnderlyingImageAndNotify];
    }
    self.numberOfImage = imageNameArray.count;
}

- (void)tapImage:(UITapGestureRecognizer *)tap {
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    [browser setCurrentPhotoIndex:tap.view.tag - Image_Base_Tag ];
    [self.container.navigationController pushViewController:browser animated:YES];
  }

#pragma mark- CXPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return [_photos objectAtIndex:index];
}

- (void)addImage:(UITapGestureRecognizer *)gesture {
    UIActionSheet *sheet;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    }else{
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    [sheet showInView:self];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && buttonIndex == 0){
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = false;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.container presentViewController:imagePickerController animated:YES completion:nil];
        
    } else if(([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && buttonIndex == 1) || buttonIndex == 0){
#if 0
        if (![QBImagePickerController isAccessible]) {
            NSLog(@"Error: Source is not accessible.");
            return;
        }
#endif
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = true;
        imagePickerController.maximumNumberOfSelection = self.maxOfImage - _thumbnails.count;
        imagePickerController.mediaType = QBImagePickerMediaTypeImage;
        imagePickerController.assetCollectionSubtypes = @[
                  @(PHAssetCollectionSubtypeSmartAlbumUserLibrary), // Camera Roll
                 ];
        
        [self.container presentViewController:imagePickerController animated:YES completion:NULL];
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:true];
    }
}


#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.container dismissViewControllerAnimated:YES completion:NULL];
    
    __block PhotoAlbumView *blockself = self;
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    ALAssetsLibrary * assetsLibrary = [[ALAssetsLibrary alloc]init];
    [assetsLibrary writeImageToSavedPhotosAlbum:[originalImage CGImage] metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error == nil && assetURL != nil) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[assetURL,] options:nil];
            PHAsset *asset = fetchResult.firstObject;
            
            // create thumbnail
            PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
            phImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
            phImageRequestOptions.synchronous = YES;
            
            __block UIImage *thumbnail = nil;
            [[PHImageManager defaultManager]requestImageForAsset:asset
                                                      targetSize:CGSizeMake(60, 60)
                                                     contentMode:PHImageContentModeDefault
                                                         options:phImageRequestOptions
                                                   resultHandler:^(UIImage *result, NSDictionary *info) {
                                                       thumbnail = result;
                                                   }];
            
            
            [self addImageWithAsset:thumbnail fullImageWithAsset:asset];
            if (_thumbnails.count ==  blockself.maxOfImage) {
                [blockself.addView setHidden:YES];
            }
        }
    }];
}



- (void)addImageWithFullImage:(UIImage *)image fullImage:(UIImage *)fullImage{
    MWPhoto *photo = [[MWPhoto alloc]initWithImage:fullImage];
    PhotoThumbnailView *thumbnail = [[PhotoThumbnailView alloc]initWithPhoto:photo size:CGSizeMake(Image_Width, Image_Width)];
    [self initializeThumbnail:thumbnail];
    thumbnail.frame = self.addView.frame;
    thumbnail.tag = Image_Base_Tag + _thumbnails.count;
    [self addSubview:thumbnail];
    [_thumbnails addObject:thumbnail];
    [self.images addObject:fullImage];
    
    float x = thumbnail.frame.origin.x + Image_Width + 10;
    float y = thumbnail.frame.origin.y;
    if (x > 300) {
        x = _startX;
        y = thumbnail.frame.origin.y + 10 + Image_Width;
    }
    self.addView.frame = CGRectMake(x, y, Image_Width, Image_Width);
    [self.photos addObject:photo];
    self.numberOfImage++;
}

- (void)addImageWithAsset:(UIImage *)image fullImageWithAsset:(PHAsset *)fullImageAsset {
    PhotoThumbnailView *thumbnail = [[PhotoThumbnailView alloc]initWithImage:image];
    thumbnail.asset = fullImageAsset;
    thumbnail.frame = self.addView.frame;
    thumbnail.tag = Image_Base_Tag + _thumbnails.count;
    
    [self initializeThumbnail:thumbnail];
    [self addSubview:thumbnail];
    [_thumbnails addObject:thumbnail];
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    MWPhoto *photo = [[MWPhoto alloc]initWithAsset:fullImageAsset targetSize:CGSizeMake(rect.size.width, rect.size.height)];
    [self.photos addObject:photo];
    
    float x = thumbnail.frame.origin.x + Image_Width + 10;
    float y = thumbnail.frame.origin.y;
    if (x > 300) {
        x = _startX;
        y = thumbnail.frame.origin.y + 10 + Image_Width;
    }
    self.addView.frame = CGRectMake(x, y, Image_Width, Image_Width);
    self.numberOfImage++;
}

#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {

    [self.container dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:true];
    
    for (int i = 0; i < assets.count; i++) {
        PHAsset *asset = assets[i];
        PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
        phImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        phImageRequestOptions.synchronous = YES;
        
        // get thumbnail
        __block UIImage *_thumbnail = nil;
        [[PHImageManager defaultManager]requestImageForAsset:asset
                                                  targetSize:CGSizeMake(60, 60)
                                                 contentMode:PHImageContentModeDefault
                                                     options:phImageRequestOptions
                                               resultHandler:^(UIImage *result, NSDictionary *info) {
                                                   _thumbnail = result;
        }];
        
        
        [self addImageWithAsset:_thumbnail fullImageWithAsset:asset];
    }
    if (_thumbnails.count == self.maxOfImage) {
        [self.addView setHidden:YES];
    }
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self.container dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:true];
}


- (void)photoBrowserDidHidden:(MWPhotoBrowser *)photoBrowser{

}

- (NSArray *)getImageDatasWithJpegCompress:(CGFloat)compressionQuality {
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    for (PhotoThumbnailView *thumbnail in _thumbnails) {
        if (thumbnail.asset != nil) {
            PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
            phImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
            phImageRequestOptions.synchronous = YES;
            
            __block UIImage* image = nil;
            [[PHImageManager defaultManager]requestImageForAsset:thumbnail.asset
                                                      targetSize:PHImageManagerMaximumSize
                                                     contentMode:PHImageContentModeDefault
                                                         options:phImageRequestOptions
                                                   resultHandler:^(UIImage *result, NSDictionary *info) {
                                                       image = result;
                                                   }];
            NSData * data = UIImageJPEGRepresentation(image, 0.5);
            [dataArray addObject:[data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
        } else if (thumbnail.fullImage != nil) {
            NSData * data = UIImageJPEGRepresentation(thumbnail.fullImage, 0.5);
            [dataArray addObject:[data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
        }
    }
    return dataArray;
}


@end
