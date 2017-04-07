//
//  StatusView.m
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-12.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import "StatusView.h"
#import "LoginViewController.h"

@interface StatusView () <LoginViewDelegate>

@end

@implementation StatusView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.noNetWorkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"status_no_network"]];
        self.noNetWorkView.frame = self.bounds;
        self.noNetWorkView.backgroundColor = [UIColor colorWithHex:Main_Background_Color];
        self.noNetWorkView.contentMode = UIViewContentModeScaleAspectFit;
        //        self.noNetWorkView.center = self.center;
        self.noNetWorkView.userInteractionEnabled = true;
        [self addSubview:self.noNetWorkView];
        
        self.retryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"status_retry"]];
        self.retryView.frame = self.bounds;
        self.retryView.backgroundColor = [UIColor colorWithHex:Main_Background_Color];
        self.retryView.contentMode = UIViewContentModeScaleAspectFit;
        //        self.retryView.center = self.center;
        self.retryView.userInteractionEnabled = true;
        [self addSubview:self.retryView];
        
        self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"status_logo"]];
        self.logoView.frame = self.bounds;
        self.logoView.backgroundColor = [UIColor colorWithHex:Main_Background_Color];
        self.logoView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.noLoginView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"status_logo"]];
        self.noLoginView.frame = self.bounds;
        self.noLoginView.backgroundColor = [UIColor colorWithHex:Main_Background_Color];
        self.noLoginView.contentMode = UIViewContentModeScaleAspectFit;
        self.noLoginView.userInteractionEnabled = true;
        
        
        
        //        self.logoView.center = self.center;
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.activityIndicator sizeToFit];
        self.activityIndicator.center = CGPointMake(self.logoView.center.x,self.logoView.center.y-80);
        [self.logoView addSubview:self.activityIndicator];
        [self addSubview:self.logoView];
        
        [self.retryView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRetryClicked)]];
        [self.noNetWorkView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onNoNetworkClicked)]];
        [self.noLoginView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLoginClicked)]];
        
        // initial status
        self.retryView.hidden = self.noLoginView.hidden = self.noNetWorkView.hidden = self.logoView.hidden = YES;
        
        
    }
    return self;
}

- (void) onRetryClicked{
    //    self.status = ViewStatusLoading;
    if([self.delegate respondsToSelector:@selector(onRetryClicked:)]){
        [self.delegate onRetryClicked:self];
    }
}

- (void) onNoNetworkClicked{
    if(![Reachability isEnableNetwork]){
        return;
    }
    //    self.status = ViewStatusLoading;
    if([self.delegate respondsToSelector:@selector(onNoNetworkClicked:)]){
        [self.delegate onNoNetworkClicked:self];
    }
}

- (void) onLoginClicked {
    if([self.delegate respondsToSelector:@selector(onLoginClicked:)]){
        [self.delegate onLoginClicked:self];
    }
}


- (void) setStatus:(ViewStatusType)status{
    _status = status;
    switch (status) {
        case ViewStatusNormal:
            self.hidden = true;
            break;
        case ViewStatusNoNetwork:
            self.hidden = false;
            self.noNetWorkView.hidden = false;
            self.logoView.hidden = self.retryView.hidden = true;
            break;
        case ViewStatusLogo:
            self.hidden = false;
            self.logoView.hidden = false;
            self.activityIndicator.hidden = true;
            self.noNetWorkView.hidden = self.retryView.hidden = true;
            break;
        case ViewStatusLoading:
            self.hidden = false;
            self.logoView.hidden = false;
            self.activityIndicator.hidden = false;
            self.noNetWorkView.hidden = self.retryView.hidden = true;
            break;
        case ViewStatuseretry:
            self.hidden = false;
            self.retryView.hidden = false;
            self.noNetWorkView.hidden = self.logoView.hidden = true;
            break;
            
        case ViewStatusNoLogin:
            self.hidden = false;
            self.noLoginView.hidden = false;
            self.noNetWorkView.hidden = self.logoView.hidden =  self.retryView.hidden = true;
            break;
            
    }
    if(status == ViewStatusLoading){
        [self.activityIndicator startAnimating];
    }else{
        [self.activityIndicator stopAnimating];
    }
}


@end