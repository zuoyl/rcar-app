//
//  TodoViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 22/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "WorkshopViewController.h"
#import "AdvertiseTableViewCell.h"
#import "ServiceTableViewCell.h"
#import "TotoItemCell.h"
#import "AdvertisementModel.h"
#import "DataArrayModel.h"
#import "SellerModel.h"
#import "JSBadgeView.h"
#import "NotifyCenterModel.h"
#import "FBKVOController.h"

enum {
    SERVICE_ORDER = 0,
    SERVICE_MYORDER,
    SERVICE_ACTIVITY,
    SERVICE_ADVERTISEMENT,
    SERVICE_ACCUSATION,
    SERVICE_COMMODITY,
    SERVICE_SERVICE,
    SERVICE_COMMENT,
    SERVICE_INSURANCE,
    SERVICE_NULL
};

enum {
    SECTION_ADVERTISEMENT = 0,
    SECTION_SERVICE,
    //SECTION_TODO,
    SECTION_MAX
};

@interface WorkshopViewController ()
@property (nonatomic, strong) JSBadgeView *notifyBadge;
@property (nonatomic, strong) JSBadgeView *orderBadge;
@end

@implementation WorkshopViewController {
    UIActivityIndicatorView *_activity;
    NILauncherViewModel *_launchModel;
    NSMutableArray *_advertisements;
    NSMutableArray *_todos;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = @"我的工作台";
   // self.hidesBottomBarWhenPushed = NO;
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
    
    
    _advertisements = [[NSMutableArray alloc]init];
    
    // display activity indicator
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    _activity.backgroundColor = [UIColor grayColor];
    _activity.alpha = 0.5;
    _activity.layer.cornerRadius = 6;
    _activity.layer.masksToBounds = YES;
    [self.view addSubview:_activity];
    //[_activity startAnimating];
    
    // make model for service launcher view
    NSArray *icons = @[@"bus", @"bus",@"transport",@"train",@"ship", @"ship", @"ship", @"ship"];
    NSArray *titles = @[@"接单", @"我的订单",@"发布活动", @"申请广告", @"处理投诉", @"管理商品", @"编辑服务", @"网友评价"];
    
    NSMutableArray *contents = [[NSMutableArray alloc] init];
    for( int i = 0; i < titles.count; i++){
        [contents addObject:[NILauncherViewObject objectWithTitle:[titles objectAtIndex:i] image:[UIImage imageNamed:[icons objectAtIndex:i] ]]];
    }
    _launchModel = [[NILauncherViewModel alloc] initWithArrayOfPages:@[contents] delegate:self];
    
    // registeration for cell
    UINib *nib = [UINib nibWithNibName:@"TodoItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TodoItemCell"];
    [self.tableView registerClass:[AdvertiseTableViewCell class] forCellReuseIdentifier:@"AdevertiseTableViewCell"];
    
    
    nib = [UINib nibWithNibName:@"ServiceTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ServiceTableViewCell"];
    
    
    // create badge view
    // create right item custom view
    UIButton *rbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    rbutton.backgroundColor = [UIColor clearColor];
    [rbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rbutton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"通知" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:15.f]}] forState:UIControlStateNormal];
    [rbutton addTarget:self action:@selector(NotificationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // create badeget view
    self.notifyBadge = [[JSBadgeView alloc]initWithParentView:rbutton alignment:JSBadgeViewAlignmentTopRight];
    self.notifyBadge.tintColor = [UIColor redColor];
    self.notifyBadge.backgroundColor = [UIColor clearColor];
    self.notifyBadge.badgeTextFont = [UIFont systemFontOfSize:8.f];
    
    // create kvo
    __block WorkshopViewController *blockself = self;
    NotifyCenterModel *notifyCenter = [NotifyCenterModel sharedClient];
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:notifyCenter keyPath:@"orders"
                        options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld |NSKeyValueObservingOptionInitial
                          block:^(id observer, id object, NSDictionary *change) {
        // get new data by change[NSKeyValueChangeNewKey];
        NotifyCenterModel *notifyModel = [NotifyCenterModel sharedClient];
        if (notifyModel.orders.count > 99)
            blockself.orderBadge.badgeText = @"99+";
        else if (notifyModel.orders.count > 0) {
            blockself.orderBadge.badgeText = [NSString stringWithFormat:@"%lu", (unsigned long)notifyModel.orders.count, nil];
        } else {}
    }];
    
    [self.KVOController observe:notifyCenter keyPath:@"notifications" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        // get new data by change[NSKeyValueChangeNewKey];
        NotifyCenterModel *notifyModel = [NotifyCenterModel sharedClient];
        if (notifyModel.notifications.count > 99)
            blockself.notifyBadge.badgeText = @"99+";
        else if (notifyModel.notifications.count > 0) {
            blockself.notifyBadge.badgeText = [NSString stringWithFormat:@"%lu", (unsigned long)notifyModel.notifications.count, nil];
        } else {}
    }];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    [self loadDataFromNetwork];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    segue.destinationViewController.hidesBottomBarWhenPushed = YES;
}

- (void)NotificationBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"segue_notify_center" sender:self];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return SECTION_MAX;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == SECTION_ADVERTISEMENT) return 1;
    else if (section == SECTION_SERVICE)  return 1;
   // else if (section == SECTION_TODO)  return _todos.count;
    else return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SECTION_ADVERTISEMENT) return 120;
    else if (indexPath.section == SECTION_SERVICE) return 240;
    //else if (indexPath.section == SECTION_TODO) return 40;
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *adsIdentifier = @"AdvertiseTableViewCell";
    static NSString *serviceIdentifier = @"ServiceTableViewCell";
    
    if (indexPath.section == SECTION_ADVERTISEMENT) {
        AdvertiseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:adsIdentifier];
        if (cell == nil)
            cell = [[AdvertiseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adsIdentifier];
        [cell setDataArrayWithRect:_advertisements rect:CGRectMake(0, 0, self.view.frame.size.width, 120)];
        return cell;
    }
    else if (indexPath.section == SECTION_SERVICE) {
        ServiceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:serviceIdentifier];
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:serviceIdentifier model:_launchModel delegate:self];
       // if (cell == nil)
           // cell = [[ServiceTableViewCell alloc] initWithStyle:0 reuseIdentifier:serviceIdentifier model:_launchModel delegate:self];
        return cell;
    }
  //  else if (indexPath.section == SECTION_TODO) {
  //      TotoItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RecommendCell"];
  //      return cell;
  //  }
    else  return nil;
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 }


#pragma mark - NILauncherViewModelDelegate

- (void)launcherViewModel:(NILauncherViewModel *)launcherViewModel
      configureButtonView:(UIView<NILauncherButtonView> *)buttonView
          forLauncherView:(NILauncherView *)launcherView
                pageIndex:(NSInteger)pageIndex
              buttonIndex:(NSInteger)buttonIndex
                   object:(id<NILauncherViewObject>)object {
    NILauncherButtonView* launcherButtonView = (NILauncherButtonView *)buttonView;
    
    // 若不设置UIControlStateHighlighted状态，点击后图片会被缩放
    [launcherButtonView.button setImage:object.image forState:UIControlStateHighlighted];
    [launcherButtonView.button setBackgroundImage:[UIImage imageNamed:@"navigation_button_clicked"] forState:UIControlStateHighlighted];
    
    // UIButton的image默认有padding,backgroundImage没有
    launcherButtonView.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    launcherButtonView.button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    // 在NILauncherButtonView被设置为UIViewContentModeCenter:image不会被缩放到和imageView相同大小
    launcherButtonView.button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    launcherButtonView.label.font = [UIFont boldSystemFontOfSize:12];
    launcherButtonView.label.textColor = [UIColor blackColor];
    
    // add badge view into button
    if (buttonIndex == 0) {
        self.orderBadge = [[JSBadgeView alloc]initWithParentView:launcherButtonView.button alignment:JSBadgeViewAlignmentTopRight];
        self.orderBadge.tintColor = [UIColor redColor];
        self.orderBadge.backgroundColor = [UIColor clearColor];
        self.orderBadge.badgeTextFont = [UIFont systemFontOfSize:8.f];
        self.orderBadge.badgePositionAdjustment = CGPointMake(-5, 10);
    }
}

#pragma mark - NILauncherDelegate



- (void)launcherView:(NILauncherView *)launcher didSelectItemOnPage:(NSInteger)page atIndex:(NSInteger)index {
    UIStoryboard *storyboard = nil;
    UIViewController *viewController = nil;
    switch (index) {
        case SERVICE_ORDER:
            storyboard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"OrderListViewController"];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
            break;
            
        case SERVICE_MYORDER:
            storyboard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"MyOrderListViewController"];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
            break;
            
        case SERVICE_ACTIVITY:
            storyboard = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"SellerActivityList"];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
            break;
            
        case SERVICE_ADVERTISEMENT:
            storyboard = [UIStoryboard storyboardWithName:@"Advertisement" bundle:nil];
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"AdvertisementList"];
            self.hidesBottomBarWhenPushed = YES;
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
            break;
            
        case SERVICE_ACCUSATION:
            storyboard = [UIStoryboard storyboardWithName:@"Accusation" bundle:nil];
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"AccusationList"];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
            break;
            
        case SERVICE_COMMODITY:
            storyboard = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"SellerCommodityList"];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
            break;
            
            
        case SERVICE_SERVICE:
            storyboard = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"SellerServiceList"];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
            break;
            
 
        case SERVICE_COMMENT:
            storyboard = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"SellerCommentList"];
            viewController.hidesBottomBarWhenPushed = YES;
            //[self.navigationController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
            
        default:
            break;
    }
}

#pragma  mark - date updatation

- (void)loadDataFromNetwork {
#if 0
    if (![Reachability isEnableNetwork]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络无法连接，请检查网络设置" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
#endif
    [_activity startAnimating];
    
    // get advertisement
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[AdvertisementModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    NSDictionary *params = @{@"role":@"seller"};
    __block WorkshopViewController *blockself = self;
    
    [RCar GET:rcar_api_seller_ads modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        [_activity stopAnimating];
        if (dataModel.api_result == APIE_OK) {
            NSArray *data = dataModel.data;
            if (data && data.count > 0) {
                [_advertisements removeAllObjects];
                [_advertisements addObjectsFromArray:data];
                [blockself.tableView reloadData];
            }
        }
        
    }failure:^(NSString *errorStr) {
       // [self handleLoadError:errorStr];
    }];

    SellerModel *seller = [SellerModel sharedClient];
    if (seller.islogin == false) {
        NSDictionary *params = @{@"role":@"seller", @"id":seller.seller_id, @"pwd":seller.pwd};
        [RCar POST:rcar_api_seller_session modelClass:nil config:nil  params:params success:^(id result) {
            SellerModel *seller = [SellerModel sharedClient];
            seller.islogin = true;
            
            [seller loadDataFromNetwork:seller.seller_id success:^(id result) {
                [blockself.tableView reloadData];
            } failure:^(NSString *errorStr) {
                MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力，请稍后再试" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
                [alert show:self];
                return;
            }];
            
        } failure:^(NSString *errorStr) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力，请稍后再试" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }];
    }

}



@end
