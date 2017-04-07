//
//  SellerListViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 17/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//
#import "SellerListViewController.h"
#import "SearchResultModel.h"
#import "DataArrayModel.h"
#import "SellerInfoCell.h"
#import "SellerInfoModel.h"
#import "SellerSearchViewController.h"
#import "SellerServiceModel.h"
#import "SearchCondition.h"


#define Seller_List_Page_Size 10
#define Seller_List_Max 200
#define Finished_Label_Tag 115

#define kMenuBarHeight 30.f

@interface SellerListViewController ()<MXPullDownMenuDelegate>
@property (nonatomic, assign) BOOL hasMore;

@end


@implementation SellerListViewController {
    NSMutableArray *_sellers;
    UISearchBar *_searchBar;
    SearchCondition _curCondition;
    NSMutableArray *_selectedSellers;
}

@synthesize tableView;
@synthesize activity;
@synthesize delegate;
@synthesize type;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    
    self.navigationItem.title = @"商家一览";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    self.hasMore = false;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeTapped:)];
    
    CGFloat startX = kStatusBarHeight + kTopBarHeight;
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, startX + kMenuBarHeight, self.view.frame.size.width, self.view.frame.size.height - (startX + kMenuBarHeight)) style:UITableViewStylePlain];
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    //[self.tableView registerClass:[SellerInfoCell class] forCellReuseIdentifier:@"SellerInfoCell"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:self.tableView];
    
#if 0
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width, 44)];
    _searchBar.delegate = self;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //_searchBar.showsCancelButton = NO;
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.placeholder = @"输入商家名称";
    _searchBar.tintColor = [UIColor blueColor];
    
    self.navigationItem.titleView = _searchBar;
#endif
    
    // create menu bar
    NSArray *conditionArray = @[ @[ @"不限距离", @"5公里以内", @"10公里以内", @"20公里以内" , @"30公里以内" ], @[@"所有商家", @"4S店", @"普通修理店"], @[@"距离由近到远"/*, @"价格由低到高", @"价格由高到低"*/] ];
    
    MXPullDownMenu *menu = [[MXPullDownMenu alloc] initWithArray:conditionArray selectedColor:[UIColor blueColor]];
    [menu setFrame:CGRectMake(0, startX, self.view.frame.size.width, kMenuBarHeight)];
    menu.delegate = self;
    [self.view addSubview:menu];
    
    //[self.table setEditing:YES];
    
    _sellers = [[NSMutableArray alloc] init];
    _selectedSellers = [[NSMutableArray alloc] init];
    //_searchCondition = [[NSMutableDictionary alloc]init];
    [self initCurCondition];
    
    [self loadSellersWithCondition:[self getCurCondition] fromIndex:0];
    
 //   OverlapView *overlap = [[OverlapView alloc] initWithDelegate:self];
 //   [self.view addSubview:overlap];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)completeTapped:(id)sender {
    if (self.delegate != nil) {
        [self.delegate sellerListSelected:_selectedSellers];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    
    NSArray *sortTypeArray = @[@"distance"/*, @"priceL2H", @"priceH2L"*/];
    [condition setObject:[sortTypeArray objectAtIndex:_curCondition.sortType] forKey:@"sort_type"];
    
    return condition;
}

- (void)loadMore {
    [self loadSellersWithCondition:[self getCurCondition] fromIndex:_sellers.count];
}

- (void)loadSellersWithCondition:(NSMutableDictionary *)condition fromIndex:(NSInteger)index {
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
    
 //   [_activity startAnimating];
    // start search
    __block SellerListViewController *blockSelf = self;
    [RCar GET:rcar_api_user_seller_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        
        [blockSelf.activity stopAnimating];
        if (dataModel.api_result == APIE_OK) {
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
    [self loadSellersWithCondition:[self getCurCondition] fromIndex:_sellers.count];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sellers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"SellerInfoCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    SellerInfoModel *seller = [_sellers objectAtIndex:indexPath.row];
    //[cell setSelectableMode:YES];
    //[cell setSellerDelegate:self];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 55.f, 55.f)];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    
    if (seller.images != nil && seller.images.count > 0){
        NSString *url = [[RCar imageServer] stringByAppendingString:seller.images[0]];
        url = [url stringByAppendingString:@"?target=user&size=32x32&thumbnail=yes"];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"train"] options:SDWebImageOption];
    } else {
        [imageView setImage:[UIImage imageNamed:@"bus"]];
    }
    
    [cell.contentView addSubview:imageView];
    
    // name label
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70.f, 5, 240.f, 15.f)];
    nameLabel.font = [UIFont systemFontOfSize:15.f];
    nameLabel.text = seller.name;
    [cell.contentView addSubview:nameLabel];
    
    // intro label
    UILabel *introLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 25.f, 240.f, 15.f)];
    introLabel.font = [UIFont systemFontOfSize:13.f];
    introLabel.text = seller.intro;
    [cell.contentView addSubview:introLabel];
    
    // name label
    UILabel *addrLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 45.f, 240.f, 15.f)];
    addrLabel.font = [UIFont systemFontOfSize:13.f];
    addrLabel.text = seller.address;
    [cell.contentView addSubview:addrLabel];
    
    // type label
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, 5, 40, 20)];
    typeLabel.font = [UIFont systemFontOfSize:12.f];
    typeLabel.textColor = [UIColor blueColor];
    
    if ([seller.type isEqualToString:@"normal"]) {
        typeLabel.hidden = false;
        typeLabel.text = @"商家";
    } else {
        typeLabel.hidden = false;
        typeLabel.text = @"4S";
    }
    [cell.contentView addSubview:typeLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_selectedSellers addObject:[_sellers objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_selectedSellers removeObject:[_sellers objectAtIndex:indexPath.row]];
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
        [self loadSellersWithCondition:[self getCurCondition] fromIndex:0];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
    [_sellers removeAllObjects];
    
    [self loadSellersWithCondition:[self getCurCondition] fromIndex:0];
}


#pragma mark - SellerSelectDelegate
- (void)selectSeller:(SellerInfoModel *)model forState:(BOOL)selected {
    if (selected) {
        [_selectedSellers addObject:model];
    } else {
        [_selectedSellers removeObject:model];
    }
}

#pragma mark - OverlapViewDelegate

- (void) onTouchBegan:(CGPoint)point withEvent:(UIEvent *)event {
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    UIViewController *controller = segue.destinationViewController;
    
//    if ([controller respondsToSelector:@selector(setSelectedSellers:)]) {
//        [controller setValue:_selectedSellers forKey:@"selectedSellers"];
//    }
}

@end
