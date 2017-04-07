//
//  FaultHistoryViewController.m
//  CarUser
//
//  Created by jenson.zuo on 25/11/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "FaultHistoryViewController.h"
#import "FaultHistoryModel.h"
#import "UserModel.h"
#import "DataArrayModel.h"
#import "FaultDetailRecordViewController.h"

@interface FaultHistoryViewController ()

@end

@implementation FaultHistoryViewController

@synthesize faultHistory;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"故障历史记录";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.faultHistory = [[NSMutableArray alloc]init];
   
    // get fault history from rcar
    UserModel *user = [UserModel sharedClient];
    
    NSDictionary *params = @{@"role":@"user", @"name":user.user_id};
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[FaultHistoryModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
#if 0
    __block FaultHistoryViewController *blockSelf = self;
    [RCar callService:rcar_api_user_get_fault_history modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            NSArray *data = dataModel.data;
            for (int i = 0; i < data.count; i++) {
                [blockSelf.faultHistory addObject:[data objectAtIndex:i]];
            }
            [blockSelf.tableView reloadData];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
        
    }failure:^(NSString *errorStr) {
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
#endif
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    FaultHistoryModel *model = [self.faultHistory objectAtIndex:indexPath.row];
    UIViewController *controller = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"fault_detail_record"]) {
        [controller setValue:model.order_id forKey:@"order_id"];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.faultHistory.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FaultItemTableViewCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    FaultHistoryModel *model = [self.faultHistory objectAtIndex:indexPath.row];
    cell.textLabel.text = model.date;
    cell.detailTextLabel.text = model.title;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width - 70, 5, 50, 20)];
    label.font = [UIFont systemFontOfSize:17.f];
    switch (model.status.integerValue) {
        case FaultStatusNew:
            label.text = @"新故障";
            break;
        case FaultStatusProcessing:
            label.text = @"处理中";
            break;
        case FaultStatusFinished:
            label.text = @"处理完了";
            break;
        default:
            label.text = @"未知状态";
            break;
    }
    [cell.contentView addSubview:label];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"fault_detail_record" sender:self];
}

@end
