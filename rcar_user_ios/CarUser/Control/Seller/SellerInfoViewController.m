//
//  SellerInfoViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 8/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerInfoViewController.h"

#import "SellerInfoModel.h"
#import "SizeableImageTableViewCell.h"


#import "SellerActivityCell.h"
#import "SellerCommodityCell.h"
#import "SellerInfoCell.h"
#import "SellerCommentCell.h"
#import "SellerCommodityModel.h"
#import "SellerActivityModel.h"
#import "SellerServiceModel.h"

#import "RecentRepository.h"
#import "SellerServiceContactViewController.h"
#import "SellerCarCleanServiceViewController.h"
#import "FavoriteRepository.h"
#import "RecentRepository.h"
#import "ImagePageView.h"
#import "HMSegmentedControl.h"
#import "SSLineView.h"

#import "SellerCommentListViewController.h"
#import "SellerCommodityListViewController.h"
#import "SellerActivityListViewController.h"
#import "SellerServiceListViewController.h"
#import "SellerInfoListViewController.h"
#import "LoginViewController.h"


enum {
    SECTION_INFO = 0,
    SECTION_SERVICE,
    SECTION_ACTIVITY,
    SECTION_COMMODITY,
    SECTION_COMMENT,
    SECTION_MAX
};

@interface SellerInfoViewController () <MxAlertViewDelegate, LoginViewDelegate, SellerInfoListDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ImagePageView *imageView;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *telephoneLabel;
@property (nonatomic, strong) HMSegmentedControl *segmentCtrl;
@property (nonatomic, strong) NSMutableArray *controlers;

@end

@implementation SellerInfoViewController {
    UIActivityIndicatorView *_activity;
    SellerDetailInfoModel *_detailModel;
}

enum {
    AlertReason_LoginForFavorite = 0x400,
};

@synthesize sellerId;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商家详细";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    
    // create scroll view
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.scrollView];
    
    // create image view
    self.imageView = [[ImagePageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150.f)];
    if (_detailModel != nil && _detailModel.images != nil)
        [self.imageView setImages:_detailModel.images];
    [self.scrollView addSubview:self.imageView];
    
    self.infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.imageView.frame.size.height - 30, self.imageView.frame.size.width - 50, 30)];
    self.infoLabel.backgroundColor = [UIColor clearColor];
    self.infoLabel.textColor = [UIColor whiteColor];
    self.infoLabel.font = [UIFont systemFontOfSize:13.f];
    [self.imageView addSubview:self.infoLabel];
    
    UILabel *favLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 80, self.imageView.frame.size.height - 30, 60, 30.f)];
    favLabel.backgroundColor = [UIColor clearColor];
    favLabel.textColor = [UIColor whiteColor];
    favLabel.font = [UIFont systemFontOfSize:13.f];
    favLabel.text = @"收藏";
    favLabel.textAlignment = NSTextAlignmentRight;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(favoriteBtnClicked:)];
    favLabel.userInteractionEnabled = YES;
    [favLabel addGestureRecognizer:tapGesture];
    [self.imageView addSubview:favLabel];
    [self.imageView bringSubviewToFront:favLabel];
    
    // create address label
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 150.f, self.view.frame.size.width - 100, 35.f)];
    [self.scrollView addSubview:self.addressLabel];
    self.addressLabel.font = [UIFont systemFontOfSize:15.f];
    self.addressLabel.text = @"地址:";
    self.addressLabel.textColor = [UIColor lightGrayColor];
    
    
    UIImageView *mapImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50, 150.f, 40, 35.f)];
    [mapImageView setImage:[UIImage imageNamed:@"notesicon"]];
    mapImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapBtnClicked:)];
    [mapImageView addGestureRecognizer:singleTap1];
    [self.scrollView addSubview:mapImageView];
    
    
    SSLineView *lineView = [[SSLineView alloc]initWithFrame:CGRectMake(0, 185, self.view.frame.size.width, 0.5)];
    lineView.lineColor = [UIColor lightGrayColor];
    
    [self.scrollView addSubview:lineView];
    
    // create telephone label
    self.telephoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 185.f, self.view.frame.size.width, 35.f)];
    [self.scrollView addSubview:self.telephoneLabel];
    self.telephoneLabel.font = [UIFont systemFontOfSize:15.f];
    self.telephoneLabel.textColor = [UIColor lightGrayColor];
    self.telephoneLabel.text = @"电话:";
    
    UIImageView *telImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50, 185.f, 40, 35.f)];
    [telImageView setImage:[UIImage imageNamed:@"notesicon"]];
    telImageView.userInteractionEnabled = YES;
   // telImageView addGestureRecognizer:[UIGestureRecognizer alloc]init
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(telBtnClicked:)];
    [telImageView addGestureRecognizer:singleTap2];
    [self.scrollView addSubview:telImageView];
    
    // create segment control
    self.segmentCtrl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"服务", @"商品", @"活动", @"评价"]];
    self.segmentCtrl.frame = CGRectMake(0, 220, self.view.frame.size.width, 30);
    [self.segmentCtrl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    self.segmentCtrl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.segmentCtrl.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.segmentCtrl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentCtrl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentCtrl.selectionIndicatorColor = [UIColor colorWithHex:@"2480ff"];
    self.segmentCtrl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.segmentCtrl.selectionIndicatorHeight = 2.f;
    self.segmentCtrl.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    
    [self.scrollView addSubview:self.segmentCtrl];
    
    [self.segmentCtrl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        if (selected) {
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:@"2480ff"], NSFontAttributeName:[UIFont systemFontOfSize:15.f],NSBackgroundColorAttributeName:[UIColor colorWithHex:@"2480ff"]}];
            return attString;
        } else {
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:15.f],NSBackgroundColorAttributeName:[UIColor colorWithHex:@"2480ff"]}];
            return attString;
        }
    }];
    
    // create subview controller
    _controlers = [[NSMutableArray alloc]init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
    SellerInfoListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SellerServiceList"];
    controller.view.autoresizingMask = UIViewAutoresizingNone;
    [self addChildViewController:controller];
    [controller.view setFrame:CGRectMake(0, 250, self.view.frame.size.width, self.view.frame.size.height - 250.f)];
    [self.scrollView addSubview:controller.view];
    controller.delegate = self;
    [_controlers addObject:controller];
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"SellerCommodityList"];
    controller.view.autoresizingMask = UIViewAutoresizingNone;
    [self addChildViewController:controller];
    [controller.view setFrame:CGRectMake(0, 250, self.view.frame.size.width, self.view.frame.size.height - 250.f)];
    [self.scrollView addSubview:controller.view];
    controller.delegate = self;
    [_controlers addObject:controller];
    
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"SellerActivityList"];
    controller.view.autoresizingMask = UIViewAutoresizingNone;
    [self addChildViewController:controller];
    [controller.view setFrame:CGRectMake(0, 250, self.view.frame.size.width, self.view.frame.size.height - 250.f)];
    [self.scrollView addSubview:controller.view];
    controller.delegate = self;
    [_controlers addObject:controller];
    
   
    controller = [storyboard instantiateViewControllerWithIdentifier:@"SellerCommentList"];
    controller.view.autoresizingMask = UIViewAutoresizingNone;
    [self addChildViewController:controller];
    [controller.view setFrame:CGRectMake(0, 250, self.view.frame.size.width, self.view.frame.size.height - 250.f)];
    [self.scrollView addSubview:controller.view];
    controller.delegate = self;
    [_controlers addObject:controller];
    
    [self.segmentCtrl setSelectedSegmentIndex:0 animated:YES];
    self.navigationItem.rightBarButtonItems = [_controlers[0] getMenuItems];
    
    
    // create activity
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 80)];
    _activity.backgroundColor = [UIColor grayColor];
    _activity.alpha = 0.5;
    _activity.layer.cornerRadius = 6;
    _activity.layer.masksToBounds = YES;
    [self.scrollView addSubview:_activity];
    
    [self loadSellerDetailInfo];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)telBtnClicked:(id)sender {
    if (_detailModel.telephone != nil && ![_detailModel.telephone isEqualToString:@""]) {
        // call local telephone book
        NSString *tel = [@"tel://" stringByAppendingString:_detailModel.telephone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
    } else {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"电话号码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show:self];
        return;
    }
}

- (void)mapBtnClicked:(id)sender {
    if (_detailModel.address != nil && ![_detailModel.address isEqualToString:@""]) {
        NSString *searchQuery =[_detailModel.address stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSString* urlString =[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", searchQuery];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    } else {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"商家地址不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show:self];
        return;
    }
}

- (void)segmentedControlChangedValue:(id)sender {
    NSInteger index = self.segmentCtrl.selectedSegmentIndex;
    SellerInfoListViewController *controller = [_controlers objectAtIndex:index];
    [self updateController:index];
    for (UIViewController *ctrl in _controlers) {
        if (ctrl != controller)
            [ctrl.view setHidden:YES];
        else
            [ctrl.view setHidden:NO];
    }
    [self.view bringSubviewToFront:controller.view];
    if (_detailModel != nil) {
        SellerInfoModel *sellerInfo = [_detailModel sellerInfoModel];
        [controller setSellerModel:sellerInfo];
  //      self.navigationItem.rightBarButtonItems = [controller getMenuItems];
    }
}

- (void)updateController:(NSInteger)index {
    if (_detailModel == nil)
        return;
    SellerInfoModel *sellerInfo = [_detailModel sellerInfoModel];
    
    SellerInfoListViewController *controller = [_controlers objectAtIndex:index];
    [controller setSellerModel:sellerInfo];
#if 0
    
    if ([controller isKindOfClass:[SellerServiceListViewController class]]) {
        SellerServiceListViewController *serviceController = (SellerServiceListViewController*) controller;
        [serviceController setSellerModel: sellerInfo];
        
    } else if ([controller isKindOfClass:[SellerActivityListViewController class]]) {
        SellerActivityListViewController *serviceController = (SellerActivityListViewController*) controller;
        [serviceController setSellerModel: sellerInfo];
        
    } else if ([controller isKindOfClass:[SellerCommodityListViewController class]]) {
        SellerCommodityListViewController *serviceController = (SellerCommodityListViewController*) controller;
        [serviceController setSellerModel: sellerInfo];
        
    } else if ([controller isKindOfClass:[SellerCommentListViewController class]]) {
        SellerCommentListViewController *serviceController = (SellerCommentListViewController*) controller;
        [serviceController setSellerModel: sellerInfo];
    }
#endif
}

- (void)favoriteBtnClicked:(id)sender {
    UserModel *user = [UserModel sharedClient];
    if (!user.isLogin) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"用户登陆后可以收藏,是否登陆?" delegate:self cancelButtonTitle:@"登陆" otherButtonTitles:@"取消"];
        alert.tag = AlertReason_LoginForFavorite;
        [alert show:self];
        return;
    }
    
    FavoriteRepository *repository = [FavoriteRepository sharedClient];
    [repository addItem:[_detailModel sellerInfoModel] type:FavoriteType_Seller];
}

- (void)loadSellerDetailInfo {
    [_activity startAnimating];
    
    // call rcar service to get fault detail info
    NSDictionary *params = @{@"role":@"user", @"seller_id":self.sellerId, @"detail":@"yes"};
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    DCObjectMapping *imagesMaping = [DCObjectMapping mapKeyPath:@"images" toAttribute:@"images" onClass:[SellerInfoModel class]];
    DCArrayMapping *serviceMaping = [DCArrayMapping mapperForClassElements:[SellerServiceModel class] forAttribute:@"services" onClass:[SellerInfoModel class]];
    
    DCArrayMapping *activityMaping = [DCArrayMapping mapperForClassElements:[SellerActivityModel class] forAttribute:@"activities" onClass:[SellerInfoModel class]];
    DCArrayMapping *commodityMaping = [DCArrayMapping mapperForClassElements:[SellerCommodityModel class] forAttribute:@"commodities" onClass:[SellerInfoModel class]];
    DCArrayMapping *commentMaping = [DCArrayMapping mapperForClassElements:[SellerCommentModel class] forAttribute:@"comments" onClass:[SellerInfoModel class]];
    
    [config addArrayMapper:serviceMaping];
    [config addArrayMapper:activityMaping];
    [config addArrayMapper:commodityMaping];
    [config addArrayMapper:commentMaping];
    [config addObjectMapping:imagesMaping];
    __block SellerInfoViewController *blockViewController = self;
    [RCar GET:rcar_api_user_seller modelClass:@"SellerDetailInfoModel" config:config params:params success:^(SellerDetailInfoModel *smodel) {
        [_activity stopAnimating];
        if (smodel.api_result == APIE_OK) {
            _detailModel = smodel;
            [blockViewController refreshView];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    } failure:^(NSString *errorStr) {
        [_activity stopAnimating];
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
}


- (void)refreshView {
    // check wether the seller is in favorite
    FavoriteRepository *repository = [FavoriteRepository sharedClient];
    if ([repository isObjectExist:_detailModel.seller_id type:FavoriteType_Seller]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    RecentRepository *recent = [RecentRepository instance];
    [recent addItem:[_detailModel sellerInfoModel]];
    
    self.addressLabel.text = [NSString stringWithFormat:@"地址: %@", _detailModel.address];
    self.telephoneLabel.text = [NSString stringWithFormat:@"电话: %@", _detailModel.telephone];
    self.infoLabel.text = [NSString stringWithFormat:@"订单数: %d       |  满意度: %d", 1, 1];
    self.navigationItem.title = _detailModel.name;
    
    if (_detailModel != nil && _detailModel.images != nil)
        [self.imageView setImages:_detailModel.images];
    
    // update view controller
    NSInteger index = self.segmentCtrl.selectedSegmentIndex;
    [self updateController:index];
}
#pragma mark - MxAlertViewDelegate
- (void)alertView:(nullable MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertReason_LoginForFavorite && buttonIndex == 0) {
        LoginViewController *loginController = [LoginViewController initWithDelegate:self tag:AlertReason_LoginForFavorite];
        [self.navigationController pushViewController:loginController animated:YES];
        return;
    }
}
#pragma mark - LoginViewDelegate
- (void)onLoginSuccessed:(NSInteger)tag {
    if (tag == AlertReason_LoginForFavorite) {
        [self favoriteBtnClicked:self];
    }
}

#pragma mark - SellerInfoListDelegate
-(void)sellerInfoList:(SellerInfoListViewController *)controller menu:(NSArray *)menu {
    self.navigationItem.rightBarButtonItems = menu;
}

@end
