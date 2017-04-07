//
//  CommodityListViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerCommodityListViewController.h"
#import "DataArrayModel.h"
#import "SellerCommodityCell.h"
#import "SellerModel.h"

@interface SellerCommodityListViewController () <MxAlertViewDelegate>
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) BOOL hasMoreData;

@end

@implementation SellerCommodityListViewController {
    SellerModel *_seller;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商家商品";
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
    self.hidesBottomBarWhenPushed = YES;
    
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    _seller = [SellerModel sharedClient];
    
    self.offset = _seller.commodities.count;
    self.number = 10;
    self.hasMoreData = false;
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addCommodity:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItems = @[rightItem];
    
    if (_seller.commodities.count == 0)
        [self loadSellerCommodityList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}
- (void)addCommodity:(id)sender {
    [self performSegueWithIdentifier:@"commodity_add" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UIViewController *controller = segue.destinationViewController;
    controller.hidesBottomBarWhenPushed = YES;
    
    if ([segue.identifier isEqualToString:@"commodity_view"])
        [controller setValue:[_seller.commodities objectAtIndex:indexPath.row] forKey:@"model"];
}

- (void)loadSellerCommodityList {
    
    NSDictionary *params = @{@"role":@"seller", @"seller_id":_seller.seller_id, @"offset":[NSNumber numberWithInteger:self.offset], @"num":[NSNumber numberWithInteger:self.number]};
    // get advertisement
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[SellerCommodityModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    __block SellerCommodityListViewController *blockself = self;
    [RCar GET:rcar_api_seller_commodity_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            if (dataModel.data.count > 0 && dataModel.data.count < blockself.number) {
                [_seller.commodities addObjectsFromArray:dataModel.data];
                blockself.hasMoreData = false;
            } else if (dataModel.data.count == blockself.number) {
                [_seller.commodities addObjectsFromArray:dataModel.data];
                blockself.hasMoreData = true;
            } else {
                blockself.hasMoreData = false;
            }
            [self.tableView reloadData];
        }
    }failure:^(NSString *errorStr) {
        //[self handleLoadError:errorStr];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _seller.commodities.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SellerCommodityCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_hasMoreData) return 30.f;
    else return 0.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SellerCommodityCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SellerCommodityCell"];
    if (cell == nil)
        cell = [[SellerCommodityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SellerCommodityCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell setModel:[_seller.commodities objectAtIndex:indexPath.row]];
    NSMutableArray *buttons = [[NSMutableArray alloc]init];
    [buttons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
    [cell setRightUtilityButtons:buttons WithButtonWidth:50];
    cell.delegate = self;
    cell.path = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.hidesBottomBarWhenPushed = YES;
    [self performSegueWithIdentifier:@"commodity_view" sender:self];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *loadView = nil;
    if (self.hasMoreData) {
        loadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30.f)];
        UIButton *button = [[UIButton alloc]initWithFrame:loadView.frame];
        [button setTitle:@"点击加载更多" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.f];
        button.backgroundColor = [UIColor lightGrayColor];
        [button addTarget:self action:@selector(loadMoreCommodities:) forControlEvents:UIControlEventTouchUpInside];
        [loadView addSubview:button];
    }
    
    return loadView;
}

-(void)loadMoreCommodities:(id)sender {
    [self loadSellerCommodityList];
}


#pragma mark - SWTabelViewCellDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    if (index == 0) { // delete
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"确定要删除本件商品吗?" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.tag = cell.path.row;
        [alert show:self];
        return;
    } else { // edit
        [self performSegueWithIdentifier:@"commodity_edit" sender:self];
    }
}

#pragma mark - MxAlertViewDelegate
- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // get commodity
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SellerCommodityModel *commodity = [_seller.commodities objectAtIndex:alertView.tag];
        // call service
        __block SellerCommodityListViewController *blockself = self;
        NSDictionary *params = @{@"role":@"seller", @"seller_id":_seller.seller_id, @"commodity_id":commodity.commodity_id};
        [RCar DELETE:rcar_api_seller_commodity modelClass:@"APIResponseModel" config:nil  params:params success:^(APIResponseModel *result) {
            if (result.api_result == APIE_OK) {
                //NSIndexPath *indexPath = [blockself.tableView indexPathForSelectedRow];
                [_seller.commodities removeObject:commodity];
                [self.tableView reloadData];
            } else {
                MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"删除商品失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show:self];
                return;
            }
            
        } failure:^(NSString *errorStr) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"网络不能连接,请稍后再试" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alert show:self];
            return;
        }];
    }
}

@end
