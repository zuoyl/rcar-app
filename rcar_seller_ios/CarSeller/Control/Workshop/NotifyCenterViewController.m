//
//  NotifyCenterViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 14/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "NotifyCenterViewController.h"
#import "NotifyCenterModel.h"
#import "DataArrayModel.h"
#import "MessageModel.h"
#import "MJRefresh.h"
#import "FBKVOController.h"
#import "SWTableViewCell.h"
#import "SellerModel.h"


enum {
    SOS_SECTION = 0,
    FAULT_SECION,
    ACTIVITY_SECTION,
};

@interface NotifyCenterViewController () <SWTableViewCellDelegate>
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@end

@implementation NotifyCenterViewController {
    NotifyCenterModel *_notifyCenter;
    SellerModel *_seller;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的通知中心";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    // create activity
    self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activity setFrame:CGRectMake(0, 0, 60, 60)];
    [self.activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:self.activity];
    
    _seller = [SellerModel sharedClient];

    
    __block NotifyCenterViewController *blockself = self;
    _notifyCenter = [NotifyCenterModel sharedClient];
    NotifyCenterModel *notifyCenter = [NotifyCenterModel sharedClient];
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:notifyCenter keyPath:@"notifications" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        // get new data by change[NSKeyValueChangeNewKey];
        NSDictionary *info = change[NSKeyValueChangeNewKey];
        NSString *msg_id = [info objectForKey:@"msg_id"];
            [blockself loadMessages:msg_id];
    }];
    
    // add foot view
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [blockself loadMessages:nil];
    }];
    
    
    if (_seller.msgs.count == 0)
        [self loadMessages:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _seller.msgs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *notifyItemCell = @"NotifyItemCell";
    
    SWTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:notifyItemCell];
    if (cell == nil)
        cell = [[SWTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:notifyItemCell];
    
    // config cell
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
    
    // get all notify item
    MessageModel *msg = [_seller.msgs objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // title
    if ([msg.source isEqualToString:RCarNotificationSourceSystem])
        cell.textLabel.text = @"系统通知";
     else if ([msg.source isEqualToString:RCarNotificationSourceSeller])
        cell.textLabel.text = @"商家通知";
    else
        cell.textLabel.text = @"用户消息";
    
    // content
    if (msg.title != nil && ![msg.title isEqualToString:@""])
        cell.detailTextLabel.text = msg.title;
    
    // format time information
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateStr = nil;
    if (msg.time == nil)
        currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    else
        currentDateStr = msg.time;
    
    // and time label
    CGFloat width = self.tableView.frame.size.width;
    CGRect  rect = cell.textLabel.frame;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(width - 100, rect.origin.y, 100, rect.size.height)];
    label.font = [UIFont systemFontOfSize:15.f];
    label.text = currentDateStr;
    [cell.contentView addSubview:label];
    
    // add delete button
    NSMutableArray *buttons = [[NSMutableArray alloc]init];
    [buttons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
    [cell setRightUtilityButtons:buttons WithButtonWidth:50];
    cell.delegate = self;
    cell.path = indexPath;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"segue_notify_view" sender:self];
}

#pragma mark - SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    // delete notification from notifyCenter
    [_seller.msgs removeObjectAtIndex:cell.path.row];
    [self.tableView reloadData];
}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    MessageModel *msg = [_seller.msgs objectAtIndex:indexPath.row];
    // get all notify item
    if ([segue.identifier isEqualToString:@"show_notify"])
        [segue.destinationViewController setValue:msg forKey:@"msg"];
}


- (void)loadMessages:(NSString *)msg_id {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"role":@"seller", @"seller_id":_seller.seller_id, @"offset":[NSNumber numberWithLong:_seller.msgs.count], @"num":[NSNumber numberWithInt:10]}];
                                   
    if (msg_id != nil && ![msg_id isEqualToString:@""])
        [params setValue:msg_id forKey:@"msg_id"];
    
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[MessageModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
   
    
    __block NotifyCenterViewController *blockself = self;
    [self.activity startAnimating];
    [RCar GET:rcar_api_seller_user_msg modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *data) {
        [blockself.activity stopAnimating];
        [blockself.tableView.mj_footer endRefreshing];
        if (data.data.count > 0) {
            [_seller.msgs addObjectsFromArray:data.data];
            [blockself.tableView reloadData];
        }
    }failure:^(NSString *errorStr) {
        [blockself.tableView.mj_footer endRefreshing];
        [blockself.activity stopAnimating];
    }];

    
}

@end
