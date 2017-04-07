//
//  SellerServiceEditViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 23/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "SellerServiceViewController.h"
#import "PickerView.h"
#import "PhotoAlbumView.h"
#import "SellerModel.h"
#import "SellerServiceModel.h"

@interface SellerServiceViewController () <PickerViewDelegate>
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UITextView *detailTextView;
@property (nonatomic, strong) UITextField *priceTextField;
@property (nonatomic, strong) PhotoAlbumView *albumView;
@property (nonatomic, strong) NSString *serviceTitle;
@property (nonatomic, strong) NSString *serviceType;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, assign) BOOL editMode;

@end

@implementation SellerServiceViewController {
    UIActivityIndicatorView *_activity;
    NSArray *_serviceTypeList;
    
}

@synthesize model;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"服务项目";
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
    self.editMode = false;
    
    // display activity indicator
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    _activity.backgroundColor = [UIColor grayColor];
    _activity.alpha = 0.5;
    _activity.layer.cornerRadius = 6;
    _activity.layer.masksToBounds = YES;
    [self.view addSubview:_activity];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editService:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;

    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    
    __block SellerServiceViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.reuseIdentifier = @"DetailTextCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.textLabel.text = @"服务项目";
            SellerServiceInfoList *serviceList = [SellerServiceInfoList shared];
            
            if ([serviceList.types containsObject:blockself.model.type]) {
                NSInteger index = [serviceList.types indexOfObject:blockself.model.type];
                cell.detailTextLabel.text = [serviceList.types objectAtIndex:index];
            }
        } whenSelected:^(NSIndexPath *indexPath) {
            if (blockself.editMode) {
                SellerServiceInfoList *serviceList = [SellerServiceInfoList shared];
                PickerView *picker = [[PickerView alloc]initPickviewWithArray:serviceList.types isHaveNavControler:false];
                picker.delegate = blockself;
                [picker show];
            }
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"服务项目标题";
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell2";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"标题:";
            blockself.titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, blockself.tableView.frame.size.width - 60, 35.f)];
            blockself.titleTextField.contentMode = UIControlContentVerticalAlignmentCenter;
            blockself.titleTextField.placeholder = @"服务标题";
            blockself.titleTextField.textAlignment = UIControlContentHorizontalAlignmentRight;
            blockself.titleTextField.font = [UIFont systemFontOfSize:15.f];
            blockself.titleTextField.text = blockself.model.title;
            blockself.titleTextField.keyboardType = UIKeyboardTypeAlphabet;
            blockself.titleTextField.returnKeyType = UIReturnKeyDone;
            [blockself.titleTextField setEnabled:blockself.editMode];
            [cell.contentView addSubview:blockself.titleTextField];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell3";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"价格:";
            blockself.priceTextField = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, blockself.tableView.frame.size.width - 75, 35.f)];
            blockself.priceTextField.placeholder = @"服务价格";
            blockself.priceTextField.contentMode = UIControlContentVerticalAlignmentCenter;
            blockself.priceTextField.textAlignment = UIControlContentHorizontalAlignmentRight;
            blockself.priceTextField.font = [UIFont systemFontOfSize:15.f];
            blockself.priceTextField.keyboardType = UIKeyboardTypeNumberPad;
            blockself.priceTextField.returnKeyType = UIReturnKeyDone;
            blockself.priceTextField.text = blockself.model.price;
            [blockself.priceTextField setEnabled:blockself.editMode];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(blockself.tableView.frame.size.width - 20, 0, 20, 35.f)];
            label.font = [UIFont systemFontOfSize:15.f];
            label.text = @"元";
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:blockself.priceTextField];
            
        }];
        
    }];
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"服务详细";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell";
            staticContentCell.cellHeight = 180.f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            blockself.detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width , 180)];
            blockself.detailTextView.text = blockself.model.detail;
            blockself.detailTextView.font = [UIFont systemFontOfSize:15.f];
            blockself.detailTextView.keyboardType = UIKeyboardTypeAlphabet;
            blockself.detailTextView.returnKeyType = UIReturnKeyDone;
            [blockself.detailTextView setEditable:blockself.editMode];
            
            [cell.contentView addSubview:blockself.detailTextView];
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"服务介绍图片(可选)";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell";
            staticContentCell.cellHeight = 90.f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            blockself.albumView = [PhotoAlbumView initWithViewController:blockself frame:CGRectMake(10, 5, cell.frame.size.width - 20, 80) mode:PhotoAlbumMode_View];
            [blockself.albumView loadImages:blockself.model.images];
            blockself.albumView.maxOfImage = 4;
            [cell.contentView addSubview:blockself.albumView];
            if (blockself.model.images == nil || blockself.model.images.count == 0) {
                cell.textLabel.text = @"没有服务介绍图片";
                cell.textLabel.font = [UIFont systemFontOfSize:15.f];
                cell.textLabel.textColor = [UIColor lightGrayColor];
            }
        }];
        if (blockself.editMode) {
            section.sectionFooterHeight = 40.f;
            section.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, blockself.tableView.frame.size.width, 40.f)];
            blockself.submitBtn = [[UIButton alloc]initWithFrame:section.footerView.frame];
            [blockself.submitBtn addTarget:blockself action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [blockself.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
            [blockself.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            blockself.submitBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
            
            blockself.submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
            [section.footerView addSubview:blockself.submitBtn];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editService:(id)sender {
    UIBarButtonItem *button = sender;
    if ([button.title isEqualToString:@"编辑"]) {
        self.editMode = YES;
        button.title = @"取消";
        [self.titleTextField setEnabled:YES];
        [self.detailTextView setEditable:YES];
        [self.priceTextField setEnabled:YES];
        [self.albumView changeMode:PhotoAlbumMode_Edit];
        [self.submitBtn setHidden:NO];
        __block SellerServiceViewController *blockself = self;
        [self insertSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
            //section.title = @"确认后请选择提交";
            section.sectionFooterHeight = 40.f;
            section.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, blockself.tableView.frame.size.width, 40.f)];
            blockself.submitBtn = [[UIButton alloc]initWithFrame:section.footerView.frame];
            [blockself.submitBtn addTarget:blockself action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [blockself.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
            [blockself.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            blockself.submitBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
            
            blockself.submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
            [section.footerView addSubview:blockself.submitBtn];
        } atIndex:4];
        
        // clear text
        NSArray *cells = [self.tableView visibleCells];
        UITableViewCell *cell = [cells objectAtIndex:4];
        cell.textLabel.text = nil;
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)submitBtnClicked:(id)sender {
    if (![self checkValidity])
        return;
    
    self.model.type = self.serviceType;
    self.model.title = self.serviceTitle;
    self.model.price = self.priceTextField.text;
    self.model.detail = self.detailTextView.text;
    
    if (self.delegate != nil) {
        [self.delegate sellerServiceAddCompleted:self.model];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self updateService];
    }
}

- (BOOL)checkValidity {
    if (self.serviceType == nil || [self.serviceType isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有选择服务类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if (self.serviceTitle == nil || [self.serviceTitle isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写服务标题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    return true;
}

- (void)updateService {
    
    [_activity startAnimating];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"role":@"seller", @"seller_id":self.model.seller_id, @"title":self.model.title}];
    if (self.model.detail != nil && ![self.model.detail isEqualToString:@""])
        [params setValue:self.model.detail forKey:@"detail"];
    
    [params setValue:[NSNumber numberWithInteger:self.albumView.numberOfImage] forKey:@"images"];
   
    __block SellerServiceViewController *blockself = self;
    [RCar PUT:rcar_api_seller_service modelClass:nil config:nil params:params success:^(NSDictionary *result) {
        NSString *api_result = [result objectForKey:@"api_result"];
        if (api_result.integerValue == APIE_OK) {
            blockself.model.images = [result objectForKey:@"images"];
            // upload images
            [RCar uploadImage:[blockself.albumView getImageDatasWithJpegCompress:0.5] names:blockself.model.images target:@"seller" success:^(id result) {
                [_activity stopAnimating];
                [blockself.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString *errorStr) {
                [_activity stopAnimating];
                [blockself.navigationController popViewControllerAnimated:YES];
            }];
            [_activity stopAnimating];
        } else {
            [_activity stopAnimating];
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力,请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
        
    }];
}

#pragma mark - PickerViewDelegate
-(void)pickerViewDone:(PickerView *)pickView result:(NSString *)result {
    NSArray *anArrayOfIndexPath = [NSArray arrayWithArray:[self.tableView indexPathsForVisibleRows]];
    NSIndexPath *indexPath = [anArrayOfIndexPath objectAtIndex:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = result;
    self.serviceType = result;
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
