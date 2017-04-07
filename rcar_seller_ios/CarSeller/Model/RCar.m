//
//  RCar.m
//  CarSeller
//
//  Created by jenson.zuo on 30/11/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "RCar.h"
#import "DCKeyValueObjectMapping.h"
#import "AFNetworking.h"
#include <sys/types.h>
#include <sys/sysctl.h>


@implementation RCar

+ (RCar *)sharedClient {
    static RCar *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[RCar alloc] init];
    });
    return _sharedClient;
}

+(NSString*)platform{
    size_t size;
    
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString* platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

+ (NSString *)aplServer {
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"] )
        return  @"http://172.16.47.149/rcar/api/v1.0/";
    else
        return @"http://jongkhurun.com:66/rcar/api/v1.0/";
}

+ (NSString *)imageServer {
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"] )
        return   @"http://172.16.47.149/rcar/images/";
    else
        return @"http://jongkhurun.com:66/rcar/images/";

}


+ (void)GET:(NSString*)serviceName
 modelClass:(NSString *)modelClass
     config:(DCParserConfiguration *)config
     params:(NSDictionary *)params
    success:(CallSuccessBlock)success
    failure:(CallFailureBlock)failure {

    
    NSString *fullApi = [self aplServer];
    fullApi = [fullApi stringByAppendingString:serviceName];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"Application/json", nil];
    // manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableString * data = [[NSMutableString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSString* headerData=data;
    headerData = [headerData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    [manager GET: fullApi parameters:@{@"q": headerData} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)  {
            if(modelClass == nil){  // 若无modelClass，则直接返回NSArray或NSDictionary
                success(responseObject);
            }else{
                Class _modelClass = NSClassFromString(modelClass);
                DCKeyValueObjectMapping *mapper;
                if (config == nil) {
                    mapper = [DCKeyValueObjectMapping mapperForClass: _modelClass];
                } else {
                    mapper = [DCKeyValueObjectMapping mapperForClass: _modelClass andConfiguration:config];
                }
                
                if([responseObject isKindOfClass:[NSArray class]]){
                    success([mapper parseArray:responseObject]);
                }else if([responseObject isKindOfClass:[NSDictionary class]]){
                    success([mapper parseDictionary:responseObject]);
                }else{
                    NSLog(@"Unknown json data type");
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

+ (void)POST:(NSString*)serviceName
  modelClass:(NSString *)modelClass
      config:(DCParserConfiguration *)config
      params:(NSDictionary *)params
     success:(CallSuccessBlock)success
     failure:(CallFailureBlock)failure {
    
    NSString *fullApi = [self aplServer];
    fullApi = [fullApi stringByAppendingString:serviceName];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"Application/json", nil];
    
    [manager POST:fullApi parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)  {
            if(modelClass == nil){  // 若无modelClass，则直接返回NSArray或NSDictionary
                success(responseObject);
            }else{
                Class _modelClass = NSClassFromString(modelClass);
                DCKeyValueObjectMapping *mapper;
                if (config == nil) {
                    //DCParserConfiguration *_config = [DCParserConfiguration configuration];
                    //DCObjectMapping *resultMapping = [DCObjectMapping mapKeyPath:@"api_result" toAttribute:@"api_result" onClass:[APIResponseModel class]];
                    //[_config addObjectMapping:resultMapping];
                    mapper = [DCKeyValueObjectMapping mapperForClass: _modelClass];
                } else {
                    mapper = [DCKeyValueObjectMapping mapperForClass: _modelClass andConfiguration:config];
                }
                
                if([responseObject isKindOfClass:[NSArray class]]){
                    success([mapper parseArray:responseObject]);
                }else if([responseObject isKindOfClass:[NSDictionary class]]){
                    success([mapper parseDictionary:responseObject]);
                }else{
                    NSLog(@"Unknown json data type");
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

+ (void)PUT:(NSString*)serviceName
 modelClass:(NSString *)modelClass
     config:(DCParserConfiguration *)config
     params:(NSDictionary *)params
    success:(CallSuccessBlock)success
    failure:(CallFailureBlock)failure {
    
    
    NSString *fullApi = [self aplServer];
    fullApi = [fullApi stringByAppendingString:serviceName];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"Application/json", nil];
    
    [manager PUT:fullApi parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)  {
            if(modelClass == nil){  // 若无modelClass，则直接返回NSArray或NSDictionary
                success(responseObject);
            }else{
                Class _modelClass = NSClassFromString(modelClass);
                DCKeyValueObjectMapping *mapper;
                if (config == nil) {
                    //DCParserConfiguration *_config = [DCParserConfiguration configuration];
                    //DCObjectMapping *resultMapping = [DCObjectMapping mapKeyPath:@"api_result" toAttribute:@"api_result" onClass:[APIResponseModel class]];
                    //[_config addObjectMapping:resultMapping];
                    mapper = [DCKeyValueObjectMapping mapperForClass: _modelClass];
                } else {
                    mapper = [DCKeyValueObjectMapping mapperForClass: _modelClass andConfiguration:config];
                }
                
                if([responseObject isKindOfClass:[NSArray class]]){
                    success([mapper parseArray:responseObject]);
                }else if([responseObject isKindOfClass:[NSDictionary class]]){
                    success([mapper parseDictionary:responseObject]);
                }else{
                    NSLog(@"Unknown json data type");
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

+ (void)DELETE:(NSString*)serviceName
    modelClass:(NSString *)modelClass
        config:(DCParserConfiguration *)config
        params:(NSDictionary *)params
       success:(CallSuccessBlock)success
       failure:(CallFailureBlock)failure {
    
    
    NSString *fullApi = [self aplServer];
    fullApi = [fullApi stringByAppendingString:serviceName];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"Application/json", nil];
    
    [manager DELETE:fullApi parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)  {
            if(modelClass == nil){  // 若无modelClass，则直接返回NSArray或NSDictionary
                success(responseObject);
            }else{
                Class _modelClass = NSClassFromString(modelClass);
                DCKeyValueObjectMapping *mapper;
                if (config == nil) {
                    //DCParserConfiguration *_config = [DCParserConfiguration configuration];
                    //DCObjectMapping *resultMapping = [DCObjectMapping mapKeyPath:@"api_result" toAttribute:@"api_result" onClass:[APIResponseModel class]];
                    //[_config addObjectMapping:resultMapping];
                    mapper = [DCKeyValueObjectMapping mapperForClass: _modelClass];
                } else {
                    mapper = [DCKeyValueObjectMapping mapperForClass: _modelClass andConfiguration:config];
                }
                
                if([responseObject isKindOfClass:[NSArray class]]){
                    success([mapper parseArray:responseObject]);
                }else if([responseObject isKindOfClass:[NSDictionary class]]){
                    success([mapper parseDictionary:responseObject]);
                }else{
                    NSLog(@"Unknown json data type");
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

+ (void)PATCH:(NSString*)serviceName
   modelClass:(NSString *)modelClass
       config:(DCParserConfiguration *)config
       params:(NSDictionary *)params
      success:(CallSuccessBlock)success
      failure:(CallFailureBlock)failure {
    
    NSString *fullApi = [self aplServer];
    fullApi = [fullApi stringByAppendingString:serviceName];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"Application/json", nil];
    
    [manager PATCH:fullApi parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)  {
            if(modelClass == nil){  // 若无modelClass，则直接返回NSArray或NSDictionary
                success(responseObject);
            }else{
                Class _modelClass = NSClassFromString(modelClass);
                DCKeyValueObjectMapping *mapper;
                if (config == nil) {
                    //DCParserConfiguration *_config = [DCParserConfiguration configuration];
                    //DCObjectMapping *resultMapping = [DCObjectMapping mapKeyPath:@"api_result" toAttribute:@"api_result" onClass:[APIResponseModel class]];
                    //[_config addObjectMapping:resultMapping];
                    mapper = [DCKeyValueObjectMapping mapperForClass: _modelClass];
                } else {
                    mapper = [DCKeyValueObjectMapping mapperForClass: _modelClass andConfiguration:config];
                }
                
                if([responseObject isKindOfClass:[NSArray class]]){
                    success([mapper parseArray:responseObject]);
                }else if([responseObject isKindOfClass:[NSDictionary class]]){
                    success([mapper parseDictionary:responseObject]);
                }else{
                    NSLog(@"Unknown json data type");
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


+ (BOOL)isConnected {
    return true;
#if 0
    Reachability *reach =  [Reachability reachabilityWithHostName:RCAR_HOST];
    if (reach.currentReachabilityStatus == NotReachable)
        return false;
    else
        return true;
#endif
}


+ (void)callBaiduGeocoder:(NSNumber *)lat lng:(NSNumber *)lng
                  success:(CallSuccessBlock)success
                  failure:(CallFailureBlock)failure {
    //NSString *fullApi = @"http://api.map.baidu.com/geocoder/v2/?ak=D4d89b22249987b05f67d034bd7ccdfd&location=39.983424,116.322987&output=json";
    NSString *fullApi = @"http://api.map.baidu.com/geocoder/v2/?ak=D4d89b22249987b05f67d034bd7ccdfd&output=json&location=";
    
    NSString *latString = [NSString stringWithFormat:@"%f", lat.doubleValue];
    NSString *lngString = [NSString stringWithFormat:@"%f", lng.doubleValue];
    
    fullApi = [fullApi stringByAppendingString:latString];
    fullApi = [fullApi stringByAppendingString:@","];
    fullApi = [fullApi stringByAppendingString:lngString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:fullApi parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure([error description]);
    }];
}

+ (void)uploadImage:(NSArray *)images names:(NSArray *)names target:(NSString*)target success:(CallSuccessBlock)success failure:(CallFailureBlock)failure {
    if (names == nil || images == nil || names.count != images.count || target == nil)
        return;
    
    NSMutableDictionary *items = [[NSMutableDictionary alloc]init];
    NSMutableArray *imagesArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < names.count; i++) {
        if (names[i] != nil && images[i] != nil) {
            NSMutableDictionary * imageDict = [[NSMutableDictionary alloc]init];
            [imageDict setObject:images[i] forKey:@"data"];
            [imageDict setObject:names[i] forKey:@"name"];
            [imagesArray addObject:imageDict];
        }
    }
    [items setObject:imagesArray forKey:@"images"];
    [items setObject:target forKey:@"target"];
    
    // NSString *fullApi = [[RCar imageServer] stringByAppendingString:@"upload"];
    NSString *fullApi = [self imageServer];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"Application/json", nil];
    [manager POST:fullApi parameters:items success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) failure([error description]);
    }];
}

@end
