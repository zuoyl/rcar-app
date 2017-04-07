//
//  SellerActivityEditViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 23/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "ActivityViewController.h"
#import "PhotoAlbumView.h"
#import "SellerModel.h"
#import "PickerView.h"

enum {
    Tag_StartTime = 10000,
    Tag_EndTime,
};

@interface ActivityViewController () <MxAlertViewDelegate, PickerViewDelegate>
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) PhotoAlbumView *albumView;
@property (nonatomic, strong) UITextView *detailTextView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, assign) BOOL editMode;
@end

@implementation ActivityViewController {
    UIActivityIndicatorView *_activity;
    SellerModel *_seller;
    PhotoAlbumView *_photoView;
    SellerActivityModel *_model;
    NSString *_activityStartDate;
    NSString *_activityEndDate;
}

@synthesize model;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"查看活动";
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
    
    self.editMode = false;
    self.hidesBottomBarWhenPushed = YES;
    
    // display activity indicator
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    _activity.backgroundColor = [UIColor grayColor];
    _activity.alpha = 0.5;
    _activity.layer.cornerRadius = 6;
    _activity.layer.masksToBounds = YES;
    [self.view addSubview:_activity];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editActivity:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    __block ActivityViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"活动标题";
            if (blockself.titleTextField == nil)
                blockself.titleTextField = [[UITextField alloc]initWithFrame:CGRectMake( 100, 0, blockself.tableView.frame.size.width - 110, 35.f)];
            blockself.titleTextField.contentMode = UIControlContentVerticalAlignmentCenter;
            blockself.titleTextField.textAlignment = UIControlContentHorizontalAlignmentRight;
            blockself.titleTextField.keyboardType = UIKeyboardTypeASCIICapable;
            blockself.titleTextField.returnKeyType = UIReturnKeyDone;
            blockself.titleTextField.placeholder = blockself.model.title;
            [blockself.titleTextField setEnabled:blockself.editMode];
            
            [cell addSubview:blockself.titleTextField];
            
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"DetailTextCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.textLabel.text = @"开始时间";
            cell.detailTextLabel.text = blockself.model.start_date;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } whenSelected:^(NSIndexPath *indexPath) {
            if (blockself.editMode) {
                NSDate *date = [[NSDate alloc]init];
                PickerView *picker = [[PickerView alloc]initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:false];
                picker.tag = Tag_StartTime;
                picker.delegate = blockself;
                [picker show];
            }
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"DetailTextCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.textLabel.text = @"结束时间";
            cell.detailTextLabel.text = blockself.model.end_date;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } whenSelected:^(NSIndexPath *indexPath) {
            if (blockself.editMode) {
                NSDate *date = [[NSDate alloc]init];
                PickerView *picker = [[PickerView alloc]initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:false];
                picker.tag = Tag_EndTime;
                picker.delegate = blockself;
                [picker show];
            }
        }];
        
    }];
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"活动详细";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellHeight = 180.f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            blockself.detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, cell.frame.size.width - 10, 80)];
            blockself.detailTextView.font = [UIFont systemFontOfSize:15.f];
            blockself.detailTextView.text = blockself.model.detail;
            [blockself.detailTextView setEditable:blockself.editMode];
            blockself.detailTextView.keyboardType = UIKeyboardTypeASCIICapable;
            blockself.detailTextView.returnKeyType = UIReturnKeyDone;
            [cell.contentView addSubview:blockself.detailTextView];
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"活动图片";
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)editActivity:(id)sender {
    UIBarButtonItem *button = sender;
    if ([button.title isEqualToString:@"编辑"]) {
        self.editMode = true;
        button.title = @"取消";
        [self.albumView changeMode:PhotoAlbumMode_Edit];
        [self.titleTextField setEnabled:YES];
        [self.detailTextView setEditable:YES];
        __block ActivityViewController *blockself = self;
        
        [self insertSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
            section.sectionHeaderHight = 40.f;
            section.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, blockself.tableView.frame.size.width, 40.f)];
            blockself.submitBtn = [[UIButton alloc]initWithFrame:section.headerView.frame];
            [blockself.submitBtn addTarget:blockself action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [blockself.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
            [blockself.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            blockself.submitBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
            
            blockself.submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
            [section.headerView addSubview:blockself.submitBtn];
        } atIndex:3];
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)cancelEditActivity:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)submitBtnClicked:(id)sender {
    if (![self checkValidity]) return;
    
    [self updateActivity];
}

#pragma mark - UITableViewDelegate



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
    
    if ([d1 compare:d2] == NSOrderedAscending) return true;
    return false;
}


- (BOOL)checkValidity {
    // check parameter
    if ([self.titleTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写活动标题" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    // update date
    NSArray *anArrayOfIndexPath = [NSArray arrayWithArray:[self.tableView indexPathsForVisibleRows]];
    NSIndexPath *indexPath = [anArrayOfIndexPath objectAtIndex:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    _activityStartDate = cell.detailTextLabel.text;
    
    indexPath = [anArrayOfIndexPath objectAtIndex:2];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    _activityEndDate = cell.detailTextLabel.text;
    
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


- (void)updateActivity {
    
    [self.submitBtn setEnabled:NO];
    [_activity startAnimating];
    
    SellerModel *sellerModel = [SellerModel sharedClient];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:  @{@"role":@"seller", @"seller_id":sellerModel.seller_id, @"activity_id":self.model.activity_id, @"title":self.titleTextField.text, @"detail":self.detailTextView.text, @"start_date":_activityStartDate, @"end_date":_activityEndDate}];
    [params setValue:[NSNumber numberWithInteger:self.albumView.numberOfImage] forKey:@"images"];
    
    __block ActivityViewController *blockself = self;
    
    [RCar PUT:rcar_api_seller_activity modelClass:nil config:nil  params:params success:^(NSDictionary *data) {
        NSString *result = [data objectForKey:@"api_result"];
        if (result.integerValue == APIE_OK) {
            _model.images = [data objectForKey:@"images"];
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
        [_activity stopAnimating];
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力,请稍后再试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show:self];
    }];
}


- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
        [self updateActivity];
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
