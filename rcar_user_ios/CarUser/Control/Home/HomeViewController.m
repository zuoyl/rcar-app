//
//  FirstViewController.m
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-12.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import "HomeViewController.h"
#import "SellerSearchViewController.h"

#import "SOSViewController.h"
#import "StatusView.h"
#import "UserModel.h"
#import "AdvertisementModel.h"
#import "DataArrayModel.h"
#import "CommonUtil.h"
#import "NavigationView.h"
#import "SellerInfoViewController.h"
#import "MTPublicateStep1ViewController.h"
#import "UserModel.h"
#import "RecommendModel.h"
#import "MJRefresh.h"
#import "RecommendTableViewCell.h"
#import "RNFullScreenScroll.h"
#import "UIViewController+RNFullScreenScroll.h"
#import "MJRefresh.h"
#import "JSBadgeView.h"
#import "NotifyCenterModel.h"
#import "MYBlurIntroductionView.h"
#import "MYIntroductionPanel.h"
#import "OrderModel.h"
#import "MxLauncherView.h"

enum {
    SERVICE_CLEAN,
    SERVICE_FAULT,
    SERVICE_MAINTENANCE,
    SERVICE_SOS,
    SERVICE_ACTIVITY,
    SERVICE_OTHER,
    SERVICE_NULL,
};

#define Recommend_Page_Size 20


@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate, MxLauncherViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) JSBadgeView *badge;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MxLauncherView *launcherView;

@end



@implementation HomeViewController {
    NSDate *_hudShowTime;
    BOOL _isShowingLocalCache;
    UISearchBar *_searchBar;
    NSString *_city;
    AppDelegate *_mDelegate;
    NSMutableArray *_recommendArray;
    NSMutableArray *_advertiseArray;
    ViewStatusType _status;
    NSMutableDictionary *_sellerDetails;
    bool _advertisementFinished;
    bool _recommendFinished;
    
}

@synthesize advertiseView;


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithHex:@"2480ff"]];
    self.hidesBottomBarWhenPushed = TRUE;
    
    // set default city
    UserModel *userModel = [UserModel sharedClient];
    _city = userModel.selectedCity;
    _sellerDetails = [[NSMutableDictionary alloc]init];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:[_city substringToIndex:2] style:UIBarButtonItemStylePlain target:self action:@selector(cityButtonClicked:)];
    [leftItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    // create right item custom view
    UIButton *rbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    rbutton.backgroundColor = [UIColor clearColor];
    [rbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rbutton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"通知" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:15.f]}] forState:UIControlStateNormal];
    [rbutton addTarget:self action:@selector(NotificationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // create badeget view
    self.badge = [[JSBadgeView alloc]initWithParentView:rbutton alignment:JSBadgeViewAlignmentTopRight];
    self.badge.tintColor = [UIColor redColor];
    self.badge.backgroundColor = [UIColor clearColor];
    self.badge.badgeTextFont = [UIFont systemFontOfSize:8.f];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(30, 0, 200, 44)];
    _searchBar.delegate = self;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.showsCancelButton = NO;
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.placeholder = @"输入商家,商品,车辆品牌";
    _searchBar.tintColor = [UIColor whiteColor];
    _searchBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.titleView = _searchBar;
    
    // create scroll view
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.scrollView];
    
    // create advertisment view
    
    self.advertiseView = [[AdvertisementView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120.f)];
    [self.scrollView addSubview:self.advertiseView];
    
    // create launcher view
    NSArray *icons = @[@"cleaning", @"fault", @"maintenance", @"SOS", @"parts", @"more",@"more", @"more", @"more",];
    
    self.launcherView = [[MxLauncherView alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 130)];
    self.launcherView.row = 2;
    self.launcherView.column = 3;
    self.launcherView.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    self.launcherView.padding = 2;
    self.launcherView.delegate = self;
    [self.launcherView addImageArray:icons];
    [self.scrollView addSubview:self.self.launcherView];
    

    // create recommend seller
    // recommend label
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 30)];
    titleView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    [self.view addSubview:titleView];
    
    UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 5, 30)];
    tagLabel.backgroundColor = [UIColor colorWithHex:@"2480ff"];
    [titleView addSubview:tagLabel];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 20, 30)];
    textLabel.text = @"推荐商家";
    textLabel.font = [UIFont systemFontOfSize:12.f];
    textLabel.contentMode = UIControlContentVerticalAlignmentCenter;
    [titleView addSubview:textLabel];
    [self.scrollView addSubview:titleView];
    
    
    // create recomment table view
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 280, self.view.frame.size.width, self.view.frame.size.height - 280) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    __block HomeViewController *blockself = self;
    self.tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [blockself loadMore];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
    [self.scrollView addSubview:self.tableView];
    
   
    _recommendFinished = false;
    _advertisementFinished = false;
    
    
    self.fullScreenScroll = [[RNFullScreenScroll alloc] initWithViewController:self scrollView:self.scrollView];

    // register kvo controller
    NotifyCenterModel *notifyCenter = [NotifyCenterModel sharedClient];
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:notifyCenter keyPath:@"notifications"
                        options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld |NSKeyValueObservingOptionInitial
                          block:^(id observer, id object, NSDictionary *change) {
        // get new data by change[NSKeyValueChangeNewKey];
        NotifyCenterModel *notifyModel = [NotifyCenterModel sharedClient];
        if (notifyCenter.notifications.count > 99)
            blockself.badge.badgeText = @"99+";
        else if (notifyCenter.notifications.count != 0)
            blockself.badge.badgeText = [NSString stringWithFormat:@"%lu", (unsigned long)notifyModel.notifications.count, nil];
    }];
    
    // load from local cache at first
    _advertiseArray = [[NSMutableArray alloc] init];
    _recommendArray = [[NSMutableArray alloc] init];
    [self loadDataFromNetwork];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - MxLauncherViewDelegate
- (void) launcherView:(MxLauncherView *)view page:(NSInteger)page index:(NSInteger)index {
    UIStoryboard *storyboard = nil;
    UIViewController *viewController = nil;
    self.hidesBottomBarWhenPushed = YES;
    
    switch (index) {
        case SERVICE_CLEAN:
            storyboard = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"ServiceListViewController"];
            [viewController setValue:kServiceType_CarClean forKey:@"type"];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
            break;
            
        case SERVICE_MAINTENANCE:
            [self performSegueWithIdentifier:@"home_show_maintenance" sender:self];
            break;
            
        case SERVICE_SOS:
            [self performSegueWithIdentifier:@"home_show_sos" sender:self];
            break;
            
        case SERVICE_FAULT:
            storyboard = [UIStoryboard storyboardWithName:@"Fault" bundle:nil];
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"FaultReportViewController"];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
            break;
            
        case SERVICE_ACTIVITY:
            [self performSegueWithIdentifier:@"home_show_activity" sender:self];
            break;
            
        case SERVICE_OTHER:
            [self performSegueWithIdentifier:@"home_show_other" sender:self];
            break;
            
        default:
            break;
    }
}



#pragma mark - Common methods
- (void) saveListToLocalCache {
    static NSString *advertisementID = @"advertisementId";
    static NSString *recommendID = @"recommendId";
    if (_advertiseArray.count > 0) {
        [NSKeyedArchiver archiveRootObject:_advertiseArray
                                    toFile:[[SharedAppDelegate cachePath] stringByAppendingPathComponent:[@"advertisements" stringByAppendingString:advertisementID]]];
    }
    if (_recommendArray.count > 0) {
        [NSKeyedArchiver archiveRootObject:_recommendArray
                                    toFile:[[SharedAppDelegate cachePath] stringByAppendingPathComponent:[@"recommends" stringByAppendingString:recommendID]]];
    }
}

- (BOOL) readListFromLocalCache{
    _advertiseArray = [[NSKeyedUnarchiver unarchiveObjectWithFile: [[SharedAppDelegate cachePath] stringByAppendingPathComponent:[@"advertisements" stringByAppendingString:@"advertisementId"]]] mutableCopy];
    _recommendArray = [[NSKeyedUnarchiver unarchiveObjectWithFile: [[SharedAppDelegate cachePath] stringByAppendingPathComponent:[@"recommends" stringByAppendingString:@"recommendId"]]] mutableCopy];
    return _advertiseArray && _recommendArray;
}

- (void)NotificationBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"home_show_notify" sender:self];
}

- (void)cityButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"home_show_city" sender:self];
}

- (void)notificationCenterClicked:(id)sender {
    [self performSegueWithIdentifier:@"home_show_notify" sender:self];
}


#pragma mark - CitySelectDelegate

- (void)citySelected:(NSString *)name {
    _city = [NSString stringWithString:name];
    
    // change city title
    self.navigationItem.leftBarButtonItem.title = [_city substringToIndex:2];
    
    UserModel *userModel = [UserModel sharedClient];
    userModel.selectedCity = name;
    
    // load request to pull recommend and advertisement
    [self loadDataFromNetwork];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *controller = segue.destinationViewController;
    controller.hidesBottomBarWhenPushed = YES;
    if ([controller respondsToSelector:@selector(setDelegate:)]) {
        [controller setValue:self forKey:@"delegate"];
    }
}

#pragma mark - UISearchBar Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Search" bundle:nil];
    SellerSearchViewController *viewController = (SellerSearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SellerSearch"];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    
    return NO;
}

#pragma mark - SellerSearchDelegate
- (void)sellerSearchComplete:(NSDictionary *)result {
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _recommendArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecommendTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RecommendItemCell"];
    if (cell == nil)
        cell = [[RecommendTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RecommendItemCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    RecommendModel *model = [_recommendArray objectAtIndex:indexPath.row];
    [cell setModelWithinFrame:model frame:CGRectMake(0, 0, self.view.frame.size.width, 64.f)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_recommendArray.count > 0) {
        RecommendModel *recommend = [_recommendArray objectAtIndex:indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SellerInfoViewController"];
        controller.hidesBottomBarWhenPushed = YES;
        [controller setValue:recommend.seller_id forKey:@"sellerId"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


#pragma mark - HomeViewController



- (void)loadDataFromNetwork {
#if 0
    if (![Reachability isEnableNetwork]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"提示信息" message:@"网络无法连接，请检查网络设置" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
#endif
    __block HomeViewController *blockself = self;
    
    // get advertisement
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[AdvertisementModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    NSDictionary *aparams = @{@"role":@"seller", @"city":_city};
    [RCar GET:rcar_api_user_advertisement modelClass:@"DataArrayModel" config:config params:aparams success:^(DataArrayModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            if (dataModel.data.count > 0) {
                [_advertiseArray removeAllObjects];
                [_advertiseArray addObjectsFromArray:dataModel.data];
                [blockself.advertiseView setDataArray:_advertiseArray];
            }
            _advertisementFinished = true;
            if (_recommendFinished)
                [blockself handleLoadFinished];
        } else {
            [blockself handleLoadError:Data_Load_Failure];
            NSMutableArray *imageArray = [[NSMutableArray alloc]init];
            [imageArray addObject:[UIImage imageNamed:@"Launch1.jpg"]];
            [imageArray addObject:[UIImage imageNamed:@"Launch2.png"]];
            
            [blockself.advertiseView setImageArray:imageArray];
        }
        
    }failure:^(NSString *errorStr) {
        [blockself handleLoadError:errorStr];
        NSMutableArray *imageArray = [[NSMutableArray alloc]init];
        [imageArray addObject:[UIImage imageNamed:@"Launch1.jpg"]];
        [imageArray addObject:[UIImage imageNamed:@"Launch2.png"]];
        [blockself.advertiseView setImageArray:imageArray];
        
    }];
    
    // get recommend list
    NSDictionary *rparams =  @{@"role":@"seller", @"city":_city, @"offset":[NSNumber numberWithInteger:_recommendArray.count], @"num":[NSNumber numberWithInteger:Recommend_Page_Size] };
    
    mapper = [DCArrayMapping mapperForClassElements:[RecommendModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    
    [RCar GET:rcar_api_user_recommends modelClass:@"DataArrayModel" config:config params:rparams success:^(DataArrayModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            [_recommendArray removeAllObjects];
            for (RecommendModel *recommend in dataModel.data) {
                if (recommend && recommend.name != nil && ![recommend.name isEqualToString:@""]
                    && recommend.seller_id != nil && ![recommend.seller_id isEqualToString:@""])
                    [_recommendArray addObject:recommend];
            }
            _recommendFinished = true;
            if (_advertisementFinished)
                [blockself handleLoadFinished];
        } else {
            [blockself handleLoadError:Data_Load_Failure];
        }
    }failure:^(NSString *errorStr) {
        [blockself handleLoadError:errorStr];
    }];
}

- (void)loadMore {
    if (![Reachability isEnableNetwork]) {
//        [CommonUtil showHintHUD:No_Network_Connection inView:self.view];
//        [self.tableView.infiniteScrollingView stopAnimating];
//        return;
    }
    
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[RecommendModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    [config addArrayMapper:mapper];
    
    // get recommend list
    __block HomeViewController *blockself = self;
    NSDictionary *params =  @{@"role":@"seller", @"city":_city, @"offset":[NSNumber numberWithInteger:_recommendArray.count], @"num":[NSNumber numberWithInteger:Recommend_Page_Size] };
    
    [RCar GET:rcar_api_user_recommends modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        [blockself.tableView.mj_footer endRefreshing];
        if (dataModel.api_result == APIE_OK) {
            if (dataModel.data.count > 0) {
                for (RecommendModel *recommend in dataModel.data) {
                    if (recommend && recommend.name != nil && ![recommend.name isEqualToString:@""]
                        && recommend.seller_id != nil && ![recommend.seller_id isEqualToString:@""])
                        [_recommendArray addObject:recommend];
                    [blockself.tableView reloadData];
                }
                if (dataModel.data.count < Recommend_Page_Size) { // no more data
                    [blockself.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }
    }failure:^(NSString *errorStr) {
        [blockself.tableView.mj_footer endRefreshingWithNoMoreData];
        
        [self handleLoadError:errorStr];
    }];
}




- (void)handleLoadFinished {
    [self.advertiseView setDataArray:_advertiseArray];
    [self.tableView reloadData];
}

- (void) handleLoadError:(NSString *) errorStr{
    if (![CommonUtil isShowingHint])
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
}


@end
