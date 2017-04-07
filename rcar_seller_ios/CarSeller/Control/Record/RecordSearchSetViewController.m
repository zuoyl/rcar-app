//
//  RecordSearchSetViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 21/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "RecordSearchSetViewController.h"
#import "PickerView.h"
#import "CheckBoxView.h"
#import "SellerModel.h"
#import "DCArrayMapping.h"
#import "DataArrayModel.h"
#import "RecordModel.h"
#import "RecordSearchResultViewController.h"

enum {
    Tag_StartTime = 10000,
    Tag_EndTime,
    Tag_ServiceDetailCheck,
    Tag_CheckTimeSearch = 20000,
    Tag_CheckServiceSearch,
    Tag_CheckUserSearch,
    Tag_CheckKeywordSearch,
};

NSString * const kRecordSearchType_Time = @"time";
NSString * const kRecordSearchKey_TimeStart = @"start";
NSString * const kRecordSearchKey_TimeEnd = @"end";

NSString * const kRecordSearchType_User = @"user";
NSString * const kRecordSearchType_Service = @"service";
NSString * const kRecordSearchType_Keyword = @"keyword";

@interface RecordSearchSetViewController () <PickerViewDelegate, CheckBoxViewDelegate>
@property (nonatomic, strong) UITextView *userTextView;
@property (nonatomic, strong) UITextView *keywordTextView;


@end

@implementation RecordSearchSetViewController {
    NSString *_recordStartDate;
    NSString *_recordEndDate;
    BOOL _timeSearchChecked;
    BOOL _serviceSearchChecked;
    BOOL _userSearchChecked;
    BOOL _keywordSearchChecked;
    NSMutableArray *_detailServices;
    NSMutableArray *_searchResult;
}
@synthesize tableView;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = @"检索设定";
    
    // initialize variable
    _timeSearchChecked = NO;
    _serviceSearchChecked = NO;
    _userSearchChecked = NO;
    _keywordSearchChecked = NO;
    _detailServices = [[NSMutableArray alloc]init];
    _searchResult = [[NSMutableArray alloc]init];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    // initialize tableview
    __block RecordSearchSetViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.sectionHeight = 20.f;
        CheckBoxView *checkbox = [[CheckBoxView alloc]initWithDelegate:blockself];
        [checkbox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        checkbox.titleLabel.font = [UIFont systemFontOfSize:15];
        [checkbox setTitle:@"检索时间范围" forState:UIControlStateNormal];
        [checkbox setChecked:NO];
        checkbox.frame = CGRectMake(10, 0, 120, 20);
        checkbox.tag = Tag_CheckTimeSearch;
        section.headerView = checkbox;

        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"DetailTextCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.textLabel.text = @"开始时间:";
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
            cell.textLabel.text = @"结束时间:";
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
        section.sectionHeight = 20.f;
        CheckBoxView *checkbox = [[CheckBoxView alloc]initWithDelegate:blockself];
        [checkbox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        checkbox.titleLabel.font = [UIFont systemFontOfSize:15];
        [checkbox setTitle:@"检索服务项目" forState:UIControlStateNormal];
        [checkbox setChecked:NO];
        checkbox.frame = CGRectMake(10, 0, 120, 20);
        checkbox.tag = Tag_CheckServiceSearch;
        section.headerView = checkbox;
        

        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellHeight = 130.f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            NSArray *services = @[@"洗车", @"汽车维修", @"汽车保养", @"钣金喷漆", @"汽车装潢", @"轮胎置换", @"紧急救援", @"上门服务"];
            
            CGFloat x = 20;
            CGFloat y = 10;
            for (int index = 0; index < services.count; index++) {
                CheckBoxView *checkbox = [[CheckBoxView alloc]initWithDelegate:blockself];
                [checkbox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                checkbox.titleLabel.font = [UIFont systemFontOfSize:15];
                [checkbox setTitle:services[index] forState:UIControlStateNormal];
                [checkbox setChecked:NO];
                checkbox.tag = Tag_ServiceDetailCheck + index;
                checkbox.frame = CGRectMake(x, y, 120, 20);
                x += 120 + 5;
                if (x + checkbox.frame.size.width > cell.frame.size.width) {
                    x = 20;
                    y += 20 + 10;
                }
                [cell addSubview:checkbox];
            }
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.sectionHeight = 20.f;
        CheckBoxView *checkbox = [[CheckBoxView alloc]initWithDelegate:blockself];
        [checkbox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        checkbox.titleLabel.font = [UIFont systemFontOfSize:15];
        [checkbox setTitle:@"检索用户" forState:UIControlStateNormal];
        [checkbox setChecked:NO];
        checkbox.frame = CGRectMake(10, 0, 120, 20);
        checkbox.tag = Tag_CheckUserSearch;
        section.headerView = checkbox;

        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.textLabel.text = @"用户名:";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            blockself.userTextView = [[UITextView alloc]initWithFrame:CGRectMake(cell.frame.size.width - 200, 8, 150, 22)];
            [cell.contentView addSubview:blockself.userTextView];
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.sectionHeight = 20.f;
        CheckBoxView *checkbox = [[CheckBoxView alloc]initWithDelegate:blockself];
        [checkbox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        checkbox.titleLabel.font = [UIFont systemFontOfSize:15];
        [checkbox setTitle:@"检索关键字" forState:UIControlStateNormal];
        [checkbox setChecked:NO];
        checkbox.frame = CGRectMake(10, 0, 120, 20);
        checkbox.tag = Tag_CheckKeywordSearch;
        section.headerView = checkbox;

        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.textLabel.text = @"关键字:";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            blockself.keywordTextView = [[UITextView alloc]initWithFrame:CGRectMake(cell.frame.size.width - 200, 8, 150, 22)];
            [cell.contentView addSubview:blockself.keywordTextView];
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.sectionHeight = 20.f;
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            UIButton *button = [[UIButton alloc]initWithFrame:cell.frame];
            [button addTarget:blockself action:@selector(searchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"检索" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            [cell.contentView addSubview:button];
            

        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
  }

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *controller = segue.destinationViewController;
    if ([controller respondsToSelector:@selector(setRecords:)]) {
        [controller setValue:_searchResult forKey:@"records"];
    }
}

- (void)searchBtnClicked:(id)sender {
    if (![self checkValidity])
        return;
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    
    if (_timeSearchChecked) {
        [result setValue:@{kRecordSearchKey_TimeStart:_recordStartDate, kRecordSearchKey_TimeEnd:_recordEndDate} forKey:kRecordSearchType_Time];
    }
    
    if (_serviceSearchChecked) {
        [result setValue:_detailServices forKey:kRecordSearchType_Service];
    }
    if (_userSearchChecked) {
        [result setValue:_userTextView.text forKey:kRecordSearchType_User];
    }
    if (_keywordSearchChecked) {
        [result setValue:_keywordTextView.text forKey:kRecordSearchType_Keyword];
    }
#if 0
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(recordSearchSetCompleted:)])
        [self.delegate recordSearchSetCompleted:result];
    
    [self.navigationController popViewControllerAnimated:YES];
#else 
    [self loadRecordList:result];
#endif
}

#pragma mark - PickerViewDelegate
-(void)pickerViewDone:(PickerView *)pickView result:(NSString *)result {
    NSArray *anArrayOfIndexPath = [NSArray arrayWithArray:[self.tableView indexPathsForVisibleRows]];
    
    if (pickView.tag == Tag_StartTime) {
        _recordStartDate = [result substringWithRange:NSMakeRange(0, 10)];
        
        NSIndexPath *indexPath = [anArrayOfIndexPath objectAtIndex:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = _recordStartDate;
        
    } else if (pickView.tag == Tag_EndTime) {
        _recordEndDate = [result substringWithRange:NSMakeRange(0, 10)];
        
        NSIndexPath *indexPath = [anArrayOfIndexPath objectAtIndex:1];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = _recordEndDate;
    }
}

#pragma makr - CheckboxViewDelegate
- (void)didSelectedCheckBox:(CheckBoxView *)checkbox checked:(BOOL)checked {
    switch (checkbox.tag) {
        case Tag_CheckTimeSearch:
            _timeSearchChecked = checked;
            break;
        case Tag_CheckServiceSearch:
            _serviceSearchChecked = checked;
            break;
        case Tag_CheckUserSearch:
            _userSearchChecked = checked;
            break;
        case Tag_CheckKeywordSearch:
            _keywordSearchChecked = checked;
            break;
        default:
            if (checked) {
                [_detailServices addObject:checkbox.titleLabel.text];
            } else {
                [_detailServices removeObject:checkbox.titleLabel.text];
            }
            break;
    }
}

- (BOOL)checkValidity {
    if ( (_timeSearchChecked == NO) && (_serviceSearchChecked == NO) &&
         (_userSearchChecked == NO) && (_keywordSearchChecked == NO)) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有设定检索条件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
        
    }
    
    if (_timeSearchChecked) {
        if (_recordStartDate == nil || [_recordStartDate isEqualToString:@""]) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有设定检索开始时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return false;
        }
        if (_recordEndDate == nil || [_recordEndDate isEqualToString:@""]) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有设定检索结束时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return false;
        }
    }
    
    if (_serviceSearchChecked) {
        if (_detailServices.count == 0) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有选择服务项目" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return false;
        }
    }
    if (_userSearchChecked) {
        if ([_userTextView.text isEqualToString:@""]) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有指定用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return false;
        }
    }
    if (_keywordSearchChecked) {
        if ([_keywordTextView.text isEqualToString:@""]) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写关键字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return false;
        }
    }
    return true;
}

- (void)loadRecordList:(NSDictionary *)condition {
    [_searchResult removeAllObjects];
    
    SellerModel *seller = [SellerModel sharedClient];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"role":@"seller", @"seller_id":seller.seller_id}];
    if (condition != nil)
        [params setObject:condition forKey:@"condition"];
    
    // get advertisement
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[RecordModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    __block RecordSearchSetViewController *blockself = self;
    [RCar GET:rcar_api_seller_order_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            NSArray *data = dataModel.data;
            if (data.count > 0) {
                [_searchResult addObjectsFromArray:data];
                [blockself performSegueWithIdentifier:@"show_search_result" sender:blockself];
            } else {
                MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有相关记录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show:self];
                return;
            }
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
    }failure:^(NSString *errorStr) {
        [self handleLoadError:errorStr];
    }];
}

- (void)handleLoadError:(NSString *)error {
    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力,请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show:self];
}

@end
