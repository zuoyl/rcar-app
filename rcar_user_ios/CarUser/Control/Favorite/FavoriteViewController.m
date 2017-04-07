//
//  FavoriteViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 10/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "FavoriteViewController.h"
#import "FavoriteModel.h"
#import "FavoriteCommodityViewController.h"
#import "FavoriteSellerViewController.h"
#import "FavoriteRepository.h"

@interface FavoriteViewController ()

@end

@implementation FavoriteViewController {
    UIActivityIndicatorView *_activity;
    FavoriteRepository *_repository;
}
@synthesize segmentCtrl;

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    self.hidesBottomBarWhenPushed = YES;

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"同步" style:UIBarButtonItemStylePlain target:self action:@selector(sychonizeFavorite:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;

    self.segmentCtrl = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    [self.segmentCtrl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    segmentCtrl.tintColor = [UIColor whiteColor];
    [self.segmentCtrl insertSegmentWithTitle:@"商家" atIndex:0 animated:false];
    [self.segmentCtrl insertSegmentWithTitle:@"商品" atIndex:1 animated:false];
    [self.segmentCtrl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];

    [self.segmentCtrl setSelectedSegmentIndex:0];
    self.navigationItem.titleView = self.segmentCtrl;
    
    [self loadSubviews];
    
    _activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activity startAnimating];
    _repository = [FavoriteRepository sharedClient];
    if (!_repository.isLoaded && _repository.sellers.count == 0)
        [_repository loadFavoriteFromNetwork:nil failure:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
#if 0
    UserModel *user = [UserModel sharedClient];
    if ([_repository isModified] == true && [user isLogin] == true) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"用户收藏夹已经修改，是否进行同步" delegate:self cancelButtonTitle:@"了解了" otherButtonTitles:@"同步", nil];
        [alert show:self];
    }
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - MxAlertViewDelegate
- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self sychonizeFavorite:self];
    }
    
}

- (void)segmentAction:(UISegmentedControl *)segment {
    NSInteger index = segment.selectedSegmentIndex;
    if (index == 0) {
        [self.seller.view setHidden:NO];
        [self.view bringSubviewToFront:self.seller.view];
        [self.commodity.view setHidden:YES];
    } else {
        [self.commodity.view setHidden:NO];
        [self.view bringSubviewToFront:self.commodity.view];
        [self.seller.view setHidden:YES];
    }
}

- (void)loadSubviews {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Favorite" bundle:nil];
   
    self.seller = [storyboard instantiateViewControllerWithIdentifier:@"FavoriteSeller"];
    [self addChildViewController:self.seller];
    [self.view addSubview:self.seller.view];
    
    self.commodity = [storyboard instantiateViewControllerWithIdentifier:@"FavoriteCommodity"];
    [self addChildViewController:self.commodity];
    [self.view addSubview:self.commodity.view];
    
    [self.seller.view setHidden:NO];
    [self.commodity.view setHidden:YES];
    
 //   [self.view bringSubviewToFront:self.placeholder];
}

- (void)refreshSubview {
    [self.seller reloadData:self];
    [self.commodity reloadData:self];
}

-(void)onLoginSuccessed :(NSInteger)tag{
    self.hidesBottomBarWhenPushed = NO;
    [self sychonizeFavorite:self];
}

-(void)onLoginFailed:(NSInteger)tag {
    self.hidesBottomBarWhenPushed = NO;
    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"用户登陆失败" message:@"用户登陆后能够访问收藏夹" delegate:self cancelButtonTitle:@"重新登录" otherButtonTitles:@"了解了", nil];
    [alert show:self];
    return;
    
}

- (void)sychonizeFavorite:(id)sender {
    // check network reachability
    if (![Reachability isEnableNetwork]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"网络无法连接" message:@"不能取得收藏夹信息，请检查网络" delegate:nil cancelButtonTitle:@"了解" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    // check wether user had logined in
    UserModel *user = [UserModel sharedClient];
    if ([user isLogin] == NO) {
        self.hidesBottomBarWhenPushed = YES;
        LoginViewController *controller = [LoginViewController initWithDelegate:self tag:0];
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    [_activity startAnimating];
    __block FavoriteViewController *blockself = self;
    [_repository sychonizeFavorite:^(id result) {
        [blockself refreshSubview];
        [_activity stopAnimating];
    } failure:^(NSString *errorStr) {
        [_activity stopAnimating];
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"网络无法连接" message:@"不能取得收藏夹信息，请检查网络" delegate:nil cancelButtonTitle:@"了解" otherButtonTitles:nil, nil];
        [alert show:self];
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
