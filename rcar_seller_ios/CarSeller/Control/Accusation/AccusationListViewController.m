//
//  AccusationListViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 1/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "AccusationListViewController.h"
#import "SellerModel.h"
#import "DataArrayModel.h"
#import "DCArrayMapping.h"
#import "AccusationViewController.h"
#import "AccusationCell.h"


@interface AccusationListViewController () <MxAlertViewDelegate>

@end

@implementation AccusationListViewController {
    NSMutableArray *_accusations;
    SellerModel *_seller;
    UIActivityIndicatorView *_activity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"投诉列表";
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    _seller = [SellerModel sharedClient];
    _accusations = _seller.accusations;
    [_accusations removeAllObjects];
    
    // display activity indicator
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    _activity.backgroundColor = [UIColor grayColor];
    _activity.alpha = 0.5;
    _activity.layer.cornerRadius = 6;
    _activity.layer.masksToBounds = YES;
    [self.view addSubview:_activity];
    
    [self loadAccusationList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadAccusationList {
    
    [_activity startAnimating];
    
    NSDictionary *params = @{@"role":@"seller", @"seller_id":_seller.seller_id, @"num":[NSNumber numberWithInt:10], @"offset":[NSNumber numberWithInteger:_accusations.count]};
    
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[AccusationModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    __block AccusationListViewController *blockself = self;
    
    [RCar GET:rcar_api_seller_accusation_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            [_activity stopAnimating];
            NSArray *data = dataModel.data;
            if (data.count > 0) {
                [_accusations addObjectsFromArray:data];
                [blockself.tableView reloadData];
            } else {
                MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有关于本商家的客户投诉" delegate:blockself cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = 1000;
                [alert show:self];
            }
        } else {
            [blockself handleLoadError:nil];
        }
    }failure:^(NSString *errorStr) {
        [_activity stopAnimating];
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不能连接,请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
    }];
}

- (void)handleLoadError:(NSString *)error {
    [_activity stopAnimating];
    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show:self];
    
}
- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000)
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _accusations.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"AccusationCell";
    AccusationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
        cell = [[AccusationCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AccusationModel *model = [_accusations objectAtIndex:indexPath.row];
    [cell setModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"accusation_show" sender:self];
#if 0
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Accusation" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AccusationViewController"];
    
    AccusationModel *accusation = [_accusations objectAtIndex:indexPath.row];
    controller.hidesBottomBarWhenPushed = YES;
    if ([controller respondsToSelector:@selector(setModel:)])
        [controller setValue:accusation  forKey:@"model"];
    
    [self.navigationController pushViewController:controller animated:YES];
#endif
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    AccusationModel *accusation = [_accusations objectAtIndex:indexPath.row];
    UIViewController *controller = segue.destinationViewController;
    controller.hidesBottomBarWhenPushed = YES;
    if ([controller respondsToSelector:@selector(setModel:)])
        [controller setValue:accusation  forKey:@"model"];
}

@end
