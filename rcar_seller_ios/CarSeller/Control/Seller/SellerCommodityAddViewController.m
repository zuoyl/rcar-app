//
//  SellerCommodityAddViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 23/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "SellerCommodityAddViewController.h"
#import "PickerView.h"
#import "PhotoAlbumView.h"
#import "SellerModel.h"
#import "SellerCommodityModel.h"

@interface SellerCommodityAddViewController ()<MxAlertViewDelegate, PickerViewDelegate>
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextView  *detailTextView;
@property (nonatomic, strong) UITextField *bandTextFiled;
@property (nonatomic, strong) UITextField *priceTextField;
@property (nonatomic, strong) UITextField *cutoffTextFiled;
@property (nonatomic, strong) UITextField *totalTextField;

@property (nonatomic, strong) PhotoAlbumView *albumView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) SellerCommodityModel *model;

@end


@implementation SellerCommodityAddViewController{
    UIActivityIndicatorView *_activity;
    SellerModel *_seller;
}

@synthesize model;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"添加商品";
    self.hidesBottomBarWhenPushed = YES;
    
    _seller = [SellerModel sharedClient];
    self.model = [[SellerCommodityModel alloc]init];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero] ];
    
    // display activity indicator
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    _activity.backgroundColor = [UIColor grayColor];
    _activity.alpha = 0.5;
    _activity.layer.cornerRadius = 6;
    _activity.layer.masksToBounds = YES;
    [self.view addSubview:_activity];
    
    __block SellerCommodityAddViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"商品名称";
            blockself.nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(80, 0,  blockself.tableView.frame.size.width - 80.f, 35.f)];
            blockself.nameTextField.contentMode = UIControlContentVerticalAlignmentCenter;
            blockself.nameTextField.placeholder = @"请输入商品名称";
            blockself.nameTextField.font = [UIFont systemFontOfSize:15.f];
            blockself.nameTextField.keyboardType = UIKeyboardTypeAlphabet;
            blockself.nameTextField.returnKeyType = UIReturnKeyDone;
            [cell addSubview:blockself.nameTextField];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"商品品牌";
            blockself.bandTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(80, 0,  blockself.tableView.frame.size.width - 80.f, 35.f)];
            blockself.bandTextFiled.placeholder = @"请输入商品品牌";
            blockself.bandTextFiled.contentMode = UIControlContentVerticalAlignmentCenter;
            blockself.bandTextFiled.font = [UIFont systemFontOfSize:15.f];
            blockself.bandTextFiled.keyboardType = UIKeyboardTypeAlphabet;
            blockself.bandTextFiled.returnKeyType = UIReturnKeyDone;
            
            [cell addSubview:blockself.bandTextFiled];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"商品价格";
            blockself.priceTextField = [[UITextField alloc]initWithFrame:CGRectMake(80, 0,  blockself.tableView.frame.size.width - 80.f, 35.f)];
            blockself.priceTextField.placeholder = @"请输入商品价格";
            blockself.priceTextField.contentMode = UIControlContentVerticalAlignmentCenter;
            blockself.priceTextField.font = [UIFont systemFontOfSize:15.f];
            blockself.priceTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            blockself.priceTextField.returnKeyType = UIReturnKeyDone;
            
            [cell addSubview:blockself.priceTextField];
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"商品折扣";
            blockself.cutoffTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(80, 0,  blockself.tableView.frame.size.width - 80.f, 35.f)];
            blockself.cutoffTextFiled.placeholder = @"该商品无折扣";
            blockself.cutoffTextFiled.contentMode = UIControlContentVerticalAlignmentCenter;
            blockself.cutoffTextFiled.font = [UIFont systemFontOfSize:15.f];
            blockself.cutoffTextFiled.keyboardType = UIKeyboardTypePhonePad;
            blockself.cutoffTextFiled.returnKeyType = UIReturnKeyDone;
            
            [cell addSubview:blockself.cutoffTextFiled];
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"商品数量";
            blockself.totalTextField = [[UITextField alloc]initWithFrame:CGRectMake(80, 0,  blockself.tableView.frame.size.width - 80.f, 35.f)];
            blockself.totalTextField.placeholder = @"请输入商品数量";
            blockself.totalTextField.contentMode = UIControlContentVerticalAlignmentCenter;
            blockself.totalTextField.font = [UIFont systemFontOfSize:15.f];
            blockself.totalTextField.keyboardType = UIKeyboardTypeNumberPad;
            blockself.totalTextField.returnKeyType = UIReturnKeyDone;
            
            [cell addSubview:blockself.totalTextField];
        }];

    }];
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"商品详细";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellHeight = 180.f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            blockself.detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, blockself.tableView.frame.size.width, 180.f)];
            blockself.detailTextView.font = [UIFont systemFontOfSize:15.f];
            blockself.detailTextView.keyboardType = UIKeyboardTypeAlphabet;
            blockself.detailTextView.returnKeyType = UIReturnKeyDone;
            [cell.contentView addSubview:blockself.detailTextView];
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"商品图片";
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)checkValidity {
    if ([self.nameTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请填写商品名称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    
    if ([self.priceTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请填写商品价格" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if ([self.bandTextFiled.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请填写商品品牌" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if ([self.totalTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请填写商品数量" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if ([self.detailTextView.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请填写商品详细" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    
    if (self.albumView.numberOfImage == 0) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请添加商品图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    self.model.name = self.nameTextField.text;
    self.model.price = self.priceTextField.text;
    self.model.brand = self.bandTextFiled.text;
    self.model.total = self.totalTextField.text;
    self.model.detail = self.detailTextView.text;
    
    return true;
}


- (void)addCommodity {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary: @{@"role":@"seller", @"seller_id":_seller.seller_id, @"name":self.model.name, @"brand":self.model.brand, @"price":self.model.price, @"desc":self.model.detail, @"amount":self.model.total}];
    
    [params setValue:[NSNumber numberWithInteger:self.albumView.numberOfImage] forKey:@"images"];
    [_activity startAnimating];
    
    __block SellerCommodityAddViewController *blockself = self;
    [RCar POST:rcar_api_seller_commodity modelClass:nil config:nil params:params success:^(NSDictionary *reply) {
        NSString *result = [reply objectForKey:@"api_result"];
        if (result.integerValue == APIE_OK) {
            blockself.model.commodity_id = [reply objectForKey:@"commodity_id"];
            blockself.model.images = [reply objectForKey:@"images"];
            SellerModel *seller = [SellerModel sharedClient];
            [seller.commodities addObject:blockself.model];
            
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
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
        }
        
    } failure:^(NSString *errorStr) {
        [_activity stopAnimating];
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力,请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        
    }];
}

- (void)submitBtnClicked:(id)sender {
    if (![self checkValidity])
        return;
    [self addCommodity];
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
