//
//  SellerCommodityEditViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 23/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "SellerCommodityViewController.h"
#import "PickerView.h"
#import "PhotoAlbumView.h"
#import "SellerModel.h"
#import "SellerCommodityModel.h"

@interface SellerCommodityViewController ()<MxAlertViewDelegate, PickerViewDelegate>
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextView  *detailTextView;
@property (nonatomic, strong) UITextField *bandTextField;
@property (nonatomic, strong) UITextField *priceTextField;
@property (nonatomic, strong) UITextField *cutoffTextFiled;
@property (nonatomic, strong) UITextField *totalTextField;

@property (nonatomic, strong) PhotoAlbumView *albumView;
@property (nonatomic, assign) BOOL editMode;
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation SellerCommodityViewController{
    UIActivityIndicatorView *_activity;
    SellerModel *_seller;
}

@synthesize model;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"商品详细";
    self.hidesBottomBarWhenPushed = YES;
    self.editMode = false;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editCommodity:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItems = @[rightItem];
    
    _seller = [SellerModel sharedClient];
    
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
    
    __block SellerCommodityViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"商品名称";
            blockself.nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(80, 0,  blockself.tableView.frame.size.width - 80.f, 35.f)];
            blockself.nameTextField.text = blockself.model.name;
            [blockself.nameTextField setEnabled:blockself.editMode];
            blockself.nameTextField.contentMode = UIControlContentVerticalAlignmentCenter;
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
            blockself.bandTextField = [[UITextField alloc]initWithFrame:CGRectMake(80, 0,  blockself.tableView.frame.size.width - 80.f, 35.f)];
            blockself.bandTextField.text = blockself.model.brand;
            [blockself.bandTextField setEnabled:blockself.editMode];
            blockself.bandTextField.contentMode = UIControlContentVerticalAlignmentCenter;
            blockself.bandTextField.font = [UIFont systemFontOfSize:15.f];
            blockself.bandTextField.keyboardType = UIKeyboardTypeAlphabet;
            blockself.bandTextField.returnKeyType = UIReturnKeyDone;
            
            [cell addSubview:blockself.bandTextField];
        }];
        
        
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"商品价格";
            blockself.priceTextField = [[UITextField alloc]initWithFrame:CGRectMake(80, 0,  blockself.tableView.frame.size.width - 80.f, 35.f)];
            blockself.priceTextField.text = blockself.model.price;
            [blockself.priceTextField setEnabled:blockself.editMode];
            blockself.priceTextField.contentMode = UIControlContentVerticalAlignmentCenter;
            blockself.priceTextField.font = [UIFont systemFontOfSize:15.f];
            blockself.priceTextField.keyboardType = UIKeyboardTypeNumberPad;
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
            blockself.cutoffTextFiled.text = blockself.model.cutoff;
            blockself.cutoffTextFiled.keyboardType = UIKeyboardTypeNumberPad;
            blockself.cutoffTextFiled.returnKeyType = UIReturnKeyDone;
            
            [blockself.cutoffTextFiled setEnabled:blockself.editMode];
            
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
            blockself.totalTextField.text = blockself.model.total;
            blockself.totalTextField.keyboardType = UIKeyboardTypeNumberPad;
            blockself.totalTextField.returnKeyType = UIReturnKeyDone;
            
            [blockself.totalTextField setEnabled:blockself.editMode];
            
            [cell addSubview:blockself.totalTextField];
        }];
    }];
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"商品详细";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellHeight = 120.f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            blockself.detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, cell.frame.size.width - 10, 80)];
            blockself.detailTextView.text = blockself.model.detail;
            blockself.detailTextView.font = [UIFont systemFontOfSize:15.f];
            blockself.detailTextView.keyboardType = UIKeyboardTypeAlphabet;
            blockself.detailTextView.returnKeyType = UIReturnKeyDone;
            
            [blockself.detailTextView setEditable:blockself.editMode];
            [cell.contentView addSubview:blockself.detailTextView];
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"商品图片";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellHeight = 90.f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            blockself.albumView = [PhotoAlbumView initWithViewController:blockself frame:cell.frame mode:PhotoAlbumMode_View];
            blockself.albumView.maxOfImage = 4;
            [blockself.albumView loadImages:blockself.model.images];
            [cell.contentView addSubview:blockself.albumView];
        }];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editCommodity:(id)sender {
    UIBarButtonItem *button = sender;
    if ([button.title isEqualToString:@"编辑"]) {
        self.editMode = true;
        button.title = @"取消";
        [self.bandTextField setEnabled:YES];
        [self.nameTextField setEnabled:YES];
        [self.priceTextField setEnabled:YES];
        [self.cutoffTextFiled setEnabled:YES];
        [self.detailTextView setEditable:YES];
        [self.totalTextField setEnabled:YES];
        [self.albumView changeMode:PhotoAlbumMode_Edit];
        __block SellerCommodityViewController *blockself = self;
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
        } atIndex:3];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    if ([self.bandTextField.text isEqualToString:@""]) {
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
    self.model.brand = self.bandTextField.text;
    self.model.total = self.totalTextField.text;
    self.model.detail = self.detailTextView.text;
    
    return true;
}

- (void)submitBtnClicked:(id)sender {
    if (![self checkValidity])
        return;
    [self updateCommodity];
}

- (void)updateCommodity {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary: @{@"role":@"seller", @"seller_id":_seller.seller_id, @"name":self.model.name, @"brand":self.model.brand, @"price":self.model.price, @"desc":self.model.detail, @"amount":self.model.total, @"commodity_id":self.model.commodity_id}];
    
    [params setValue:[NSNumber numberWithInteger:self.albumView.numberOfImage] forKey:@"images"];
    [_activity startAnimating];
    
    __block SellerCommodityViewController *blockself = self;
    [RCar PUT:rcar_api_seller_commodity modelClass:nil config:nil params:params success:^(NSDictionary *reply) {
        [_activity stopAnimating];
        NSString *result = [reply objectForKey:@"api_result"];
        if (result.integerValue == APIE_OK) {
            NSArray *names = [reply objectForKey:@"images"];
            // upload images
            [RCar uploadImage:[blockself.albumView getImageDatasWithJpegCompress:0.5] names:names target:@"seller" success:^(id result) {
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

@end
