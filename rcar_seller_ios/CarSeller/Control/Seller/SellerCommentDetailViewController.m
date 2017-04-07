//
//  SellerCommentDetailViewControllerTableViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 10/3/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "SellerCommentDetailViewController.h"
#import "PhotoAlbumView.h"
#import "SellerCommentModel.h"
#import "SSLineView.h"
#import "SSTextView.h"
#import "NSString+Extension.h"
#import "SellerModel.h"

@interface SellerCommentDetailViewController ()
@property (nonatomic, strong) PhotoAlbumView *photoAlbumView;
@property (nonatomic, strong) SSTextView *textView;

@end

@implementation SellerCommentDetailViewController;

@synthesize model;
@synthesize contentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (self.model.reply == nil || [self.model.reply isEqualToString:@""]) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"回复" style:UIBarButtonItemStylePlain target:self action:@selector(replyComment:)];
        [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    [self initializeCommentView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)replyComment:(id)sender {
    // check wether reply text is null
    if ([self.textView.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写反馈意见" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    
    SellerModel *seller = [SellerModel sharedClient];
    NSDictionary *params = @{@"role":@"seller", @"seller_id":seller.seller_id, @"comment_index":self.model.index,@"content":self.textView.text};
    __block SellerCommentDetailViewController *blockself = self;
    [RCar POST:rcar_api_seller_comment modelClass:nil config:nil  params:params success:^(id result) {
        [blockself.navigationController popViewControllerAnimated:YES];
        return;
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误,请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }];
}


- (void)initializeCommentView {
    // user label on left
    UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 60, 20)];
    userLabel.text = (self.model.user == nil)? @"匿名用户":self.model.user;
    userLabel.font = [UIFont systemFontOfSize:15.f];
    [self.contentView addSubview:userLabel];
    
    // time label on right
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, self.view.frame.size.width - 90, 20)];
    timeLabel.text = self.model.time;
    timeLabel.font = [UIFont systemFontOfSize:15.f];
    [self.contentView addSubview:timeLabel];
    
    // draw a line
    SSLineView *lineView = [[SSLineView alloc]initWithFrame:CGRectMake(5, 30, self.view.frame.size.width - 10 , 5)];
    lineView.lineColor = [UIColor lightGrayColor];
    [self.contentView addSubview:lineView];
    
    // display content
    CGSize size = [self.model.content sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(self.view.frame.size.width - 20, 60)];
    if (size.height < 25) size.height = 25;
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 30, size.width, size.height)];
    contentLabel.font = [UIFont systemFontOfSize:12.f];
    contentLabel.text = self.model.content;
    [self.contentView addSubview:contentLabel];
    
    CGFloat height = size.height + 30.f;
    // draw image if it exist
    if (self.model.images.count > 0) {
        CGRect albumRect = CGRectMake(5, 30 + size.height, self.view.frame.size.width - 10, 90);
        self.photoAlbumView = [PhotoAlbumView initWithViewController:self frame:albumRect mode:PhotoAlbumMode_View];
        self.photoAlbumView.maxOfImage = 4;
        [self.photoAlbumView loadImages:self.model.images];
        [self.contentView addSubview:self.photoAlbumView];
        height += 90.f;
    }
    
    // draw a line
    lineView = [[SSLineView alloc]initWithFrame:CGRectMake(5, height + 5, self.view.frame.size.width - 10 , 5)];
    lineView.lineColor = [UIColor lightGrayColor];
    [self.contentView addSubview:lineView];
    
    // place a textview
    self.textView = [[SSTextView alloc]initWithFrame:CGRectMake(5, height + 10, self.view.frame.size.width - 20, 120)];
    if (self.model.reply != nil) {
        self.textView.text = self.model.reply;
        [self.textView setEditable:false];
    } else {
        [self.textView setEditable:true];
        self.textView.placeholder = @"请输入反馈意见";
    }
    self.textView.font = [UIFont systemFontOfSize:15.0f];
    self.textView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.textView];
}

@end
