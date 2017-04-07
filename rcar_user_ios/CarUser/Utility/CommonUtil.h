

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <WBNoticeView.h>

#define PROTOCOL	@"PROTOCOL"
#define HOST		@"HOST"
#define PARAMS		@"PARAMS"
#define URI1		@"URI"

typedef enum{
    DateFormatYMD,
    DateFormatMD,
    DateFormatYMDHM,
    DateFormatYMDHMS,
    DateFormatMDHM,
    DateFormatHM,
    DateFormatHMS
}DateFormatType;

@interface CommonUtil : NSObject

+ (void) showFrameDetail:(UIView *)view;
+ (void) showBoundsDetail:(UIView *)view;

+ (NSString *)formatDate:(NSDate *) date withFormatter:(DateFormatType) format;
+ (NSDate *)formatString:(NSString *)date withFormatter:(DateFormatType) format;
+ (NSString*)getChineseCalendarWithDate:(NSDate *)date;

+ (NSString *) formatErrorWithOperation:(AFHTTPRequestOperation *)operation error:(NSError *)error;

+ (NSDictionary *)paramsFromURL:(NSString *)url;

+ (NSURL *)documentsDirectoryURL;
+ (NSURL *)cachesDirectoryURL;
+ (NSURL *)downloadsDirectoryURL;
+ (NSURL *)libraryDirectoryURL;
+ (NSURL *)applicationSupportDirectoryURL;

+ (BOOL) createDiskDirectory:(NSString *)directoryPath;
+ (NSString *) createDetailCacheDirectory:(NSString *)cachePathName;
+ (NSString *) createJDOCacheDirectory;
+ (void) deleteCacheDirectory;
+ (void) deleteURLCacheDirectory;
+ (void) deleteMeidaCacheDirectory;
+ (int) getDiskCacheFileCount;
+ (int) getDiskCacheFileSize;

+ (BOOL) isShowingHint;
+ (void) showHintHUD:(NSString *)content inView:(UIView *)view;
+ (void) showHintHUD:(NSString *)content inView:(UIView *)view originY:(CGFloat) originY;
+ (void) showSuccessHUD:(NSString *)content inView:(UIView *)view;
+ (void) showSuccessHUD:(NSString *)content inView:(UIView *)view originY:(CGFloat) originY;

+ (BOOL)ifNoImage;

+ (NSMutableArray *)getShareTypes;
+ (NSMutableArray *)getAuthList;


+ (BOOL) isEmptyString:(NSString *)string;
+ (BOOL) isNumber:(NSString *)string;
+ (BOOL) isEmail:(NSString *)string;

+ (NSString*) getHomeFilePath:(NSString *)fileName;
+ (NSString*) getTmpFilePath:(NSString *)fileName;
+ (NSString*) getCacheFilePath:(NSString *)fileName;
+ (NSString*) getDocumentFilePath:(NSString *)fileName;
@end
