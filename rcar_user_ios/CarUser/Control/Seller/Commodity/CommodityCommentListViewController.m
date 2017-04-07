//
//  CommodityCommentListViewController.m
//  CarUser
//
//  Created by jenson.zuo on 23/5/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "CommodityCommentListViewController.h"
#import "UserInfoModel.h"
#import "CommentModel.h"
#import "DataArrayModel.h"
#import "MJRefresh.h"

@interface CommodityCommentListViewController ()
@property (nonatomic, assign) NSInteger index;
@end

@implementation CommodityCommentListViewController

@synthesize model;
@synthesize panelView;
@synthesize textView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品评价一览";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    
    //
    UserModel *user = [UserModel sharedClient];
    if ([user isLogin]) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"评价" style:UIBarButtonItemStylePlain target:self action:@selector(addComment:)];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        // create pannel view and text view
        self.panelView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 90, self.view.frame.size.width, 50)];
        self.textView = [[SSTextView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 90, self.view.frame.size.width, 70)];
        self.textView.font = [UIFont systemFontOfSize:12.f];
        [self.panelView addSubview:self.textView];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 20, self.view.frame.size.width, 20)];
        [button setTitle:@"提交评价" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithHex:@"2480ff"];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(submitComment) forControlEvents:UIControlEventTouchUpInside];
        [self.panelView addSubview:button];
        [self.panelView setHidden:YES];
        [self.view addSubview:self.panelView];
    }
    
    // add push method
    self.index = self.model.comments.count;
    __block CommodityCommentListViewController *blockself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [blockself loadCommodityComments:blockself.index];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.comments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"CommentTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    CommentModel *comment = [self.model.comments objectAtIndex:indexPath.row];
    cell.textLabel.text = comment.user;
    cell.detailTextLabel.text = comment.desc;
    
    // Configure the cell...
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)addComment:(id)sender {
    if ([self.panelView isHidden])
        [self.panelView setHidden:false];
    else
        [self.panelView setHidden:true];
}

- (void)submitComment {
    // check parameter
    if (self.model.seller_id == nil || [self.model.seller_id isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"商品商家情报错误，不能添加评价" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
        [alert show:self];
        return;
    }
    if (self.model.cid == nil  || [self.model.cid isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"商品情报错误，不能添加评价" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
        [alert show:self];
        return;
    }
    if (self.textView.text == nil || [self.textView.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写评价内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
        [alert show:self];
        return;
    }
    
    NSDictionary *params = @{@"seller_id":self.model.seller_id, @"cid":self.model.cid, @"content":self.textView.text};
    __block CommodityCommentListViewController *blockself = self;
    
    [RCar POST:rcar_api_user_seller_comment modelClass:nil config:nil params:params success:^(APIResponseModel *result) {
        if (result.api_result == APIE_OK) {
            // create a comment model
            CommentModel *comment = [[CommentModel alloc]init];
            comment.user = [UserModel sharedClient].user_id;
            comment.desc = blockself.textView.text;
            [blockself.model.comments addObject:comment];
            [blockself.tableView reloadData];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    }failure:^(NSString *errorStr) {
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
}

- (void)loadCommodityComments:(NSInteger)index {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[CommentModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    [config addArrayMapper:mapper];
    
    
    NSDictionary *params = @{@"seller_id":self.model.seller_id, @"cid":self.model.cid, @"index":[NSString stringWithFormat:@"%lu", self.index] };
    __block CommodityCommentListViewController *blockself = self;
    
    
    [RCar GET:rcar_api_user_seller_comment_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataArray) {
        if (dataArray != nil && dataArray.data.count > 0) {
            [blockself.model.comments addObjectsFromArray:dataArray.data ];
            blockself.index = blockself.model.comments.count;
            [blockself.tableView reloadData];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    }failure:^(NSString *errorStr) {
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
    
    
}

@end
