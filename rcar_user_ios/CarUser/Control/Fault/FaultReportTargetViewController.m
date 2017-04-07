//
//  FaultReportTargetViewController.m
//  CarUser
//
//  Created by jenson.zuo on 21/7/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "FaultReportTargetViewController.h"
#import "SellerListViewController.h"
#import "OrderWaitingViewController.h"
#import "BGRadioView.h"
#import "OrderModel.h"


typedef enum {
    SECTION_DISTANCE,
    SECTION_SELLER_TYPE,
    SECTION_SEARCHE_SELLER,
    SECTION_OK
}SectionType;

@interface FaultReportTargetViewController () <SellerListSelectDelegate, BGRadioViewDelegate>
@property (nonatomic, strong) BGRadioView *radioDistance;
@property (nonatomic, strong) BGRadioView *radioSellerType;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) NSString *selectedSellers;



@end

@implementation FaultReportTargetViewController {
    UIActivityIndicatorView *_activity;
}
@synthesize faultModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择推送商家";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    // clear noused rows
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.faultModel.condtion = [[NSMutableDictionary alloc]init];
    [self.faultModel.condtion setValue:@"10" forKey:@"radius"];
    [self.faultModel.condtion setValue:@"normal" forKey:@"type"];
    self.faultModel.target_sellers = [[NSMutableArray alloc]init];
    
    // display activity indicator
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    _activity.backgroundColor = [UIColor grayColor];
    _activity.alpha = 0.5;
    _activity.layer.cornerRadius = 6;
    _activity.layer.masksToBounds = YES;
    [self.tableView addSubview:_activity];
    

    
    __block FaultReportTargetViewController *blockself = self;
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
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Maintenance" bundle:nil];
            SellerListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SellerListViewController"];
            controller.delegate = blockself;
            controller.type  = kServiceType_CarFault;
            [blockself.navigationController pushViewController:controller animated:YES];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Radio List Delegate
-(void)radioView:(BGRadioView *)radioView didSelectOption:(int)optionNo fortag:(int)tagNo {
    NSArray *distance = @[@"0", @"5", @"10", @"20", @"30"];
    NSArray *sellerType = @[@"all", @"4s", @"normal"];
    
    if (tagNo == SECTION_DISTANCE) {
        [self.faultModel.condtion setValue:[distance objectAtIndex:optionNo] forKey:@"radius"];
    } else if (tagNo == SECTION_SELLER_TYPE) {
        [self.faultModel.condtion setValue:[sellerType objectAtIndex:optionNo] forKey:@"type"];
    } else {
    }
    
}

#pragma mark - SellerListSelectDelegate

- (void)sellerListSelected:(NSMutableArray *)sellerList {
    [self.faultModel.target_sellers removeAllObjects];
    for (SellerInfoModel *seller in sellerList) {
        if (seller.seller_id != nil && ![seller.seller_id isEqualToString:@""])
            [self.faultModel.target_sellers addObject:seller.seller_id];
    }
    if (self.faultModel.target_sellers.count > 0) {
        self.selectedSellers = [NSString stringWithFormat:@"您选择了%lu位商家", sellerList.count];
        [self.tableView reloadData];
    }
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

}

- (void)submitBtnClicked:(id)sender {
    if (self.faultModel.target_sellers.count == 0 && self.faultModel.condtion.count == 0) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有选择推送商家" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    
    [self publicateFault];
}

- (void)publicateFault {
    
    // create publication time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.faultModel.publicate_time = [dateFormatter stringFromDate:[[NSDate alloc]init]];
    
    UserModel *user = [UserModel sharedClient];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{ @"role":@"user", @"publicate_time":self.faultModel.publicate_time, @"date_time":self.faultModel.date_time, @"order_type":kOrderTypeBidding, @"order_service_type":kServiceType_CarFault, @"mode":@"multi", @"user_id":user.user_id, @"platenumber":self.faultModel.platenumber}];
    
    if (self.faultModel.touser)
        [params setValue:@"yes" forKey:@"touser"];
    else
        [params setValue:@"no" forKey:@"touser"];
    
    if (self.faultModel.position != nil && [self.faultModel.position isEqualToString:@""])
        [params setValue:self.faultModel.position forKey:@"position"];
    
    if (self.faultModel.title != nil)
        [params setValue:self.faultModel.title forKey:@"title"];
    if (self.faultModel.items.count > 0)
        [params setValue:self.faultModel.items forKey:@"items"];
    if (self.faultModel.location != nil)
        [params setValue:self.faultModel.location forKey:@"location"];
    
    // set condition
    if (self.faultModel.condtion.count > 0)
        [params setValue:self.faultModel.condtion forKey:@"condition"];
    
    [params setValue:self.faultModel.target_sellers forKey:@"target_seller"];
   
    [params setValue:[NSNumber numberWithInteger: self.faultModel.images.count] forKey:@"images"];
    
    __block FaultReportTargetViewController *blockself = self;
    [_activity startAnimating];
    [RCar POST:rcar_api_user_order modelClass:nil config:nil params:params success:^(NSDictionary *data) {
        NSString *result = [data objectForKey:@"api_result"];
        [_activity stopAnimating];
        if (result.intValue == APIE_OK) {
            blockself.faultModel.order_id = [[NSString alloc]initWithString:[data objectForKey:@"order_id"]];
            // if there are no images to upload, jump directly
            if (blockself.faultModel.images.count == 0) {
                [_activity stopAnimating];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
                OrderWaitingViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OrderWaitingViewController"];
                controller.order_id = blockself.faultModel.order_id;
                controller.order_type = @"fault";
                [blockself.navigationController pushViewController:controller animated:YES];
                return;
        
            } else {
                // upload images
                NSArray *names = [data objectForKey:@"images"];
                if (names != nil && names.count > 0) {
                    [RCar uploadImage:blockself.faultModel.images names:names target:@"user" success:^(id result) {
                        [_activity stopAnimating];
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
                        OrderWaitingViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OrderWaitingViewController"];
                        controller.order_id = blockself.faultModel.order_id;
                        controller.order_type = @"fault";
                        [blockself.navigationController pushViewController:controller animated:YES];
                    } failure:^(NSString *errorStr) {
                        [_activity stopAnimating];
                        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show:self];
                    }];
                }
                
            }
        } else if (result.intValue == APIE_SELLER_NO_EXIST) {
            MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"系统没有搜多到商家" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
            
        }else {
            MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
        return;
    }failure:^(NSString *errorStr) {
        [_activity stopAnimating];
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"网络不能连接，请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }];
}



@end
