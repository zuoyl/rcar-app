//
//  RecordListViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 2/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "RecordListViewController.h"
#import "RecordItemCell.h"
#import "RecordSearchSetViewController.h"
#import "DCArrayMapping.h"
#import "DataArrayModel.h"
#import "SellerModel.h"

@interface RecordListViewController () <RecordSearchSetViewDelegate>
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) BOOL hasMoreData;


@end

@implementation RecordListViewController {
    NSMutableArray *_records;
}
@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"维修记录";
    self.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // initialize tableview
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    
    [self.tableView registerClass:[RecordItemCell class] forCellReuseIdentifier:@"RecordItemCell"];
    // Do any additional setup after loading the view.
    _records = [[NSMutableArray alloc]init];
    self.offset = 0;
    self.number = 10;
    self.hasMoreData = false;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"检索" style:UIBarButtonItemStylePlain target:self action:@selector(searchConditionSet:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    [self loadRecordList:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)searchConditionSet:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    [self performSegueWithIdentifier:@"record_search" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath != nil) {
        RecordModel *record = [_records objectAtIndex:indexPath.row];
        
        UIViewController *controller = segue.destinationViewController;
        if ([controller respondsToSelector:@selector(setModel:)])
            [controller setValue:record  forKey:@"model"];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _records.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"RecordItemCell";
    RecordItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[RecordItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setModel:_records[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordModel *record = [_records objectAtIndex:indexPath.row];
    if (!record.record_id || [record.record_id isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"不能取得记录详细信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    [self performSegueWithIdentifier:@"record_view" sender:self];
}

#pragma mark - RecordSearchSetViewDelegate
- (void)recordSearchSetCompleted:(NSDictionary *)result {
    [self loadRecordList:result];
}

- (void)loadRecordList:(NSDictionary *)condition {
    SellerModel *seller = [SellerModel sharedClient];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"role":@"seller", @"seller_id":seller.seller_id, @"offset":[NSNumber numberWithLong:self.offset], @"num":[NSNumber numberWithLong:self.number]}];
    if (condition != nil)
        [params setObject:condition forKey:@"condition"];
    
    // get advertisement
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[RecordModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    __block RecordListViewController *blockself = self;
    [RCar GET:rcar_api_seller_order_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            NSArray *data = dataModel.data;
            if (data.count == blockself.number) { // load more data
                [_records addObjectsFromArray:data];
                [self.tableView reloadData];
                blockself.offset += blockself.number;
                blockself.hasMoreData = true;
            } else if (data.count > 0 && data.count < blockself.number) { // no more data
                [_records addObjectsFromArray:data];
                [self.tableView reloadData];
                blockself.offset += data.count;
                blockself.hasMoreData = false;
            }
            else { // no data
                blockself.hasMoreData = false;
                MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有交易记录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show:self];
            }
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
        }
    }failure:^(NSString *errorStr) {
        [self handleLoadError:errorStr];
    }];
}

- (void)handleLoadError:(NSString *)error {
    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力,请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5f;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.hasMoreData)
        return 30.f;
    else
        return 0.5f;
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
        [button addTarget:self action:@selector(loadMoreRecords:) forControlEvents:UIControlEventTouchUpInside];
        [loadView addSubview:button];
    }
    
    return loadView;
}

-(void)loadMoreRecords:(id)sender {
    [self loadRecordList:nil];
}

@end
