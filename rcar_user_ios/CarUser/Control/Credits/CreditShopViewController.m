//
//  CreditShopViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 10/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "CreditShopViewController.h"
#import "CreditExchangeItemModel.h"
#import "CreditExchangeItemCell.h"
#import "DataArrayModel.h"

@interface CreditShopViewController ()

@end

@implementation CreditShopViewController {
    NSMutableArray *_items;
}
@synthesize  creditLabel;
@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = @"我的积分";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _items = [[NSMutableArray alloc]init];
    UINib *nib = [UINib nibWithNibName:@"CreditExchangeItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CreditExchangeItemCell"];
    [self loadCreditList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadCreditList {
    // check network reachability
    if (![Reachability isEnableNetwork]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"网络无法连接" message:@"不能取得收藏夹信息，请检查网络" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    // if user is not logined in
    UserModel *userModel = [UserModel sharedClient];
    if ([userModel isLogin] == NO) {
        LoginViewController *controller = [LoginViewController initWithDelegate:self tag:0];
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    NSDictionary *params = @{@"role":@"user", @"name":userModel.user_id};
    // get advertisement
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[CreditExchangeItemModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    __block CreditShopViewController *__controller = self;
    [RCar GET:rcar_api_user_credit_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            NSArray *data = dataModel.data;
            for (int i = 0; i < data.count; i++) {
                [_items addObject:[data objectAtIndex:i]];
            }
            [__controller.tableView reloadData];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    }failure:^(NSString *errorStr) {
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
        //[self handleLoadError:errorStr];
    }];
}

- (IBAction)creditDetailBtnTaped:(id)sender {
    if (_items.count > 0) {
        [self performSegueWithIdentifier:@"credit_show_detail" sender:self] ;
    } else {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"信息提示" message:@"你没有历史积分" delegate:nil cancelButtonTitle:@"了解" otherButtonTitles:nil, nil];
        [alert show:self];
    }
}

- (IBAction)credtiGetBtnTaped:(id)sender {
    [self performSegueWithIdentifier:@"credit_show_help" sender:self] ;
}

-(void)onLoginSuccessed :(NSInteger)tag{
    [self loadCreditList];
}
-(void)onLoginFailed :(NSInteger)tag{
    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"用户登陆失败" message:@"用户登陆后能够访问收藏夹" delegate:nil cancelButtonTitle:@"了解" otherButtonTitles:nil, nil];
    [alert show:self];
    return;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreditExchangeItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CreditExchangeItemCell" forIndexPath:indexPath];
    
    // Configure the cell...
    [cell setModel:[_items objectAtIndex:indexPath.row]];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Credit" bundle:nil];
    UIViewController *contrller = [storyboard instantiateViewControllerWithIdentifier:@"CreditDetailViewController"];
    [self.navigationController pushViewController:contrller animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    UIViewController *controller = segue.destinationViewController;
    if ([controller respondsToSelector:@selector(setModel:)]) {
        [controller setValue:[_items objectAtIndex:path.row] forKey:@"model"];
    }
}

@end
