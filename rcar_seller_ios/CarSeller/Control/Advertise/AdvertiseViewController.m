//
//  AdvertiseViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 27/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "AdvertiseViewController.h"
#import "AdvertisementModel.h"
#import "SellerModel.h"
#import "PhotoAlbumView.h"
#import "PickerView.h"
#import "RadioButton.h"

enum {
    Tag_StartTime = 10000,
    Tag_EndTime,
};

@interface AdvertiseViewController () <MxAlertViewDelegate, PickerViewDelegate, RadioButtonDelegate>
@property (nonatomic, retain) UITextField *titleTextField;
@property (nonatomic, strong) PhotoAlbumView *albumView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UITextField *urlTextField;

@end

@implementation AdvertiseViewController {
    SellerModel *_seller;
    UIActivityIndicatorView *_activity;
}


- (id) init {
    self = [super initWithStyle:UITableViewStylePlain];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _seller = [SellerModel sharedClient];
    self.navigationItem.title = @"广告申请";
    self.tabBarController.tabBar.hidden = YES;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"撤销" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClicked:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    
    // display activity indicator
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    _activity.backgroundColor = [UIColor grayColor];
    _activity.alpha = 0.5;
    _activity.layer.cornerRadius = 6;
    _activity.layer.masksToBounds = YES;
    [self.view addSubview:_activity];
    
    
    __block AdvertiseViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.reuseIdentifier = @"UIControlCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"广告标题";
            cell.detailTextLabel.text = blockself.model.title;
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"DetailTextCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"开始时间";
            cell.detailTextLabel.text = blockself.model.start_time;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"DetailTextCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"结束时间";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailTextLabel.text = blockself.model.end_time;
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"DetailTextCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"投放地区";
            cell.detailTextLabel.text = @"大连";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"广告图片(1张 320*90)";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellHeight = 90.f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            blockself.albumView = [PhotoAlbumView initWithViewController:blockself frame:cell.frame mode:PhotoAlbumMode_View];
            blockself.albumView.maxOfImage = 4;
            [cell.contentView addSubview:blockself.albumView];
            
            // load images here
            [blockself.albumView loadImages:blockself.model.images];
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"广告连接";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            if ([blockself.model.type isEqualToString:@"url"]) {
                cell.textLabel.text = @"连接地址";
                cell.detailTextLabel.text = blockself.model.link;
            } else {
                cell.textLabel.text = @"直接连接到店面";
            }
        }];
        
        if (![blockself.model.status isEqualToString:kAdvertisementStatus_Canceling]) {
            section.sectionFooterHeight = 40.f;
            section.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, blockself.tableView.frame.size.width, 40.f)];
            blockself.cancelBtn = [[UIButton alloc]initWithFrame:section.footerView.frame];
            [blockself.cancelBtn addTarget:blockself action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [blockself.cancelBtn setTitle:@"撤销" forState:UIControlStateNormal];
            [blockself.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            blockself.cancelBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
            
            blockself.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
            [section.footerView addSubview:blockself.cancelBtn];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)helpAdvertisement:(id)sender {
    [self performSegueWithIdentifier:@"advertisement_help" sender:self];
}

- (void)cancelBtnClicked:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"role":@"seller", @"seller_id":_seller.seller_id, @"ads_id":self.model.ads_id}];
    [_activity startAnimating];
    __block AdvertiseViewController *blockself = self;
    [RCar PUT:rcar_api_seller_advertisement modelClass:@"APIResponseModel" config:nil params:params success:^(APIResponseModel *reply) {
        [_activity stopAnimating];
        if (reply.api_result == APIE_OK) {
            _model.status = kAdvertisementStatus_Canceling;
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"广告撤销申请提交成功，请等待系统审核" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        } else {
            [blockself handleError:nil];
        }
    } failure:^(NSString *errorStr) {
        [_activity stopAnimating];
        [blockself handleError:errorStr];
    }];
    
}



- (void)handleError:(NSString *)error {
    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"广告申请提交失败" delegate:nil cancelButtonTitle:@"重新提交" otherButtonTitles:@"取消", nil];
    [alert show:self];
    return;
    
}

#pragma mark - MxAlertViewDelegate
- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
