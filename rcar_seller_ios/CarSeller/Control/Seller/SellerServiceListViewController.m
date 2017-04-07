//
//  SellerServiceListViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 8/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerServiceListViewController.h"
#import "SellerServiceModel.h"
#import "DataArrayModel.h"
#import "SellerServiceCell.h"
#import "SellerModel.h"
#import "SellerServiceViewController.h"

@interface SellerServiceListViewController ()<MxAlertViewDelegate>

@end

@implementation SellerServiceListViewController  {
    NSMutableArray *_services;
    SellerModel *_seller;
    NSIndexPath *_indexPath;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商家服务";
    self.hidesBottomBarWhenPushed = YES;
    
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
    
    // Do any additional setup after loading the view.
    [self.tableView registerClass:[SellerServiceCell class] forCellReuseIdentifier:@"SellerServiceCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    _seller = [SellerModel sharedClient];
    _services = _seller.services;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addService:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)addService:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    [self performSegueWithIdentifier:@"service_add" sender:self];
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"service_view"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UIViewController *controller = segue.destinationViewController;
        
        [controller setValue:[_services objectAtIndex:indexPath.row] forKey:@"model"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _services.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SellerServiceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SellerServiceCell" forIndexPath:indexPath];
    [cell setModel:[_services objectAtIndex:indexPath.row]];
    NSMutableArray *buttons = [[NSMutableArray alloc]init];
    [buttons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
    [cell setRightUtilityButtons:buttons WithButtonWidth:50];
    cell.delegate = self;
    cell.path = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   //SellerServiceModel *serviceModel = [_services objectAtIndex:indexPath.row];
   [self performSegueWithIdentifier:@"service_view" sender:self];
}

#pragma mark - SWTabelViewCellDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    _indexPath = cell.path;
    if (index == 0) { // delete
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"您确定要删除此项服务吗" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"取消", nil];
        [alert show:self];
    }
}

- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // delete
        SellerModel *seller = [SellerModel sharedClient];
        SellerServiceModel *service = [_services objectAtIndex:_indexPath.row];
        __block SellerServiceListViewController *blockself = self;
        NSDictionary *params = @{@"role":@"seller", @"seller_id":seller.seller_id, @"service_id":service.service_id};
        [RCar DELETE:rcar_api_seller_service modelClass:@"APIResponseModel" config:nil params:params success:^(APIResponseModel *result) {
            if (result.api_result == APIE_OK) {
                // delete service from local seller info
                SellerModel *seller = [SellerModel sharedClient];
                [seller.services removeObject:[_services objectAtIndex:_indexPath.row]];
                [blockself.tableView reloadData];
            }
        } failure:^(NSString *errorStr) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }];
        
    } else {
        // do nothing now
    }
    
}

@end
