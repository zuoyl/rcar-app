//
//  AppDelegate.m
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-12.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import "AppDelegate.h"
#import "FavoriteRepository.h"
#import "BPush.h"
#import "NotifyCenterModel.h"
#import "LoginViewController.h"
#import "CarInfoRepository.h"
#import <SMSSDK.h>
#import "UserModel.h"

#define smsAppKey      @"532ea9ed89a1"
#define smsAppSecret   @"b7e4c82ece47165418f5673aa1c08419"
#define baiduMsgPushAPIKey @"lRsBpphYIr8elR0Yi4lXlG3H"


#define MAX_BIND_ERROR_TIMES 10


@interface AppDelegate ()

@end

@implementation AppDelegate {
    int _bindErrorCount;
    NSString *_currentPushTag;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"IZQVUQwsjE2vMhEewMpyKUfH"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    // register sms_sdk
    [SMSSDK registerApp:smsAppKey withSecret:smsAppSecret];
    
    // Override point for customization after application launch.
    
    // load favorite
    FavoriteRepository *favorite = [FavoriteRepository sharedClient];
    [favorite reload];
    
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    // 注册百度推送
    [BPush registerChannel:launchOptions apiKey:baiduMsgPushAPIKey pushMode:BPushModeDevelopment withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
    
    [[UINavigationBar appearance]setBackgroundColor:[UIColor colorWithHex:@"2480ff"]];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
   
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // load favorite
    FavoriteRepository *favorite = [FavoriteRepository sharedClient];
    [favorite flush];
}


// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    completionHandler(UIBackgroundFetchResultNewData);
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
#if 0
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
#else
        NotifyCenterModel *notifyCenter = [NotifyCenterModel sharedClient];
        [notifyCenter handleRemoteNotification:userInfo[@"param"]];
#endif
    }
    else {
        //杀死状态下，直接跳转到跳转页面。
    }
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        
        UserModel *user = [UserModel sharedClient];
        [user setPushId:[BPush getUserId] channelId:[BPush getChannelId]];
        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        if (result) {
            [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    NSLog(@"设置tag成功");
                }
            }];
        }
    }];
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    NSLog(@"********** ios7.0之前 **********");
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        NSLog(@"acitve or background");
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else//杀死状态下，直接跳转到跳转页面。
    {
    }
    NSLog(@"%@",userInfo);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}



- (void) clearRemoteNotifications{
    // 清除通知栏本应用的所有通知
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}





@end
