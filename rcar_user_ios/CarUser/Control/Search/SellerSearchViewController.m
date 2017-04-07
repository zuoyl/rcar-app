//
//  SellerSearchViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 25/11/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerSearchViewController.h"
#import "SearchResultModel.h"
#import "DataArrayModel.h"
#import "SellerInfoCell.h"
#import "SellerInfoModel.h"
#import "SellerSearchViewController.h"
#import "SellerServiceModel.h"
#import "SearchCondition.h"
#import "OverlapView.h"




#define Seller_List_Page_Size 10
#define Seller_List_Max 200
#define Finished_Label_Tag 115

#define kMenuBarHeight 30.f

@interface SellerSearchViewController ()<MXPullDownMenuDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) BOOL hasMore;

@end

@implementation SellerSearchViewController {
    NSMutableArray *_sellers;
    UISearchBar *_searchBar;
    NSMutableDictionary *_conditions;
    NSMutableArray *_conditionValus;
}

@synthesize tableView;
@synthesize activity;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    
    self.navigationItem.title = @"商家一览";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    self.hasMore = false;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonItemStylePlain target:self action:@selector(completeTapped:)];
    
    CGFloat startX = kStatusBarHeight + kTopBarHeight;
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, startX + kMenuBarHeight, self.view.frame.size.width, self.view.frame.size.height - (startX + kMenuBarHeight)) style:UITableViewStyleGrouped];
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[SellerInfoCell class] forCellReuseIdentifier:@"SellerInfoCell"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:self.tableView];
    
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width, 44)];
    _searchBar.delegate = self;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.showsCancelButton = NO;
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.placeholder = @"输入商家名称";
    _searchBar.tintColor = [UIColor blueColor];
    
    self.navigationItem.titleView = _searchBar;
    
    NSArray *conditionArray = @[ @[ @"不限距离", @"5公里以内", @"10公里以内", @"20公里以内" , @"30公里以内" ], @[@"所有商家", @"4S店", @"普通修理店"], @[ @"价格由低到高", @"价格由高到低"] ];
   
    _conditionValus = [[NSMutableArray alloc]initWithArray:@[ @[@"0", @"5", @"10", @"20", @"30"], @[@"all", @"4s", @"normal"], @[@"priceL2H", @"priceH2L"] ]];
    _conditions = [[NSMutableDictionary alloc]init];
    [_conditions setValue:_conditionValus[0][0] forKey:@"distance"];
    [_conditions setValue:_conditionValus[1][0] forKey:@"seller_type"];
    [_conditions setValue:_conditionValus[2][0] forKey:@"sort_type"];
    
    MXPullDownMenu *menu = [[MXPullDownMenu alloc] initWithArray:conditionArray selectedColor:[UIColor blueColor]];
    [menu setFrame:CGRectMake(0, startX, self.view.frame.size.width, kMenuBarHeight)];
    menu.delegate = self;
    [self.view addSubview:menu];
    
    _sellers = [[NSMutableArray alloc] init];
    
    
    
   // [self loadSellersWithCondition:[self getCurCondition] fromIndex:0];
    
   // OverlapView *overlap = [[OverlapView alloc] initWithDelegate:self];
   // [self.view addSubview:overlap];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)completeTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadMore {
    [self loadSellersWithCondition:_conditions];
}

- (void)loadSellersWithCondition:(NSMutableDictionary *)condition {
    UserModel *userModel = [UserModel sharedClient];
    
    NSDictionary *params = @{@"role":@"user",
                             @"offset":[NSNumber numberWithInteger:_sellers.count],
                             @"number":[NSNumber numberWithInteger:Seller_List_Page_Size],
                             @"city":userModel.selectedCity,
                             @"lat":[NSNumber numberWithDouble:userModel.location.coordinate.latitude ],
                             @"lng":[NSNumber numberWithDouble:userModel.location.coordinate.longitude ],
                             @"condition":condition};
    
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[SellerInfoModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    [activity startAnimating];
    // start search
    __block SellerSearchViewController *blockSelf = self;
    [RCar GET:rcar_api_user_seller_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        
        [activity stopAnimating];
        if (dataModel.api_result == APIE_OK) {
            if (dataModel.data.count == 0 || dataModel.data.count < Seller_List_Page_Size )
                blockSelf.hasMore = false;
            else
                blockSelf.hasMore = true;
            
            if(dataModel.data.count > 0){
                [_sellers addObjectsFromArray:dataModel.data];
                [blockSelf.tableView reloadData];
            }
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
        }
        
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力,请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        
    }];
}

- (void)loadMoreBtnClicked:(id)sender {
    [self loadSellersWithCondition:_conditions];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sellers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *loadView = nil;
    if (self.hasMore) {
        loadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30.f)];
        UIButton *button = [[UIButton alloc]initWithFrame:loadView.frame];
        [button setTitle:@"点击加载更多" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.f];
        button.backgroundColor = [UIColor colorWithHex:@"2480ff"];
        [button addTarget:self action:@selector(loadMoreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [loadView addSubview:button];
    }
    
    return loadView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"SellerInfoCell";
    SellerInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil)
        cell = [[SellerInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SellerInfoModel *info = [_sellers objectAtIndex:indexPath.row];
    [cell setModel:info];
    //[cell setSelectableMode:YES];
    //[cell setSellerDelegate:self];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark - MXPullDownMenuDelegate
- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column
                 row:(NSInteger)row {
    NSArray *keywords = @[@"distance", @"seller_type", @"sort_type"];
    [_conditions setValue:_conditionValus[column][row] forKey:keywords[column]];
    [_sellers removeAllObjects];
    [self loadSellersWithCondition:_conditions];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (![searchBar.text isEqualToString:@""]) {
        [_sellers removeAllObjects];
       // [_conditions setValue:searchBar.text forKey:@"keyword"];
        [self loadSellersWithCondition:_conditions];
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
