//
//  UserChatViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 24/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "UserChatViewController.h"
#import "UserMessageModel.h"
#import "UserMessageCellModel.h"
#import "UserMessageCell.h"
#import "SellerModel.h"
#import "DCArrayMapping.h"
#import "DataArrayModel.h"
#import "MJRefresh.h"
#import "SellerModel.h"
#import "UserInfoViewController.h"

#define kToolBarH 44
#define kTextFieldH 30

@interface UserChatViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation UserChatViewController {
    NSMutableArray *_cellFrameDatas;
    UITableView *_chatView;
    UIImageView *_toolBar;
    UIActivityIndicatorView *_activity;
    NSInteger _offset;
    NSInteger _number;
    BOOL _hasMoreData;
}

@synthesize user_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = @"用户信息";
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"信息" style:UIBarButtonItemStylePlain target:self action:@selector(showUserDetailInfo:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc]initWithTitle:@"订单" style:UIBarButtonItemStylePlain target:self action:@selector(showUserOrders:)];
    [rightItem2 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItems = @[rightItem, rightItem2];
    
    // display activity indicator
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 80)];
    _activity.backgroundColor = [UIColor grayColor];
    _activity.alpha = 0.5;
    _activity.layer.cornerRadius = 6;
    _activity.layer.masksToBounds = YES;
    [self.view addSubview:_activity];
    
    _offset = 0;
    _number = 10;
    _hasMoreData = false;
#if 0
    __block UserChatViewController *blockself = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [blockself loadData];
    }];
#endif
    
    
    [self loadData];
    
    [self addChatView];
    
    [self addToolBar];
}

- (void)viewDidAppear:(BOOL)animated {

}

- (void)viewDidDisappear:(BOOL)animated {
    [_toolBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)menuItemClicked:(NSInteger)index {
    
}

- (void)showUserDetailInfo:(id)sender {
    [self performSegueWithIdentifier:@"user_info" sender:self];
}

- (void)showUserOrders:(id)sender {
    [self performSegueWithIdentifier:@"show_user_order_list" sender:self];
    
}

- (void)addChatView {
    self.view.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kToolBarH) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)]];
    [self.view addSubview:self.tableView];
}

- (void)addToolBar {
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = CGRectMake(0, self.view.frame.size.height - kToolBarH, self.view.frame.size.width, kToolBarH);
    //bgView.frame = CGRectMake(0, 424, self.view.frame.size.width, kToolBarH);
    bgView.image = [UIImage imageNamed:@"chat_bottom_bg"];
    bgView.userInteractionEnabled = YES;
    _toolBar = bgView;
    [self.view addSubview:bgView];
    
    UIButton *sendSoundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendSoundBtn.frame = CGRectMake(0, 0, kToolBarH, kToolBarH);
    [sendSoundBtn setImage:[UIImage imageNamed:@"chat_bottom_voice_nor"] forState:UIControlStateNormal];
    [bgView addSubview:sendSoundBtn];
    
    UIButton *addMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addMoreBtn.frame = CGRectMake(self.view.frame.size.width - kToolBarH, 0, kToolBarH, kToolBarH);
    [addMoreBtn setImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
    [bgView addSubview:addMoreBtn];
    
    UIButton *expressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    expressBtn.frame = CGRectMake(self.view.frame.size.width - kToolBarH * 2, 0, kToolBarH, kToolBarH);
    [expressBtn setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
    [bgView addSubview:expressBtn];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.keyboardType = UIKeyboardTypeAlphabet;
    textField.returnKeyType = UIReturnKeySend;
    textField.enablesReturnKeyAutomatically = YES;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 1)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.frame = CGRectMake(kToolBarH, (kToolBarH - kTextFieldH) * 0.5, self.view.frame.size.width - 3 * kToolBarH, kTextFieldH);
    textField.background = [UIImage imageNamed:@"chat_bottom_textfield"];
    textField.delegate = self;
    [bgView addSubview:textField];
    [self.view addSubview:bgView];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *controller = segue.destinationViewController;
    controller.hidesBottomBarWhenPushed = YES;
    if ([segue.identifier isEqualToString:@"user_info"]) {
        [controller setValue:self.user_id forKey:@"user_id"];
        return;
    }
    if ([segue.identifier isEqualToString:@"show_user_order_list"]) {
        [controller setValue:self.user_id forKey:@"user_id"];
        return;
    }
}


- (void)loadData {
    [_activity startAnimating];
    if ( _cellFrameDatas == nil)
        _cellFrameDatas =[NSMutableArray array];
    
    [_activity startAnimating];
    SellerModel *seller = [SellerModel sharedClient];
    NSDictionary *params = @{@"role":@"seller", @"seller_id":seller.seller_id, @"user_id":self.user_id, @"offset":[NSNumber numberWithInteger:_offset], @"num": [NSNumber numberWithInteger:_number]};
   
    __block UserChatViewController *blockself = self;
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[UserMessageModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    [RCar GET:rcar_api_seller_user_msg_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *model) {
        [_activity stopAnimating];
        if (model.api_result == APIE_OK) {
            if (model.data.count == _number) {
                _hasMoreData = false;
                 _offset += (int)model.data.count;
                for (UserMessageModel *msg in model.data) {
                    UserMessageCellModel *lastFrame = [_cellFrameDatas lastObject];
                    UserMessageCellModel *cellFrame = [[UserMessageCellModel alloc] init];
                    msg.showTime = ![msg.time isEqualToString:lastFrame.message.time];
                    cellFrame.message = msg;
                    [_cellFrameDatas addObject:cellFrame];
                }
            } else if (model.data.count < _number) {
                _hasMoreData = true;
                _offset += (int)model.data.count;
                for (UserMessageModel *msg in model.data) {
                    UserMessageCellModel *lastFrame = [_cellFrameDatas lastObject];
                    UserMessageCellModel *cellFrame = [[UserMessageCellModel alloc] init];
                    msg.showTime = ![msg.time isEqualToString:lastFrame.message.time];
                    cellFrame.message = msg;
                    [_cellFrameDatas addObject:cellFrame];
                }
            } else {}
            [blockself.tableView reloadData];
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            
        }
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力, 请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
    }];
}

- (void)handleLoadError:(NSString *)error {
    [_activity stopAnimating];
    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力, 请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show:self];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellFrameDatas.count;
}

- (UserMessageCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    
    UserMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UserMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    UserMessageCellModel *cellFrame = [_cellFrameDatas objectAtIndex:indexPath.row];
    UserMessageModel *msg = cellFrame.message;
    
    SellerModel *seller = [SellerModel sharedClient];
    if (msg.from != nil && [msg.from isEqualToString:seller.seller_id])
        msg.flag = MessageTypeMe;
    else msg.flag = MessageTypeOther;
    
    [cell setModel:_cellFrameDatas[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserMessageCellModel *cellFrame = _cellFrameDatas[indexPath.row];
    return cellFrame.cellHeght;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // get current time
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    
    // create message model
    UserMessageModel *message = [[UserMessageModel alloc] init];
    message.content = textField.text;
    message.time = locationString;
    message.flag = MessageTypeMe;
    
    SellerModel *seller = [SellerModel sharedClient];
    message.from = seller.seller_id;
    
    // create message cell model
    UserMessageCellModel *cellFrame = [[UserMessageCellModel alloc] init];
    UserMessageCellModel *lastCellFrame = [_cellFrameDatas lastObject];
    message.showTime = ![lastCellFrame.message.time isEqualToString:message.time];
    cellFrame.message = message;
    
    // add data and refresh
    [_cellFrameDatas addObject:cellFrame];
    [self.tableView reloadData];
    
    // send message to user
    [self sendMessageToUser:message];
    
    // scroll to last row
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    textField.text = @"";
    
    return YES;
}


- (void)sendMessageToUser:(UserMessageModel *)msg {
    SellerModel *seller = [SellerModel sharedClient];
    NSDictionary *params = @{@"role":@"seller", @"seller_id":seller.seller_id,  @"user_id":self.user_id, @"msg":msg.content};
    //__block UserChatViewController *blockself = self;
    [RCar POST:rcar_api_seller_user_msg modelClass:@"APIResponseModel" config:nil  params:params success:^(APIResponseModel *rsp) {
        if (rsp.api_result == APIE_OK) {
     //       [blockself.tableView reloadData];
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            
        }
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力, 请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
    }];
}

- (void)endEdit {
    [self.view endEditing:YES];
}


- (void)keyboardWillChange:(NSNotification *)note {
    NSLog(@"%@", note.userInfo);
    NSDictionary *userInfo = note.userInfo;
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    CGRect keyFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat moveY = keyFrame.origin.y - self.view.frame.size.height;
  
    
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, moveY);
    }];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
