//
//  StatusView.m
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-12.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import "StatusView.h"

@implementation StatusView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.noNetWorkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"status_no_network"]];
        self.noNetWorkView.frame = self.bounds;
        self.noNetWorkView.backgroundColor = [UIColor whiteColor];
        self.noNetWorkView.contentMode = UIViewContentModeScaleAspectFit;
        //        self.noNetWorkView.center = self.center;
        self.noNetWorkView.userInteractionEnabled = true;
        [self addSubview:self.noNetWorkView];
        
        self.retryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"status_retry"]];
        self.retryView.frame = self.bounds;
        self.retryView.backgroundColor = [UIColor whiteColor];
        self.retryView.contentMode = UIViewContentModeScaleAspectFit;
        //        self.retryView.center = self.center;
        self.retryView.userInteractionEnabled = true;
        [self addSubview:self.retryView];
        
        self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"status_logo"]];
        self.logoView.frame = self.bounds;
        self.logoView.backgroundColor = [UIColor whiteColor];
        self.logoView.contentMode = UIViewContentModeScaleAspectFit;
        //        self.logoView.center = self.center;
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.activityIndicator sizeToFit];
        self.activityIndicator.center = CGPointMake(self.logoView.center.x,self.logoView.center.y-80);
        [self.logoView addSubview:self.activityIndicator];
        [self addSubview:self.logoView];
        
        [self.retryView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRetryClicked)]];
        [self.noNetWorkView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onNoNetworkClicked)]];
        
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
    if(![RCar isConnected]){
        return;
    }
    //    self.status = ViewStatusLoading;
    if([self.delegate respondsToSelector:@selector(onNoNetworkClicked:)]){
        [self.delegate onNoNetworkClicked:self];
    }
}


- (void) setStatus:(ViewStatusType)status{
    _status = status;
    switch (status) {
        case ViewStatusCalling:
            self.hidden = true;
            self.noNetWorkView.hidden = false;
            self.logoView.hidden = self.retryView.hidden = false;

            [self.activityIndicator startAnimating];
            break;
        case ViewStatusCallFinished:
            self.hidden = true;
            self.noNetWorkView.hidden = false;
            self.logoView.hidden = self.retryView.hidden = false;
            [self.activityIndicator stopAnimating];
            break;
        case ViewStatusCallFailed: {
            self.hidden = true;
            self.noNetWorkView.hidden = false;
            self.logoView.hidden = self.retryView.hidden = false;
            [self.activityIndicator stopAnimating];
            
            break;
        }
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
        case ViewStatusRetry:
            self.hidden = false;
            self.retryView.hidden = false;
            self.noNetWorkView.hidden = self.logoView.hidden = true;
            break;
    }
}


@end