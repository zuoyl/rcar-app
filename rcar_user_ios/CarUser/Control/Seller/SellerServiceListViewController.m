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
#import "SellerServiceContactViewController.h"
#import "SizeableImageTableViewCell.h"

@interface SellerServiceListViewController ()

@end

@implementation SellerServiceListViewController  {
    NSMutableArray *_services;
    NSMutableArray *_selectedServices;
    BOOL _selectable;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商家服务";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"批量预约" style:UIBarButtonItemStylePlain target:self action:@selector(reserveBtnClicked:)];
    //[rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    _selectable = NO;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    // Do any additional setup after loading the view.
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectBtnClicked:)];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithTitle:@"预约" style:UIBarButtonItemStylePlain target:self action:@selector(reserveBtnClicked:)];
   
    if (self.delegate != nil)
        [self.delegate sellerInfoList:self menu:@[item1, item2]];
    
    _services = [[NSMutableArray alloc] init];
    _selectedServices = [[NSMutableArray alloc] init];
    if (self.model != nil)
        [self loadSellerServiceList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reserveBtnClicked:(id)sender {
    NSArray *indexPaths =[self.tableView indexPathsForSelectedRows];
    if (indexPaths.count == 0) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"提示信息" message:@"请选择要预约的服务" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    [_selectedServices removeAllObjects];
    for (NSIndexPath *indexPath in indexPaths) {
        [_selectedServices addObject:[_services objectAtIndex:indexPath.row]];
    }
    
    [self performSegueWithIdentifier:@"segue_service_reserve" sender:self];
    [self cancelSelectionBtnClicked:self];
}

- (void)cancelSelectionBtnClicked:(id)sender {
    [self.tableView setEditing:NO];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectBtnClicked:)];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithTitle:@"预约" style:UIBarButtonItemStylePlain target:self action:@selector(reserveBtnClicked:)];
    if (self.delegate != nil)
        [self.delegate sellerInfoList:self menu:@[item1, item2]];

    
}
- (void)selectBtnClicked:(id)sender {
    //_selectable = YES;
    [self.tableView setEditing:YES];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSelectionBtnClicked:)];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithTitle:@"预约" style:UIBarButtonItemStylePlain target:self action:@selector(reserveBtnClicked:)];
    if (self.delegate != nil)
        [self.delegate sellerInfoList:self menu:@[item1, item2]];
}

- (void)setSellerModel:(SellerInfoModel*) info {
    if (self.model == nil) {
        self.model = info;
        [self loadSellerServiceList];
    }
    [self.tableView reloadData];
}

- (void)loadSellerServiceList {
    
    NSDictionary *params = @{@"role":@"user", @"seller_id":self.model.seller_id};
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[SellerServiceModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    __block SellerServiceListViewController *blockself = self;
    [RCar GET:rcar_api_user_seller_service_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            NSArray *data = dataModel.data;
            [_services addObjectsFromArray:data];
            [blockself.tableView reloadData];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    }failure:^(NSString *errorStr) {
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
    
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

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.5f;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SellerServiceCell";
    CGFloat height = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
    
    SizeableImageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
        cell = [[SizeableImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier imageSize:CGSizeMake(height, height)];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    SellerServiceModel *service = [_services objectAtIndex:indexPath.row];
    if (service.images != nil && service.images.count > 0) {
        NSString *url = [[RCar imageServer] stringByAppendingString:service.images[0]];
        url = [url stringByAppendingString:@"?target=seller&thumbnail=yes&size=32x32"];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"bus"] options:SDWebImageOption];
    } else {
        [cell.imageView setImage:[UIImage imageNamed:@"train"]];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
    cell.textLabel.text = service.title;
    cell.detailTextLabel.text = service.detail;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 80, 0, 60, height)];
    label.contentMode = UIControlContentVerticalAlignmentCenter;
    //label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:15.f];
    label.textColor = [UIColor lightGrayColor];
    if (service.price > 0)
        label.text = [NSString stringWithFormat:@"¥%@", service.price];
    [cell.contentView addSubview:label];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing == NO)
        [self performSegueWithIdentifier:@"segue_service_detail" sender:self];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UIViewController *controller = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"segue_service_detail"]) {
        [controller setValue:[_services objectAtIndex:indexPath.row] forKey:@"serviceModel"];
        [controller setValue:self.model forKey:@"sellerModel"];
        [controller setValue:@(NO) forKey:@"isDisplaySellerInfo"];
        return;
    }
    if ([segue.identifier isEqualToString:@"segue_service_reserve"]) {
        [controller setValue:_selectedServices forKey:@"serviceList"];
        return;
    }
}

- (NSArray *)getMenuItems {
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectBtnClicked:)];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithTitle:@"预约" style:UIBarButtonItemStylePlain target:self action:@selector(reserveBtnClicked:)];
    
    return @[item1, item2];
}


@end
