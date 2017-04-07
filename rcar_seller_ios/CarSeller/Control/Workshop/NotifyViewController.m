//
//  NotifyViewController.m
//  CarUser
//
//  Created by jenson.zuo on 15/1/2016.
//  Copyright © 2016 CloudStone Tech. All rights reserved.
//

#import "NotifyViewController.h"
#import "SSTextView.h"
#import "LoginViewController.h"
#import "SSLineView.h"
#import "MessageModel.h"
#import "SellerModel.h"


@interface NotifyViewController () <UIWebViewDelegate, MxAlertViewDelegate>
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) MessageDetailModel *msgDetail;
@property (nonatomic, assign) CGFloat startY;

@end

@implementation NotifyViewController

@synthesize msg;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set controller's title
    if ([self.msg.source isEqualToString:RCarNotificationSourceSeller])
        self.navigationItem.title = @"商家通知";
    else if ([self.msg.source isEqualToString:RCarNotificationSourceSystem])
        self.navigationItem.title = @"系统通知";
    else
        self.navigationItem.title = @"用户消息";

    // create activity
    self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activity setFrame:CGRectMake(0, 0, 60, 60)];
    [self.activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:self.activity];

    
    
    // create title label
    self.startY = 0;
    if (self.msg.title != nil && ![self.msg.title isEqualToString:@""]) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.startY, self.view.frame.size.width, 30.f)];
        label.font = [UIFont systemFontOfSize:15.f];
        label.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
        label.text = self.msg.title;
        [self.view addSubview:label];
        self.startY += 30.f + 2.f;
    }
    // create webview if url exist
    if (self.msg.url != nil && ![self.msg.url isEqualToString:@""]) {
        UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, self.startY, self.view.frame.size.width, self.view.frame.size.height -self.startY)];
        webview.delegate = self;
        NSURL *nsurl = [[NSURL alloc]initWithString:self.msg.url];
        
        [self.activity startAnimating];
        [webview loadRequest:[[NSURLRequest alloc]initWithURL:nsurl]];
        [self.view addSubview:webview];
    }
    [self loadMessageDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didMessageLoadFishied:(MessageDetailModel *)detail {
    if (self.msgDetail.content == nil || [self.msgDetail.content isEqualToString:@""])
        return;
    
    self.msgDetail = detail;
    
    // display content
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.msgDetail.content];
    
    NSRange allRange = [self.msgDetail.content rangeOfString:self.msgDetail.content];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:15.f]
                    range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor blackColor]
                    range:allRange];
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX)
                                        options:options
                                        context:nil];
    
    SSTextView *textView = [[SSTextView alloc]initWithFrame:CGRectMake(0, self.startY, self.view.frame.size.width, rect.size.height)];
    [textView setEditable:NO];
    textView.text = self.msgDetail.content;
    textView.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:textView];
    self.startY += rect.size.height + 2.f;
    
    // disply replies
    if (self.msgDetail.replies != nil && self.msgDetail.replies.count > 0) {
        for (MessageRepleyModel *reply in self.msgDetail.replies) {
            // add line
            SSLineView *lineView = [[SSLineView alloc]initWithFrame:CGRectMake(0, self.startY, self.view.frame.size.width, 2.f)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [self.view addSubview:lineView];
            self.startY += 2.f;
            
            // add label View
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.startY, self.view.frame.size.width, 20.f)];
            label.font = [UIFont systemFontOfSize:15.f];
            label.text = reply.time;
            [self.view addSubview:label];
            
            // add content view
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:reply.content];
            
            NSRange allRange = [reply.content rangeOfString:reply.content];
            [attrStr addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:15.f]
                            range:allRange];
            [attrStr addAttribute:NSForegroundColorAttributeName
                            value:[UIColor blackColor]
                            range:allRange];
            
            NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX)
                                                options:options
                                                context:nil];
            
            SSTextView *textView = [[SSTextView alloc]initWithFrame:CGRectMake(0, self.startY, self.view.frame.size.width, rect.size.height)];
            [textView setEditable:NO];
            textView.font = [UIFont systemFontOfSize:15.f];
            textView.text = reply.content;
            [self.view addSubview:textView];
            self.startY += rect.size.height;
        }
    }

    // add reply button
    if (self.msg.replyable != nil && [self.msg.replyable isEqualToString:@"yes"] &&
        self.msg.msgid != nil && ![self.msg.msgid isEqualToString:@""] &&
        self.msg.seller_id != nil && ![self.msg.seller_id isEqualToString:@""]) {
        // create title label
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.startY, self.view.frame.size.width, 30.f)];
        label.font = [UIFont systemFontOfSize:15.f];
        label.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
        label.text = @"用户回复";
        [self.view addSubview:label];
        self.startY += 30.f;
        
        // create reply text view
        SSTextView *textView = [[SSTextView alloc]initWithFrame:CGRectMake(0, self.startY, self.view.frame.size.width, 90.f)];
        [textView setEditable:YES];
        textView.placeholder = @"请输入回复";
        textView.tag = 0x400;
        [self.view addSubview:textView];
        self.startY += 90.f;
        
        // create reply button
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, self.startY, self.view.frame.size.width, 40.f)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"回复" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithHex:@"2480FF"];
        [button addTarget:self action:@selector(replytBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activity stopAnimating];
}
#pragma mark - UIButton
- (void)replytBtnClicked:(id)sender {
    // get reply text
    SSTextView *textView = (SSTextView *)[self.view viewWithTag:0x400];
    if ([textView.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"回复信息没有填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show:self];
        return;
    }
    SellerModel *seller = [SellerModel sharedClient];
    
    NSDictionary *params = @{@"role":@"seller", @"seller_id":seller.seller_id, @"kind":self.msg.kind, @"msg_id":self.msg.msgid, @"content":textView.text, @"seller_id":self.msg.seller_id};
    
    __block NotifyViewController *blockself = self;
    [self.activity startAnimating];
    [RCar POST:rcar_api_seller_user_msg modelClass:nil config:nil params:params success:^(NSDictionary *model) {
        [blockself.activity stopAnimating];
        [blockself.navigationController popViewControllerAnimated:YES];
     }failure:^(NSString *errorStr) {
         [blockself.activity stopAnimating];
         [blockself.navigationController popViewControllerAnimated:YES];
     }];
}

- (void) loadMessageDetail {
    NSDictionary *params = @{@"role":@"user", @"kind":self.msg.kind, @"msg_id":self.msg.msgid, @"detail":@"yes"};
    
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[MessageRepleyModel class] forAttribute:@"replies" onClass:[MessageDetailModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    
    __block NotifyViewController *blockself = self;
    [self.activity startAnimating];
    [RCar GET:rcar_api_seller_user_msg modelClass:@"MessageDetailModel" config:config params:params success:^(MessageDetailModel *model) {
        [blockself.activity stopAnimating];
        [blockself didMessageLoadFishied:model];
    }failure:^(NSString *errorStr) {
        [blockself.activity stopAnimating];
    }];
}
@end
