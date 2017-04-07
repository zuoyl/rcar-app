//
//  ActivityViewController.m
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-15.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import "ActivityListViewController.h"
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

@interface ActivityListViewController ()<MXPullDownMenuDelegate>

@end

@implementation ActivityListViewController {
    NSMutableArray *_sellers;
    SellerInfoModel *_selectedSellerInfo;
    UIActivityIndicatorView *_activity;
    SearchCondition _curCondition;
}

@synthesize tableView;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationItem.title = @"活动一览";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(transToSearch:)];
    
    // Do any additional setup after loading the view.
    CGFloat startX = kStatusBarHeight + kTopBarHeight;
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMenuBarHeight, self.view.frame.size.width, self.view.frame.size.height - (kMenuBarHeight)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    _sellers = [[NSMutableArray alloc]init];
    
    // display activity indicator
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    _activity.backgroundColor = [UIColor grayColor];
    _activity.alpha = 0.5;
    _activity.layer.cornerRadius = 6;
    _activity.layer.masksToBounds = YES;
    [self.view addSubview:_activity];
    
    NSArray *conditionArray = @[ @[ @"不限距离", @"5公里以内", @"10公里以内", @"20公里以内" , @"30公里以内" ], @[@"所有商家", @"4S店", @"普通修理店"], @[@"距离由近到远", @"人数由多到少", @"人数由少到多"] ];
    
    MXPullDownMenu *menu = [[MXPullDownMenu alloc] initWithArray:conditionArray selectedColor:[UIColor blueColor]];
    menu.delegate = self;
    [menu setFrame:CGRectMake(0, startX, self.view.frame.size.width, kMenuBarHeight)];
    
    [self.view addSubview:menu];
    
    __block ActivityListViewController *blockSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [blockSelf loadMore];
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
    UIViewController *controller = segue.destinationViewController;
    controller.hidesBottomBarWhenPushed = YES;
    
    if ([segue.identifier isEqualToString:@"show_activity_detail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SellerInfoModel *seller = [_sellers objectAtIndex:indexPath.section];
        NSDictionary *info = [seller.activities objectAtIndex:indexPath.row];
        SellerActivityModel *activity = [self parseDictionaryToActivityModel:info];
        
        [controller setValue:seller forKey:@"seller"];
        [controller setValue:activity forKey:@"model"];
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

- (SellerActivityModel *)parseDictionaryToActivityModel:(NSDictionary *)data {
    SellerActivityModel *activity = [[SellerActivityModel alloc]init];
    activity.title = [data objectForKey:@"title"];
    activity.detail = [data objectForKey:@"detail"];
    activity.url = [data objectForKey:@"url"];
    activity.activity_id = [data objectForKey:@"activity_id"];
    activity.start_date = [data objectForKey:@"start_date"];
    activity.end_date = [data objectForKey:@"end_date"];
    
    return activity;
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
                             @"by":@"activity"};
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[SellerInfoModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    [_activity startAnimating];
    // start search
    __block ActivityListViewController *blockSelf = self;
    [RCar GET:rcar_api_user_seller_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        [_activity stopAnimating];
        
        if (dataModel.api_result != APIE_OK) {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
            return;
        }
        NSArray *dataList = dataModel.data;
        
        bool finished = false;
        if (dataList == nil || dataList.count == 0) {
            finished = true;
        } else {
            [_sellers addObjectsFromArray:dataList];
            
            if (dataList.count < Seller_List_Page_Size || _sellers.count > Seller_List_Max)
                finished = true;
        }
        [blockSelf.tableView reloadData];
    }failure:^(NSString *errorStr) {
        [_activity stopAnimating];
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
}

- (void)headerBtnClicked:(id)sender {
    UIButton *button = sender;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
    SellerInfoViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SellerInfoViewController"];
    SellerInfoModel *seller = [_sellers objectAtIndex:button.tag];
    controller.sellerId = seller.seller_id;
    [self.navigationController pushViewController:controller animated:YES];
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
    NSArray *activities = sellerInfo.activities;
    return activities.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
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
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 200, 20)];
    label.text = info.name;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentLeft;
    [bgButton addSubview:label];
    
    // distance label
    UILabel *distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(rect.size.width - 140, 10, 120, 20)];
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
    
    distanceLabel.textColor = [UIColor blueColor];
    distanceLabel.font = [UIFont systemFontOfSize:17];
    distanceLabel.textAlignment = NSTextAlignmentRight;
    [bgButton addSubview:distanceLabel];
    
    return bgButton;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"ActivityCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SellerInfoModel *seller = [_sellers objectAtIndex:indexPath.section];
    NSArray *activities = seller.activities;
    
    NSDictionary *info = [activities objectAtIndex:indexPath.row];
    SellerActivityModel *activity = [self parseDictionaryToActivityModel:info];
    
    cell.textLabel.text = activity.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *detail = [NSString stringWithFormat:@"活动时间:%@ - %@", activity.start_date, activity.end_date];
    cell.detailTextLabel.text = detail;
    
    if (activity.total_user.intValue > 0) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width - 100, 5, 60, 20)];
        label.font = [UIFont systemFontOfSize:12.f];
        label.text = [NSString stringWithFormat:@"%d人参加活动", activity.total_user.intValue];
        [cell.contentView addSubview:label];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"show_activity_detail" sender:self];
}

@end
