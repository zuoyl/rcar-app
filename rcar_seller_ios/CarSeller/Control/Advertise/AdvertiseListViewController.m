//
//  AdvertiseListViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 1/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "AdvertiseListViewController.h"
#import "SellerModel.h"
#import "AdvertisementModel.h"
#import "DCArrayMapping.h"
#import "DataArrayModel.h"
#import "AdvertiseViewController.h"
#import "SWTableViewCell.h"
#import "SellerAdvertisementCell.h"


@interface AdvertiseListViewController () <SWTableViewCellDelegate>

@end

@implementation AdvertiseListViewController {
    NSMutableArray *_advertisements;
    SellerModel *_seller;
    UIActivityIndicatorView *_activity;
    NSInteger _offset;
    NSInteger _number;
}
@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.hidesBottomBarWhenPushed = YES;
    //self.tabBarController.tabBar.hidden = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"我的广告";
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
    
    _seller = [SellerModel sharedClient];
    _advertisements = _seller.advertisements;
    _offset = 0;
    _number = 20;
    
    // display activity indicator
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    _activity.backgroundColor = [UIColor grayColor];
    _activity.alpha = 0.5;
    _activity.layer.cornerRadius = 6;
    _activity.layer.masksToBounds = YES;
    [self.view addSubview:_activity];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addAdvertisement:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // register table view cell
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (_advertisements.count == 0) {
        [self loadMyAdvertisements];
    } else {
        [self.tableView reloadData];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *controller = segue.destinationViewController;
    controller.hidesBottomBarWhenPushed = YES;
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath != nil) {
        AdvertisementModel *advertisement = [_advertisements objectAtIndex:indexPath.row];
        if ([controller respondsToSelector:@selector(setModel:)])
            [controller setValue:advertisement  forKey:@"model"];
    }
}

- (void)addAdvertisement:(id)sender {
    [self performSegueWithIdentifier:@"advertisement_add" sender:self];
}

- (void)loadMyAdvertisements {
    [_activity startAnimating];
    NSDictionary *params = @{@"role":@"seller", @"seller_id":_seller.seller_id, @"num":[NSNumber numberWithLong:_number], @"offset":[NSNumber numberWithLong:_offset]};
    
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[AdvertisementModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    __block AdvertiseListViewController *blockself = self;
    [RCar GET:rcar_api_seller_ads modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *data) {
        [_activity stopAnimating];
        if (data.api_result == APIE_OK) {
            if (data.data != nil && data.data.count > 0) {
                [_seller.advertisements addObjectsFromArray:data.data];
                _offset += data.data.count;
                [blockself.tableView reloadData];
            }
        } else {
            [blockself handleLoadError:nil];
        }
    } failure:^(NSString *errorStr) {
        [blockself handleLoadError:errorStr];
    }];
    
}

- (void)handleLoadError:(NSString *)error {
    [_activity stopAnimating];
    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show:self];
    return;
}


- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self loadMyAdvertisements];
    } else {
        //[self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _advertisements.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"AdvertisementCell";
    SellerAdvertisementCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
        cell = [[SellerAdvertisementCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    
    AdvertisementModel *model = [_advertisements objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setModel:model];
    // Configure the cell...
    
    NSMutableArray *buttons = [[NSMutableArray alloc]init];
    [buttons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
    [cell setRightUtilityButtons:buttons WithButtonWidth:50];
    cell.delegate = self;
    cell.path = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"advertisement_view" sender:self];
}

#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = cell.path;
    if (index == 0) { // delete
        [self deleteAdvertisement:[_advertisements objectAtIndex:indexPath.row]];
        [self.tableView reloadData];
    }
}

- (void)deleteAdvertisement:(AdvertisementModel *)model {
    SellerModel *seller = [SellerModel sharedClient];
    __block AdvertiseListViewController *blockself = self;
    __block AdvertisementModel *blockAds = model;
    NSDictionary *params = @{@"role":@"seller", @"seller_id":seller.seller_id, @"ads_id":model.ads_id};
    [RCar DELETE:rcar_api_seller_advertisement modelClass:@"APIResponseModel" config:nil  params:params success:^(APIResponseModel *rsp) {
        if (rsp.api_result == APIE_OK) {
            [_advertisements removeObject:blockAds];
            [blockself.tableView reloadData];
        } else if (rsp.api_result == APIE_INVALID_CLIENT_REQ) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"运行中得广告不能直接删除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
        }
        else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
        }
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力,请稍后再试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }];
    
}

@end
