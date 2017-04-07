//
//  SellerActivityListViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 8/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "ActivityListViewController.h"
#import "SellerActivityModel.h"
#import "DataArrayModel.h"
#import "SellerActivityCell.h"
#import "SellerInfoModel.h"
#import "SellerModel.h"

@interface ActivityListViewController () <MxAlertViewDelegate>

@end

@implementation ActivityListViewController {
    NSMutableArray *_activities;
    SellerModel *_seller;
    NSIndexPath *_indexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"商家活动";
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
    
    UINib *nib = [UINib nibWithNibName:@"SellerActivityCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"SellerActivityCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _seller = [SellerModel sharedClient];
    _activities = _seller.activities;

    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addActivity:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItems = @[rightItem];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    [self.tableView registerClass:[SellerActivityCell class] forCellReuseIdentifier:@"SellerActivityCell"];
    
    if (_activities.count == 0)
        [self loadSellerActivityList];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)addActivity:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    [self performSegueWithIdentifier:@"activity_add" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UIViewController *controller = segue.destinationViewController;
    
    if ([controller respondsToSelector:@selector(setModel:)])
        [controller setValue:[_activities objectAtIndex:indexPath.row] forKey:@"model"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _activities.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SellerActivityCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SellerActivityCell" forIndexPath:indexPath];
    [cell setModel:[_activities objectAtIndex:indexPath.row]];
    
    NSMutableArray *buttons = [[NSMutableArray alloc]init];
    [buttons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
    [cell setRightUtilityButtons:buttons WithButtonWidth:50];
    cell.delegate = self;
    cell.path = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.hidesBottomBarWhenPushed = YES;
    [self performSegueWithIdentifier:@"activity_view" sender:self];
}

#pragma mark - SWTabelViewCellDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    _indexPath = cell.path;
    if (index == 0) { // delete
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"您确定要删除此项服务吗" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"取消", nil];
        [alert show:self];
     }
}

- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self deleteActivity:[_activities objectAtIndex:_indexPath.row]];
        [self.tableView reloadData];
    }
}

- (void) deleteActivity:(SellerActivityModel *)activity {
    if (activity.activity_id == nil || [activity.activity_id isEqualToString:@""]) {
        // it is illegal activity, just delete from local
        [_activities removeObject:activity];
        [self.tableView reloadData];
        return;
    }
    SellerModel *seller = [SellerModel sharedClient];
    __block ActivityListViewController *blockself = self;
    __block SellerActivityModel *blockActivity = activity;
    NSDictionary *params = @{@"role":@"seller", @"seller_id":seller.seller_id, @"activity_id":activity.activity_id};
    [RCar DELETE:rcar_api_seller_activity modelClass:@"APIResponseModel" config:nil params:params success:^(APIResponseModel *model) {
        if (model.api_result == APIE_OK) {
            [_activities removeObject:blockActivity];
            [blockself.tableView reloadData];
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show:self];
        }
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络通信错误，请检查网络连接" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }];
}

- (void)loadSellerActivityList {
    SellerModel *seller = [SellerModel sharedClient];
    __block ActivityListViewController *blockself = self;
    NSDictionary *params = @{@"role":@"seller", @"seller_id":seller.seller_id};
    
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    DCArrayMapping *activityMaping = [DCArrayMapping mapperForClassElements:[SellerActivityModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    
    [config addArrayMapper:activityMaping];
    [RCar GET:rcar_api_seller_activity_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *model) {
        if (model.api_result == APIE_OK) {
            [_activities addObjectsFromArray:model.data];
            [blockself.tableView reloadData];
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show:self];
        }
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络通信错误，请检查网络连接" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }];
}





@end
