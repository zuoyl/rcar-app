//
//  MaintenancePublicateSellerSelectViewController.m
//  CarUser
//
//  Created by huozj on 3/12/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "MTPublicateStep2ViewController.h"
#import "OrderWaitingViewController.h"
#import "OrderModel.h"


typedef enum {
    SECTION_DISTANCE,
    SECTION_SELLER_TYPE,
    SECTION_SEARCHE_SELLER,
    SECTION_OK
}SectionType;

@interface MTPublicateStep2ViewController () <SellerListSelectDelegate, BGRadioViewDelegate>
@property (nonatomic, strong) BGRadioView *radioDistance;
@property (nonatomic, strong) BGRadioView *radioSellerType;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) NSString *selectedSellers;
@end


@implementation MTPublicateStep2ViewController {
    CLLocation *_location;
    CLLocationManager *_locationMgr;
}
@synthesize model;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"预约保养(2/2)";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    // clear noused rows
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self.model.condtions setValue:@"10" forKey:@"radius"];
    [self.model.condtions setValue:@"normal" forKey:@"type"];
    
    __block MTPublicateStep2ViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"按距离远近";
        section.sectionHeaderHight = 40;
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell1";
            staticContentCell.cellHeight = 150.f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (blockself.radioDistance == nil) {
                blockself.radioDistance = [[BGRadioView alloc]initWithFrame:CGRectMake(0, 0, blockself.view.frame.size.width, 150.f)];
                blockself.radioDistance.rowItems =  [[NSMutableArray alloc]initWithArray:@[ @"不限距离", @"5公里以内", @"10公里以内", @"20公里以内", @"30公里以内" ]];
                blockself.radioDistance.maxRow = (int)blockself.radioDistance.rowItems.count;
                blockself.radioDistance.editable = YES;
                blockself.radioDistance.delegate = blockself;
                blockself.radioDistance.tag = SECTION_DISTANCE;
                blockself.radioDistance.optionNo = 2;
            }
            [cell.contentView addSubview:blockself.radioDistance];
            [cell.contentView bringSubviewToFront:blockself.radioDistance];
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"按商家类型";
        section.sectionHeaderHight = 30;
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell2";
            staticContentCell.cellHeight = 90.f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (blockself.radioSellerType == nil) {
                blockself.radioSellerType = [[BGRadioView alloc]initWithFrame:CGRectMake(0, 0, blockself.view.frame.size.width, 90.f)];
                blockself.radioSellerType.rowItems = [[NSMutableArray alloc]initWithArray:@[@"所有商家", @"4S店", @"普通修理店"]];
                blockself.radioSellerType.optionNo = 2;
                blockself.radioSellerType.tag = SECTION_SELLER_TYPE;
                blockself.radioSellerType.delegate = blockself;
                blockself.radioSellerType.maxRow = (int)blockself.radioSellerType.rowItems.count;
                blockself.radioSellerType.editable = YES;
            }
            [cell.contentView addSubview:blockself.radioSellerType];
            [cell.contentView bringSubviewToFront:blockself.radioSellerType];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell3";
            staticContentCell.cellHeight = 40.f;
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"搜索指定商家";
            cell.detailTextLabel.text = blockself.selectedSellers;
        } whenSelected:^(NSIndexPath *indexPath) {
#if 0
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Maintenance" bundle:nil];
            SellerListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SellerListViewController"];
            controller.delegate = blockself;
            [blockself.navigationController pushViewController:controller animated:YES];
#endif 
            [blockself performSegueWithIdentifier:@"maintenance_show_seller_list" sender:blockself];
            
        }];
        
        section.sectionFooterHeight = 44.f;
        section.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, blockself.tableView.frame.size.width, 44.f)];
        blockself.submitBtn = [[UIButton alloc]initWithFrame:section.footerView.frame];
        [blockself.submitBtn addTarget:blockself action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [blockself.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [blockself.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        blockself.submitBtn.backgroundColor = [UIColor colorWithHex:@"2480ff"];
        
        blockself.submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [section.footerView addSubview:blockself.submitBtn];
    }];

    
    [self initLocationManager];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initLocationManager {
    // get location
    if ([CLLocationManager locationServicesEnabled]) {
        _locationMgr = [[CLLocationManager alloc] init];
        [_locationMgr setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationMgr.delegate = self;
        _locationMgr.distanceFilter = 1000.0f;
        [_locationMgr startUpdatingLocation];
        //[self.activity startAnimating];
    } else {
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:@"警告" message:@"位置服务不可用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设定", nil];
        [alert show:self];
    }
    
#if 1 // for simulation test
    CLLocation *location = [[CLLocation alloc]initWithLatitude:39.983424 longitude:116.322987];
    [self locationManager:_locationMgr didUpdateLocations:[NSArray arrayWithObject:location]];
#endif
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //[self.activity stopAnimating];
    _location = [locations lastObject];
    [_locationMgr stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    MxAlertView *alert = [[MxAlertView alloc] initWithTitle:@"警告" message:@"位置服务不可用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设定", nil];
    [alert show:self];
    return;
}



#pragma mark UITableViewDelegate
#if 0
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SECTION_SELLER_TYPE && indexPath.row == 1) {
        [self performSegueWithIdentifier:@"maintenance_show_seller_list" sender:self];
    } else if (indexPath.section == SECTION_OK) {
        [self publicateMaintenance];
    }
}
#endif

#pragma mark Radio List Delegate
-(void)radioView:(BGRadioView *)radioView didSelectOption:(int)optionNo fortag:(int)tagNo {
    NSArray *distance = @[@"0", @"5", @"10", @"20", @"30"];
    NSArray *sellerType = @[@"all", @"4s", @"normal"];
    
    if (tagNo == SECTION_DISTANCE) {
        [self.model.condtions setValue:[distance objectAtIndex:optionNo] forKey:@"radius"];
    } else if (tagNo == SECTION_SELLER_TYPE) {
        [self.model.condtions setValue:[sellerType objectAtIndex:optionNo] forKey:@"type"];
    } else {
    }
    
}

#pragma mark - SellerListSelectDelegate
- (void)sellerListSelected:(NSMutableArray *)sellerList {
    if (sellerList.count > 0) {
        [self.model.sellerList removeAllObjects];
        for (SellerInfoModel *seller in sellerList) {
            if (seller.seller_id != nil && ![seller.seller_id isEqualToString:@""])
                [self.model.sellerList addObject:seller.seller_id];
        }
        self.selectedSellers = [NSString stringWithFormat:@"您选择了%lu位商家", sellerList.count];
        [self.tableView reloadData];
    } else {
        //sellerField.text = @"";
    }
}

#pragma mark - UIButtonTarget
- (void)submitBtnClicked:(id)sender {
    if (self.model.sellerList.count == 0 && self.model.condtions.count == 0) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有选择推送商家" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    
    [self publicateMaintenance];
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *controller = segue.destinationViewController;
    if ([controller respondsToSelector:@selector(setDelegate:)]) {
        [controller setValue:self forKey:@"delegate"];
    }
    
    if ([segue.identifier isEqualToString:@"maintenance_show_seller_list"]) {
        [segue.destinationViewController setValue:kServiceType_CarMaintenance forKey:@"type"];
    }
}

- (void)publicateMaintenance {
    if (self.model.sellerList.count == 0 && _location == nil) {
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"未取得用户位置情报" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设定", nil];
        [alert show:self];
        return;
    }
    
    // create publication time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *publicate_time = [dateFormatter stringFromDate:[[NSDate alloc]init]];

    UserModel *user = [UserModel sharedClient];
    NSDictionary *info = @{@"role":@"user",
                           @"user_id":user.user_id,
                           @"date_time":self.model.time,
                           @"order_type":kOrderTypeBidding,
                           @"order_service_type":kServiceType_CarMaintenance,
                           @"mode":@"multi",
                           @"date_time":self.model.time,
                           @"items":self.model.items,
                           @"platenumber":self.model.platenumber,
                           @"publicate_time":publicate_time};
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:info];
    if (self.model.sellerList.count > 0) {
        [params setObject:self.model.sellerList forKey:@"target_seller"];
    }
    if (self.model.condtions.count > 0) {
        [params setObject:self.model.condtions forKey:@"condition"];
    }
    if (_location != nil) {
        NSMutableDictionary *loc = [[NSMutableDictionary alloc]init];
        [loc setValue:[NSNumber numberWithDouble:_location.coordinate.latitude] forKey:@"lat"];
        [loc setValue:[NSNumber numberWithDouble:_location.coordinate.longitude] forKey:@"lng"];
        [params setObject:loc forKey:@"location"];
    }
    
    __block MTPublicateStep2ViewController *blockself = self;
    [RCar POST:rcar_api_user_order modelClass:nil config:nil params:params success:^(NSDictionary *data) {
        NSString *result = [data objectForKey:@"api_result"];
        if (result.intValue == APIE_OK) {
            NSString *order_id = [data objectForKey:@"order_id"];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
            OrderWaitingViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OrderWaitingViewController"];
            controller.order_id = order_id;
            controller.order_type = @"maintenance";
            [blockself.navigationController pushViewController:controller animated:YES];
        
        } else if (result.intValue == APIE_NO_SERVICE) {
            MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"非常抱歉，没有提供该服务的商家" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            
        
        } else {
            MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
        }
        return;
    }failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"网络不能连接，请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }];
    
}


@end
