//
//  RecordViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 27/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordDetailModel.h"
//#import "PhotoBrowserView.h"
#import "SellerModel.h"

@interface RecordViewController ()
@property (nonatomic, strong) UITextView *detailTextView;
//@property (nonatomic, strong) PhotoBrowserView *photoBrowser;

@end

@implementation RecordViewController {
    UIActivityIndicatorView *_activity;
}
@synthesize model;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"记录详细";
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
    
    // initialize tableview
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    [self.tableView reloadData];
    
    
    __block RecordViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"DetailTextCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.textLabel.text = @"业务时间";
            cell.detailTextLabel.text = blockself.model.date;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"DetailTextCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.textLabel.text = @"关系用户";
            cell.detailTextLabel.text = blockself.model.user;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"DetailTextCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.textLabel.text = @"业务类型";
            cell.detailTextLabel.text = blockself.model.type;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"DetailTextCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.textLabel.text = @"业务概要";
            cell.detailTextLabel.text = blockself.model.title;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }];
    }];
    

    
    [self loadRecordDetail:self.model.record_id];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)refreshView:(RecordDetailModel *)record {
    self.detailTextView.text = record.detail;
   // if (record.images.count > 0)
       // [self.photoBrowser loadImages:[[NSMutableArray alloc]initWithArray:record.images]];
    
    // get record items
    
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"业务详细";
        // section.sectionHeight = 90.f;
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, cell.frame.size.width - 20, cell.frame.size.height - 10)];
            [detailTextView setEditable:NO];
            detailTextView.text = record.detail;
            [cell.contentView addSubview:detailTextView];
        }];
    }];
    
    JMStaticContentTableViewSection *section = [self sectionAtIndex:1];
    
    for (NSInteger index = 0; index < record.items.count; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(index + 1) inSection:1];
        RecordItemModel *item = [record.items objectAtIndex:index];
        [section insertCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellHeight = 30.f;
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = item.name;
            cell.detailTextLabel.text = item.price;
        } whenSelected:^(NSIndexPath *indexPath) {
            
        } atIndexPath:indexPath animated:false];
    }
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"关联图片";
        //  section.sectionHeight = 90.f;
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            //  blockself.photoBrowser = [[PhotoBrowserView alloc]initWithFrame:CGRectMake(10, 5, cell.frame.size.width - 20, cell.frame.size.height - 10)];
            // [cell.contentView addSubview:blockself.photoBrowser];
        }];
    }];
}

- (void)loadRecordDetail:(NSString *)recordId {
    [_activity startAnimating];
    SellerModel *seller = [SellerModel sharedClient];
    
    NSDictionary *params = @{@"role":@"seller", @"seller_id":seller.seller_id, @"record_id":self.model.record_id};
    
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    DCArrayMapping *itemsMaping = [DCArrayMapping mapperForClassElements:[RecordItemModel class] forAttribute:@"items" onClass:[RecordDetailModel class]];
    [config addArrayMapper:itemsMaping];
    
    
#if 0
    __block RecordViewController *blockself = self;
    [RCar callService:rcar_api_seller_get_record_detail modelClass:@"RecordDetailModel" config:config params:params success:^(RecordDetailModel *recordDetail) {
        [_activity stopAnimating];
        if (recordDetail.api_result == APIE_OK) {
            [blockself refreshView:recordDetail];
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
        }
        
    } failure:^(NSString *errorStr) {
        [_activity stopAnimating];
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力,请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        
    }];
#endif
}

@end
