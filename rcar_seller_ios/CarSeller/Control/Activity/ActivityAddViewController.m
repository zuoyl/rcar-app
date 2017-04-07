//
//  SellerActivityAddViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 23/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//
#import "ActivityAddViewController.h"
#import "SellerActivityModel.h"
#import "SellerModel.h"
#import "PhotoAlbumView.h"
#import "PickerView.h"

enum {
    Tag_StartTime = 10000,
    Tag_EndTime,
};

@interface ActivityAddViewController () <MxAlertViewDelegate, PickerViewDelegate>
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, retain) UITextField *titleTextField;
@property (nonatomic, strong) PhotoAlbumView *albumView;
@property (nonatomic, strong) UITextView *detailTextView;

@end

@implementation ActivityAddViewController {
    UIActivityIndicatorView *_activity;
    SellerModel *_seller;
    SellerActivityModel *_model;
    NSString *_activityStartDate;
    NSString *_activityEndDate;
}


- (id) init {
    self = [super initWithStyle:UITableViewStylePlain];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _seller = [SellerModel sharedClient];
    self.navigationItem.title = @"添加活动";
    self.hidesBottomBarWhenPushed = YES;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    
    // display activity indicator
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    _activity.backgroundColor = [UIColor grayColor];
    _activity.alpha = 0.5;
    _activity.layer.cornerRadius = 6;
    _activity.layer.masksToBounds = YES;
    [self.view addSubview:_activity];
    
    __block ActivityAddViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.reuseIdentifier = @"UIControlCell";
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"活动标题";
            
            blockself.titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, blockself.tableView.frame.size.width - 100, 35.f)];
            blockself.titleTextField.contentMode = UIControlContentVerticalAlignmentCenter;
            blockself.titleTextField.placeholder = @"请输入标题(字数不超过8)";
            blockself.titleTextField.font = [UIFont systemFontOfSize:15.f];
            blockself.titleTextField.keyboardType = UIKeyboardTypeASCIICapable;
            blockself.titleTextField.returnKeyType = UIReturnKeyDone;
            [cell.contentView addSubview:blockself.titleTextField];

        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"DetailTextCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            
            cell.textLabel.text = @"开始时间";
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
            
            cell.textLabel.text = @"结束时间";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } whenSelected:^(NSIndexPath *indexPath) {
            NSDate *date = [[NSDate alloc]init];
            PickerView *picker = [[PickerView alloc]initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:false];
            picker.tag = Tag_EndTime;
            picker.delegate = blockself;
            [picker show];
        }];
        
    }];
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"活动详细";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellHeight = 180.f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            blockself.detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, cell.frame.size.width - 10, 180.f)];
            blockself.detailTextView.font = [UIFont systemFontOfSize:15.f];
            blockself.detailTextView.keyboardType = UIKeyboardTypeASCIICapable;
            blockself.detailTextView.returnKeyType = UIReturnKeyDone;
            [cell.contentView addSubview:blockself.detailTextView];
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"活动图片(4张 320*90)";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellHeight = 90.f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            blockself.albumView = [PhotoAlbumView initWithViewController:blockself frame:cell.frame mode:PhotoAlbumMode_Edit];
            blockself.albumView.maxOfImage = 4;
            [cell.contentView addSubview:blockself.albumView];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)submitBtnClicked:(id)sender {
    if (![self checkValidity]) return;
    if (_model == nil)
        _model = [[SellerActivityModel alloc]init];
    _model.status = kActivityStatus_Doing;
    _model.title = self.titleTextField.text;
    _model.detail = self.detailTextView.text;
    _model.start_date = _activityStartDate;
    _model.end_date = _activityEndDate;
    
    [self submitActivity];
    
}

- (void)handleError:(NSString *)error {
    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力,活动提交失败，请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show:self];
    return;
    
}

#pragma mark - PickerViewDelegate
-(void)pickerViewDone:(PickerView *)pickView result:(NSString *)result {
    NSArray *anArrayOfIndexPath = [NSArray arrayWithArray:[self.tableView indexPathsForVisibleRows]];
    
    if (pickView.tag == Tag_StartTime) {
        _activityStartDate = [result substringWithRange:NSMakeRange(0, 10)];
        
        if (_activityEndDate != nil && ![self isDateEarlierThan:_activityStartDate end:_activityEndDate]) {
            _activityStartDate = @"";
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"开始时间早于结束时间,请重新设定" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
        
        NSIndexPath *indexPath = [anArrayOfIndexPath objectAtIndex:1];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = _activityStartDate;
        
    } else if (pickView.tag == Tag_EndTime) {
        _activityEndDate = [result substringWithRange:NSMakeRange(0, 10)];
        
        if (_activityStartDate != nil && ![self isDateEarlierThan:_activityStartDate end:_activityEndDate]) {
            _activityEndDate = @"";
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"开始时间早于结束时间,请重新设定" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
        
        NSIndexPath *indexPath = [anArrayOfIndexPath objectAtIndex:2];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = _activityEndDate;
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
    
    if ([d1 compare:d2] == NSOrderedAscending)
        return true;
    return false;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)checkValidity {
    // check parameter
    if ([self.titleTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写活动标题" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if (!_activityStartDate || [_activityStartDate isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有设定活动开始时间" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if (!_activityEndDate || [_activityStartDate isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有设定活动结束时间" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    
    if ([self.detailTextView.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写活动详细内容" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if (self.albumView.numberOfImage == 0) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写活动图片" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    
    return true;
}

- (void)submitActivity {
    [_activity startAnimating];
    
    
    SellerModel *sellerModel = [SellerModel sharedClient];
    NSMutableDictionary *params =  [[NSMutableDictionary alloc]initWithDictionary:@{@"role":@"seller", @"seller_id":sellerModel.seller_id, @"title":self.titleTextField.text, @"detail":self.detailTextView.text, @"start_date":_activityStartDate, @"end_date":_activityEndDate}];
    
    [params setValue:[NSNumber numberWithInteger:self.albumView.numberOfImage] forKey:@"images"];
    
    __block ActivityAddViewController *blockself = self;
    
    [RCar POST:rcar_api_seller_activity modelClass:nil config:nil params:params success:^(NSDictionary *data) {
        NSString *result = [data objectForKey:@"api_result"];
        if (result.integerValue == APIE_OK) {
            _model.activity_id = [data objectForKey:@"activity_id"];
            _model.status = kActivityStatus_Doing;
            _model.images = [data objectForKey:@"images"];
            SellerModel *seller = [SellerModel sharedClient];
            [seller.activities addObject:_model];
            
            if (_model.images != nil && _model.images.count > 0) {
                [RCar uploadImage:[blockself.albumView getImageDatasWithJpegCompress:0.5] names:_model.images target:@"seller" success:^(id result) {
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
        }
    } failure:^(NSString *errorStr) {
        [blockself handleError:errorStr];
    }];
}

@end
