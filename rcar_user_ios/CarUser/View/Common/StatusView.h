//
//  StatusView.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-12.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ViewStatusNormal = 0,   //显示正常视图
    ViewStatusNoNetwork,    //网络可不用
    ViewStatusLogo,         //初始化页面(网站Logo)
    ViewStatusLoading,      //视图加载中
    ViewStatuseretry,        //服务器错误,点击重试
    ViewStatusNoLogin,      //未登录
} ViewStatusType;   //需要从网络加载的视图的几种状态变化

@protocol StatusViewDelegate;

@interface StatusView : UIView
@property (nonatomic,strong) UIImageView *noNetWorkView;
@property (nonatomic,strong) UIImageView *logoView;
@property (nonatomic,strong) UIImageView *retryView;
@property (nonatomic,strong) UIImageView *noLoginView;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic,assign) ViewStatusType status;
@property (nonatomic,assign) id<StatusViewDelegate> delegate;

@end

@protocol StatusViewDelegate <NSObject>
@optional
- (void) onRetryClicked:(StatusView *) statusView;
- (void) onNoNetworkClicked:(StatusView *) statusView;
- (void) onLoginClicked:(StatusView *)statusView;

@end