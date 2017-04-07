//
//  AdvertiseAddViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 1/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "AdvertiseAddViewController.h"
#import "AdvertisementModel.h"
#import "SellerModel.h"
#import "PhotoAlbumView.h"
#import "PickerView.h"
#import "RadioButton.h"
#import "CitySelectViewController.h"

enum {
    Tag_StartTime = 10000,
    Tag_EndTime,
};

@interface AdvertiseAddViewController () <MxAlertViewDelegate, PickerViewDelegate, RadioButtonDelegate, CitySelectDelegate>
@property (nonatomic, retain) UITextField *titleTextField;
@property (nonatomic, strong) PhotoAlbumView *albumView;
@property (nonatomic, strong) UITextField *urlTextField;
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation AdvertiseAddViewController {
    UIActivityIndicatorView *_activity;
    SellerModel *_seller;
    PhotoAlbumView *_photoView;
    AdvertisementModel *_ads;
    NSString *_adsStartDate;
    NSString *_adsEndDate;
    NSString *_linkType;
    NSString *_city;
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
    self.hidesBottomBarWhenPushed = YES;
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"帮助" style:UIBarButtonItemStylePlain target:self action:@selector(helpAdvertisement:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //
    [RadioButton addObserverForGroupId:@"group1" observer:self];
    _linkType = @"seller";
    
    // display activity indicator
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    _activity.backgroundColor = [UIColor grayColor];
    _activity.alpha = 0.5;
    _activity.layer.cornerRadius = 6;
    _activity.layer.masksToBounds = YES;
    [self.view addSubview:_activity];
    
    __block AdvertiseAddViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
    
            staticContentCell.reuseIdentifier = @"UIControlCell";
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"广告标题";
            blockself.titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, blockself.tableView.frame.size.width - 100, 35.f)];blockself.titleTextField.contentMode = UIControlContentVerticalAlignmentCenter;
            blockself.titleTextField.keyboardType = UIKeyboardTypeASCIICapable;
            blockself.titleTextField.returnKeyType = UIReturnKeyDone;
            blockself.titleTextField.placeholder = @"请输入标题(字数不超过8)";
            blockself.titleTextField.font = [UIFont systemFontOfSize:15.f];
            [cell.contentView addSubview:blockself.titleTextField];

            
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"DetailTextCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            
            cell.textLabel.text = @"投放开始时间";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        } whenSelected:^(NSIndexPath *indexPath) {
            NSDate *date = [[NSDate alloc]init];
            PickerView *picker = [[PickerView alloc]initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:false];
            picker.tag = Tag_StartTime;
            picker.delegate = blockself;
            [picker show];
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
             staticContentCell.reuseIdentifier = @"DetailTextCell";
             staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.cellHeight = 35.f;
            
            cell.textLabel.text = @"投放结束时间";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        } whenSelected:^(NSIndexPath *indexPath) {
            NSDate *date = [[NSDate alloc]init];
            PickerView *picker = [[PickerView alloc]initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:false];
            picker.tag = Tag_EndTime;
            picker.delegate = blockself;
            [picker show];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
             staticContentCell.reuseIdentifier = @"DetailTextCell";
             staticContentCell.cellStyle = UITableViewCellStyleValue1;
            
            cell.textLabel.text = @"投放地区:";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        } whenSelected:^(NSIndexPath *indexPath) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            CitySelectViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"CitySelectViewController"];
            controller.delegate = blockself;
            [blockself.navigationController pushViewController:controller animated:YES];
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"广告图片(1张 320*90)";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellHeight = 90.f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            blockself.albumView = [PhotoAlbumView initWithViewController:blockself frame:cell.frame mode:PhotoAlbumMode_Edit];
            blockself.albumView.maxOfImage = 1;
            [cell.contentView addSubview:blockself.albumView];
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"广告连接";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            RadioButton *radio = [[RadioButton alloc]initWithGroupId:@"group1" index:0];
            radio.frame = CGRectMake(10, 10, 22, 22);
            [radio setChecked:YES];
            [cell.contentView addSubview:radio];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 200, 22)];
            label.text = @"直接连接到店面";
            label.font = [UIFont systemFontOfSize:15.f];
            
            [cell.contentView addSubview:label];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            RadioButton *radio = [[RadioButton alloc]initWithGroupId:@"group1" index:0];
            radio.frame = CGRectMake(10, 10, 22, 22);
            [cell.contentView addSubview:radio];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 200, 22)];
            label.text = @"连接到指定Web页面";
            label.font = [UIFont systemFontOfSize:15.f];
            
            [cell.contentView addSubview:label];
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.reuseIdentifier = @"UIControlCell";
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"连接指定Url";
            
            blockself.urlTextField = [[UITextField alloc]initWithFrame:CGRectMake(cell.frame.size.width - 200, 0, 200, 35.f)];
            blockself.urlTextField.contentMode = UIControlContentVerticalAlignmentCenter;
            blockself.urlTextField.placeholder = @"请输入url";
            blockself.urlTextField.font = [UIFont systemFontOfSize:15.f];
            blockself.urlTextField.keyboardType = UIKeyboardTypeASCIICapable;
            blockself.urlTextField.returnKeyType = UIReturnKeyDone;
            [cell addSubview:blockself.urlTextField];
        }];
        
        section.sectionFooterHeight = 40.f;
        section.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, blockself.tableView.frame.size.width, 40.f)];
        blockself.submitBtn = [[UIButton alloc]initWithFrame:section.footerView.frame];
        [blockself.submitBtn addTarget:blockself action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [blockself.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [blockself.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        blockself.submitBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
        
        blockself.submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [section.footerView addSubview:blockself.submitBtn];

    }];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)helpAdvertisement:(id)sender {
    [self performSegueWithIdentifier:@"advertisement_help" sender:self];
}

- (void)submitAdvertisement {
    [_activity startAnimating];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"role":@"seller", @"seller_id":_seller.seller_id, @"title":self.titleTextField.text, @"type":_linkType, @"start_date":_adsStartDate, @"end_date":_adsEndDate,@"city":_city}];
    if ([_linkType isEqualToString:@"url"])
        [params setValue:self.urlTextField.text forKey:@"url"];
    [params setValue:[NSNumber numberWithInteger:self.albumView.numberOfImage] forKey:@"images"];
    
    
    __block AdvertiseAddViewController *blockself = self;
    
    [RCar POST:rcar_api_seller_advertisement modelClass:@"AdvertisementRspModel" config:nil params:params success:^(AdvertisementRspModel *rsp) {
        [_activity stopAnimating];
        if (rsp.api_result == APIE_OK) {
            _ads.ads_id = rsp.ads_id;
            _ads.images = rsp.images;
            _ads.start_time = _adsStartDate;
            _ads.end_time = _adsEndDate;
            _ads.city = _city;
            _ads.images = rsp.images;
            
            [_seller.advertisements addObject:_ads];
            
            if (_ads.images != nil && _ads.images.count > 0) {
                [RCar uploadImage:[blockself.albumView getImageDatasWithJpegCompress:0.5] names:_ads.images target:@"seller" success:^(id result) {
                    [_activity stopAnimating];
                    [blockself.navigationController popViewControllerAnimated:YES];
                } failure:^(NSString *errorStr) {
                    [_activity stopAnimating];
                    [blockself.navigationController popViewControllerAnimated:YES];
                }];
                return;
            } else {
                [_activity stopAnimating];
                [blockself.navigationController popViewControllerAnimated:YES];
            }
            [blockself.navigationController popViewControllerAnimated:YES];
        } else {
           // [blockself setCurrentState:ViewStatusCallFailed];
        }
    } failure:^(NSString *errorStr) {
        [_activity stopAnimating];
        //[blockself setCurrentState:ViewStatusCallFailed];
    }];
    
}

- (void)submitBtnClicked:(id)sender {
    if (![self checkValidaity]) return;
    if (_ads == nil)
        _ads = [[AdvertisementModel alloc]init];
    _ads.status = kAdvertisementStatus_New;
    _ads.title = self.titleTextField.text;
    [self submitAdvertisement];

}

- (void)handleError:(NSString *)error {
    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"广告申请提交失败" delegate:nil cancelButtonTitle:@"重新提交" otherButtonTitles:@"取消", nil];
    [alert show:self];
    return;
    
}

#pragma mark - MxAlertViewDelegate
- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self submitAdvertisement];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - PickerViewDelegate
-(void)pickerViewDone:(PickerView *)pickView result:(NSString *)result {
    NSArray *anArrayOfIndexPath = [NSArray arrayWithArray:[self.tableView indexPathsForVisibleRows]];
   
    if (pickView.tag == Tag_StartTime) {
        _adsStartDate = [result substringWithRange:NSMakeRange(0, 10)];
        
        if (_adsEndDate != nil && ![self isDateEarlierThan:_adsStartDate end:_adsEndDate]) {
            _adsStartDate = @"";
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"开始时间早于结束时间,请重新设定" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
        
        NSIndexPath *indexPath = [anArrayOfIndexPath objectAtIndex:1];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = _adsStartDate;
        
        
    } else if (pickView.tag == Tag_EndTime) {
        _adsEndDate = [result substringWithRange:NSMakeRange(0, 10)];
        
        if (_adsStartDate != nil && ![self isDateEarlierThan:_adsStartDate end:_adsEndDate]) {
            _adsEndDate = @"";
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"开始时间早于结束时间,请重新设定" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
        
        NSIndexPath *indexPath = [anArrayOfIndexPath objectAtIndex:2];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = _adsEndDate;
    }
}

- (BOOL)isDateEarlierThan:(NSString *)date1 end:(NSString *)date2 {
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter1 setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSDate *d1 = [dateFormatter1 dateFromString:date1];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter2 setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSDate *d2 = [dateFormatter1 dateFromString:date2];
    
    if ([d1 compare:d2] == NSOrderedAscending) return true;
    return false;
}
#pragma mark - CitySelectViewDelegate
- (void)citySelected:(NSString *)name {
    NSArray *anArrayOfIndexPath = [NSArray arrayWithArray:[self.tableView indexPathsForVisibleRows]];
    NSIndexPath *indexPath = [anArrayOfIndexPath objectAtIndex:3];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = name;
    _city = name;
}

#pragma mark - RadioButtonViewDelegate
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString*)groupId {
    if ([groupId isEqualToString:@"group1"]) {
        if (index == 0)_linkType = @"seller";
        else _linkType = @"url";
    }
}

- (BOOL)checkValidaity {
    if (self.titleTextField.text == nil || [self.titleTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有输入申请标题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if (_adsStartDate == nil || _adsEndDate == nil) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有明确广告投放时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if ([_linkType isEqualToString:@"url"] && [self.urlTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写广告连接页面" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if (self.albumView.numberOfImage == 0) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写广告图片" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    
    if (_city == nil || [_city isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写广告投放城市" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    
    return true;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
