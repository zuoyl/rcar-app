//
//  ServiceCarCleanListViewController.m
//  CarUser
//
//  Created by huozj on 1/27/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "ServiceListViewController.h"
#import "SellerInfoModel.h"
#import "SellerSearchViewController.h"
#import "DataArrayModel.h"
#import "SellerServiceModel.h"
#import "SellerInfoCell.h"
#import "SellerServiceCell.h"
#import "MXPullDownMenu.h"
#import "SellerCarCleanServiceViewController.h"
#import "SearchCondition.h"
#import "SellerInfoViewController.h"
#import "SellerServiceDetailViewController.h"
#import "MJRefresh.h"

#define Seller_List_Page_Size 10
#define Seller_List_Max 200
#define Finished_Label_Tag 112

#define kMenuBarHeight 30.f


@interface ServiceListViewController ()<MXPullDownMenuDelegate>

@end

@implementation ServiceListViewController {
    NSMutableArray *_sellers;
    SellerInfoModel *_selectedSellerInfo;
    UIActivityIndicatorView *_activity;
    SearchCondition _curCondition;
}

@synthesize tableView;
@synthesize type;
@synthesize isChildController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationItem.title = @"商家一览";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(transToSearch:)];
    
    CGFloat startX = 64.f;
    if (self.isChildController == YES)
        startX = 0.f;
    NSArray *conditionArray = @[ @[ @"不限距离", @"5公里以内", @"10公里以内", @"20公里以内" , @"30公里以内" ], @[@"所有商家", @"4S店", @"普通修理店"], @[@"距离由近到远", @"价格由低到高", @"价格由高到低"] ];
    
    MXPullDownMenu *menu = [[MXPullDownMenu alloc] initWithArray:conditionArray selectedColor:[UIColor blueColor]];
    [menu setFrame:CGRectMake(0, startX, self.view.frame.size.width, kMenuBarHeight)];
    menu.delegate = self;
    [self.view addSubview:menu];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, startX + kMenuBarHeight, self.view.frame.size.width, self.view.frame.size.height - (kMenuBarHeight)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:self.tableView];
    
    _sellers = [[NSMutableArray alloc]init];
    
    // display activity indicator
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    _activity.backgroundColor = [UIColor grayColor];
    _activity.alpha = 0.5;
    _activity.layer.cornerRadius = 6;
    _activity.layer.masksToBounds = YES;
    //[self.view addSubview:_activity];
    
    
    __block ServiceListViewController *blockself = self;
    self.tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [blockself loadMore];
    }];
    
    
    [self initCurCondition];
    [self loadSellersWithCondition:_curCondition fromIndex:0];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    SellerInfoModel *info = [_sellers objectAtIndex:indexPath.section];
    NSArray *serviceList = info.services;
    NSDictionary *serviceInfo = [serviceList objectAtIndex:indexPath.row];
    SellerServiceModel *model = [self parseDictionaryToServiceModel:serviceInfo];
    
    UIViewController *controller = segue.destinationViewController;
    controller.hidesBottomBarWhenPushed = YES;
    
    if ([segue.identifier isEqualToString:@"SellerServiceDetailView"]) {
        [controller setValue:model forKey:@"serviceModel"];
        [controller setValue:info forKey:@"sellerModel"];
        [controller setValue:@(YES) forKey:@"isDisplaySellerInfo"];
        return;
    }
    
    if ([segue.identifier isEqualToString:@"SellerDetailView"]) {
        [controller setValue:info.seller_id forKey:@"sellerId"];
        return;
    }
}


- (void)initCurCondition {
    _curCondition.distance = 0;
    _curCondition.sellerType = 0;
    _curCondition.sortType = 0;
}

- (NSMutableDictionary *)getCurCondition {
    NSMutableDictionary *condition = [[NSMutableDictionary alloc]initWithCapacity:3];
    
    NSArray *distanceArray = @[@40000000, @5000, @10000, @20000, @30000];
    [condition setObject:[distanceArray objectAtIndex:_curCondition.distance] forKey:@"distance"];
    
    NSArray *sellerTypeArray = @[@"all", @"4s", @"repair"];
    [condition setObject:[sellerTypeArray objectAtIndex:_curCondition.sellerType] forKey:@"seller_type"];
    
    NSArray *sortTypeArray = @[@"distance", @"priceL2H", @"priceH2L"];
    [condition setObject:[sortTypeArray objectAtIndex:_curCondition.sortType] forKey:@"sort_type"];
    
    return condition;
}

- (void)transToSearch:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Search" bundle:nil];
    SellerSearchViewController *viewController = (SellerSearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SellerSearch"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (SellerServiceModel *)parseDictionaryToServiceModel:(NSDictionary *)data {
    SellerServiceModel *serviceInfo = [[SellerServiceModel alloc]init];
    //serviceInfo.uuid;
    serviceInfo.title = [data objectForKey:@"title"];
    //serviceInfo.type;
    serviceInfo.desc = [data objectForKey:@"desc"];
    serviceInfo.price = [data objectForKey:@"price"];
    serviceInfo.url = [data objectForKey:@"url"];
    serviceInfo.images = [data objectForKey:@"images"];
    //serviceInfo.seller_id = [data objectForKey:@"seller_id"];
    serviceInfo.service_id = [data objectForKey:@"service_id"];
    
    return serviceInfo;
}

- (void)loadMore {
    [self loadSellersWithCondition:_curCondition fromIndex:_sellers.count];
}

- (void)loadSellersWithCondition:(SearchCondition)condition fromIndex:(NSInteger)index {
    UserModel *userModel = [UserModel sharedClient];
    NSDictionary *searchCondition = [self getCurCondition];
    NSDictionary *params = @{@"role":@"user",
                             @"offset":[NSNumber numberWithInteger:index],
                             @"number":[NSNumber numberWithInteger:Seller_List_Page_Size],
                             @"city":userModel.selectedCity,
                             @"lat":[NSNumber numberWithDouble:userModel.location.coordinate.latitude ],
                             @"lng":[NSNumber numberWithDouble:userModel.location.coordinate.longitude ],
                             @"condition":searchCondition,
                             @"type":self.type,
                             @"scope":@"service"};
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[SellerInfoModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    // start search
    __block ServiceListViewController *blockSelf = self;
    [RCar GET:rcar_api_user_seller_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        [blockSelf.tableView.mj_footer endRefreshing];
        if (dataModel.api_result == APIE_OK) {
            NSArray *dataList = dataModel.data;
            if (dataList.count > 0) {
                [_sellers addObjectsFromArray:dataList];
                [blockSelf.tableView reloadData];
                [blockSelf.tableView.mj_footer endRefreshing];
                if (dataList.count <= Seller_List_Page_Size) {
                    [blockSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }
    }failure:^(NSString *errorStr) {
        [blockSelf.tableView.mj_footer endRefreshing];
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
}

- (void)headerBtnClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger section = button.tag;
    
    _selectedSellerInfo = [_sellers objectAtIndex:section];
    [self performSegueWithIdentifier:@"SellerDetailView" sender:self];
}

#pragma mark - MXPullDownMenuDelegate

- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
    SearchCondition oldCondition = _curCondition;
    switch (column) {
        case 0:
            _curCondition.distance = row;
            break;
        case 1:
            _curCondition.sellerType = row;
            break;
        case 2:
            _curCondition.sortType = row;
            break;
        default:
            break;
    }
    if (memcmp(&oldCondition, &_curCondition, sizeof(oldCondition)) != 0) {
        [_sellers removeAllObjects];
        [self loadSellersWithCondition:_curCondition fromIndex:0];
    }
}

#pragma mark - MxAlertViewDelegate
- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return _sellers.count;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    SellerInfoModel *sellerInfo = [_sellers objectAtIndex:section];
    NSArray *serviceList = sellerInfo.services;
    return serviceList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // get section header's rect
    CGRect rect = [self.tableView rectForHeaderInSection:section];
    
    UIButton *bgButton = [[UIButton alloc]initWithFrame:rect];
    bgButton.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    [bgButton addTarget:self action:@selector(headerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    bgButton.tag = section;
    
    SellerInfoModel *info = [_sellers objectAtIndex:section];
    
    // title label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 200, rect.size.height)];
    label.contentMode = UIControlContentVerticalAlignmentCenter;
    label.text = info.name;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15.f];
    label.textAlignment = NSTextAlignmentLeft;
    [bgButton addSubview:label];

    // distance label
    UILabel *distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(rect.size.width - 140, 0, 120, rect.size.height)];
    distanceLabel.contentMode = UIControlContentVerticalAlignmentCenter;
    if (info.distance.floatValue >= 1.0) {
        NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
        [format setNumberStyle:NSNumberFormatterDecimalStyle];
        [format setMaximumFractionDigits:1];
        distanceLabel.text = [format stringFromNumber:info.distance];
        distanceLabel.text = [distanceLabel.text stringByAppendingString:@"公里"];
    } else {
        NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
        [format setNumberStyle:NSNumberFormatterDecimalStyle];
        [format setMaximumFractionDigits:0];
        distanceLabel.text = [format stringFromNumber:[NSNumber numberWithFloat:info.distance.floatValue *1000]];
        distanceLabel.text = [distanceLabel.text stringByAppendingString:@"米"];
        
    }
    
    distanceLabel.textColor = [UIColor blackColor];
    distanceLabel.font = [UIFont systemFontOfSize:15];
    distanceLabel.textAlignment = NSTextAlignmentRight;
    [bgButton addSubview:distanceLabel];
    
    return bgButton;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"SellerServiceCell";
    SellerServiceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
        cell = [[SellerServiceCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //CGFloat height = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
    CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
    SellerInfoModel *info = [_sellers objectAtIndex:indexPath.section];
    NSArray *serviceList = info.services;
    NSDictionary *serviceInfo = [serviceList objectAtIndex:indexPath.row];
    SellerServiceModel *model = [self parseDictionaryToServiceModel:serviceInfo];
    [cell setModelAndFrame:model frame:rect];
    cell.serviceDelegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"SellerServiceDetailView" sender:self];
}



@end
