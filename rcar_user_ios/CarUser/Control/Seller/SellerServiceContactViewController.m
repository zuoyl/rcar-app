//
//  SellerServiceContactViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 9/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerServiceContactViewController.h"

@interface SellerServiceContactViewController ()

@end

@implementation SellerServiceContactViewController {
    NSString *_serviceDate;
    NSString *_sellerName;
    NSString *_book_id;
    UIActivityIndicatorView *_activity;
}
@synthesize sellerid;
@synthesize publicateModel;
@synthesize model;
@synthesize cancelBtn;
@synthesize laterBtn;
@synthesize contactBtn;
@synthesize placeholder;
@synthesize timeLabel;
@synthesize tableView;
@synthesize timeBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"预约等待中";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    
    [self.laterBtn setHidden:YES];
    [self.cancelBtn setHidden:YES];
    [self.tableView setHidden:YES];
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height)];
    _activity.backgroundColor = [UIColor grayColor];
    _activity.alpha = 0.5;
    _activity.layer.cornerRadius = 6;
    _activity.layer.masksToBounds = YES;
    [self.view addSubview:_activity];
    
    [_activity startAnimating];
    [self reserveSellerService];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) reserveSellerService {
    UserModel *user = [UserModel sharedClient];
    ServiceContactModel *detail = self.model;
    NSLog(@"%@", detail.name);
    NSDictionary *info = @{@"role":@"user",
                             @"user_id":user.user_id,
                             @"seller_id":self.model.service.seller_id,
                             @"service_id":self.model.service.service_id,
                             @"time":self.model.time,
                             @"title":self.model.service.title};
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:info];
    if (self.model.items.count > 0)
        [params setObject:self.model.items forKey:@"desc"];
   
    [RCar POST:rcar_api_user_seller_service modelClass:nil config:nil params:params success:^(NSDictionary *data) {
        [_activity stopAnimating];
        NSString *result = [data objectForKey:@"api_result"];
        if (result.intValue == APIE_OK) {
            _book_id = [data objectForKey:@"book_id"];
            if (_book_id != nil) {
                MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"已从系统取得预约ID,请等待商家联络" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
                [alert show:self];
            }
            [self refreshView];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    
    }failure:^(NSString *errorStr) {
        //[self handleLoadError:errorStr];
        [_activity stopAnimating];
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
}

- (void)cancelSellerService {
#if 0
    UserModel *user = [UserModel sharedClient];
    ServiceContactModel *detail = self.model;
    NSLog(@"%@", detail.name);
    NSDictionary *params = @{@"role":@"user",
                           @"user_id":user.user_id,
                           @"book_id":_book_id,
                           @"status":@"cancel"};
   
    [RCar callService:rcar_api_user_set_service_book_status modelClass:nil config:nil params:params success:^(NSDictionary *data) {
       // do nothing now
    }failure:^(NSString *errorStr) {
       // do nothing now
    }];
#endif
    
}

- (void)refreshView {
    [self.laterBtn setHidden:NO];
    [self.cancelBtn setHidden:NO];
    [self.tableView setHidden:YES];
    [self.tableView reloadData];
}

- (IBAction)cancelBtnTaped:(id)sender {
    [_activity stopAnimating];
    [self cancelSellerService];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)laterBtnTaped:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [_activity stopAnimating];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SellerServiceContactCell" forIndexPath:indexPath];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SellerServiceContactCell"];
    
    // Configure the cell...
    if (indexPath.row == 0) {
        cell.textLabel.text = @"商家: ";
        cell.textLabel.text = [cell.textLabel.text stringByAppendingString:_sellerName];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"服务: ";
        cell.textLabel.text = [cell.textLabel.text stringByAppendingString:self.model.service.title];
    } else {
        cell.textLabel.text = @"时间: ";
        cell.textLabel.text = [cell.textLabel.text stringByAppendingString:_serviceDate];
    }
    
    return cell;
}

@end
