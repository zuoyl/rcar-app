//
//  SellerServiceAddViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 23/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "SellerServiceAddViewController.h"
#import "PickerView.h"
#import "PhotoAlbumView.h"
#import "SellerServiceModel.h"
#import "SellerModel.h"
#import "SWTableViewCell.h"
#import "SSTextView.h"

@interface SellerServiceAddViewController () <PickerViewDelegate>
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) SSTextView *detailTextView;
@property (nonatomic, strong) UITextField *priceTextField;
@property (nonatomic, strong) PhotoAlbumView *albumView;
@property (nonatomic, strong) NSString *serviceTitle;
@property (nonatomic, strong) NSString *serviceType;
@property (nonatomic, strong) SellerServiceModel *model;
@property (nonatomic, strong) UIButton *submitBtn;

@end


@implementation SellerServiceAddViewController {
    SellerServiceInfoList *_serviceList;;
    UIActivityIndicatorView *_activity;
    
}

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"添加服务";
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
    
    self.model = [[SellerServiceModel alloc]init];
    
    
    __block SellerServiceAddViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.reuseIdentifier = @"DetailTextCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.textLabel.text = @"选择服务项目";
        } whenSelected:^(NSIndexPath *indexPath) {
              SellerServiceInfoList *serviceList = [SellerServiceInfoList shared];
            PickerView *picker = [[PickerView alloc]initPickviewWithArray:serviceList.types isHaveNavControler:false];
            picker.delegate = blockself;
            [picker show];
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"服务详细内容";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell2";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"标题:";
            if (blockself.titleTextField == nil)
                blockself.titleTextField = [[SSTextView alloc]initWithFrame:CGRectMake(50, 0, blockself.tableView.frame.size.width - 60, 35.f)];
            blockself.titleTextField.contentMode = UIControlContentVerticalAlignmentCenter;
            blockself.titleTextField.placeholder = @"服务标题";
            blockself.titleTextField.textAlignment = UIControlContentHorizontalAlignmentRight;
            blockself.titleTextField.font = [UIFont systemFontOfSize:15.f];
            if (blockself.model.title == nil)
                blockself.titleTextField.placeholder = @"填写服务标题";
            else
                blockself.titleTextField.text = blockself.model.title;
            blockself.titleTextField.keyboardType = UIKeyboardTypeAlphabet;
            blockself.titleTextField.returnKeyType = UIReturnKeyDone;
            [cell.contentView addSubview:blockself.titleTextField];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell3";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"价格:";
            if (blockself.priceTextField == nil)
                blockself.priceTextField = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, blockself.tableView.frame.size.width - 75, 35.f)];
            blockself.priceTextField.placeholder = @"服务价格";
            blockself.priceTextField.contentMode = UIControlContentVerticalAlignmentCenter;
            blockself.priceTextField.textAlignment = UIControlContentHorizontalAlignmentRight;
            blockself.priceTextField.font = [UIFont systemFontOfSize:15.f];
            blockself.priceTextField.keyboardType = UIKeyboardTypeNumberPad;
            blockself.priceTextField.returnKeyType = UIReturnKeyDone;
            if (blockself.model.price == nil)
                blockself.priceTextField.placeholder = @"填写服务价格";
            else
                blockself.priceTextField.text = blockself.model.price;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(blockself.tableView.frame.size.width - 20, 0, 20, 35.f)];
            label.font = [UIFont systemFontOfSize:15.f];
            label.text = @"元";
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:blockself.priceTextField];
        }];
    }];
    
    
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"服务详细介绍";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell";
            staticContentCell.cellHeight = 180.f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (blockself.detailTextView == nil)
                blockself.detailTextView = [[SSTextView alloc]initWithFrame:CGRectMake(0, 0, blockself.tableView.frame.size.width, 180)];
            blockself.detailTextView.font = [UIFont systemFontOfSize:15.f];
            blockself.detailTextView.contentInset = UIEdgeInsetsMake(0, 10.f, 0, 10.f);
            blockself.detailTextView.keyboardType = UIKeyboardTypeAlphabet;
            blockself.detailTextView.returnKeyType = UIReturnKeyDone;
            if (blockself.model.detail == nil)
                blockself.detailTextView.placeholder = @"填写服务详细介绍";
            else
                blockself.detailTextView.text = blockself.model.detail;
            
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
            blockself.albumView = [PhotoAlbumView initWithViewController:blockself frame:CGRectMake(10, 5, cell.frame.size.width - 20, 80) mode:PhotoAlbumMode_Edit];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
 }

- (void)submitBtnClicked:(id)sender {
    
    self.serviceTitle = self.titleTextField.text;
    if (self.serviceType == nil || [self.serviceType isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有选择服务类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    if (self.serviceTitle == nil || [self.serviceTitle isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写服务标题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    
    if ([self.priceTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写服务价格" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    if ([self.detailTextView.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写服务详细" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    
    
    SellerModel *seller = [SellerModel sharedClient];
    self.model.title = self.titleTextField.text;
    self.model.type = self.serviceType;
    self.model.detail = self.detailTextView.text;
    self.model.seller_id = seller.seller_id;
    //self.model.images = self.albumView.images;
    self.model.detail = self.detailTextView.text;
    self.model.price = self.priceTextField.text;

    if (self.delegate != nil) {
        [self.delegate sellerServiceAddCompleted:self.model];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self addService:self.model];
    }
}

- (void)addService:(SellerServiceModel *)model {
    
    [_activity startAnimating];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"role":@"seller", @"seller_id":model.seller_id, @"type":model.type, @"title":model.title, @"detail":model.detail, @"price":model.price}];
    if (model.detail != nil && ![model.detail isEqualToString:@""])
        [params setValue:model.detail forKey:@"detail"];
    
    [params setValue:[NSNumber numberWithInteger:self.albumView.numberOfImage] forKey:@"images"];
    
    __block SellerServiceAddViewController *blockself = self;
    
    [RCar POST:rcar_api_seller_service modelClass:nil config:nil params:params success:^(NSDictionary *result) {
        NSString *api_result = [result objectForKey:@"api_result"];
        if (api_result.integerValue == APIE_OK) {
            blockself.model.service_id = [result objectForKey:@"service_id"];
            blockself.model.images = [result objectForKey:@"images"];
        
            SellerModel *seller = [SellerModel sharedClient];
            [seller.services addObject:blockself.model];
            
            // upload images
            [RCar uploadImage:[blockself.albumView getImageDatasWithJpegCompress:0.5] names:blockself.model.images target:@"seller" success:^(id result) {
                [_activity stopAnimating];
                [blockself.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString *errorStr) {
                [_activity stopAnimating];
                [blockself.navigationController popViewControllerAnimated:YES];
            }];
            
            [_activity stopAnimating];
            [blockself.navigationController popViewControllerAnimated:YES];
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
