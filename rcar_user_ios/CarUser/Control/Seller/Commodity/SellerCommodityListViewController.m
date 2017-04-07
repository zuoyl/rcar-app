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

@interface SellerCommodityListViewController ()

@end

@implementation SellerCommodityListViewController {
    NSMutableArray *_commodities;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商家商品一览";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _commodities = [[NSMutableArray alloc] init];
    if (self.model != nil)
        [self loadSellerCommodityList];
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
    UIViewController *controller = segue.destinationViewController;
    
    if ([controller respondsToSelector:@selector(setModel:)])
        [controller setValue:[_commodities objectAtIndex:indexPath.row] forKey:@"model"];
}

- (void)setSellerModel:(SellerInfoModel*) info {
    if (self.model == nil) {
        self.model = info;
        [self loadSellerCommodityList];
    }
}

- (void)loadSellerCommodityList {
    
    NSDictionary *params = @{@"role":@"user", @"seller_id":self.model.seller_id};
    // get advertisement
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[SellerCommodityModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    [RCar GET:rcar_api_user_seller_commodity_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            NSArray *data = dataModel.data;
            [_commodities addObjectsFromArray:data];
            [self.tableView reloadData];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    }failure:^(NSString *errorStr) {
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
        //[self handleLoadError:errorStr];
    }];
    
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
   // NSString *title = [NSString stringWithFormat:@"该商家共有商品%lu件", _commodities.count];
   // return title;
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _commodities.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"CommodityCell";
    SellerCommodityModel *commodity =  [_commodities objectAtIndex:indexPath.row];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIImageView  *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5,  60, 60 )];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, cell.frame.size.width - 100, 20)];
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(60 ,25, cell.frame.size.width - 50, 20)];
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 45, cell.frame.size.width - 50, 20)];
    
    // set font
    nameLabel.font = [UIFont systemFontOfSize:15];
    descLabel.font = [UIFont systemFontOfSize:12];
    infoLabel.font = [UIFont systemFontOfSize:12];
    
    nameLabel.text = commodity.name;
    descLabel.text = commodity.desc;
    
    // Configure the cell...
    if (commodity.images == nil || commodity.images.count == 0) {
        [imageView setImage:[UIImage imageNamed:@"train"]];
    }
    NSString *price;
    NSString *cutoff;
    NSString *rate;
    // price
    if (commodity.price != nil) {
         price = [@"价格:¥" stringByAppendingString:commodity.price];
    } else {
        price = @"价格:不详";
    }
    // cutoff
    if (commodity.cutoff != nil) {
        cutoff = [@"优惠:" stringByAppendingString:commodity.cutoff];
    } else {
        cutoff = @"优惠:无";
    }
    // rate
    if (commodity.rate != nil) {
        rate = [@"评价:" stringByAppendingString:commodity.rate];
    } else {
        rate = @"评级:无";
    }
    infoLabel.text = [[[price stringByAppendingString:@"  "] stringByAppendingString:cutoff] stringByAppendingString:@"  "];
    infoLabel.text = [infoLabel.text stringByAppendingString:rate];
    infoLabel.textColor = [UIColor lightGrayColor];
    
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:descLabel];
    [cell.contentView addSubview:infoLabel];
    [cell.contentView addSubview:imageView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"show_seller_commodity_detail" sender:self];
}

@end

