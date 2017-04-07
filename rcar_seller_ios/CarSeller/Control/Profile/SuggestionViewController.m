//
//  SugesstionViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 29/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "SuggestionViewController.h"
#import "SSTextView.h"
#import "SellerModel.h"

@interface SuggestionViewController ()
@property (nonatomic, strong) SSTextView *contentView;
@end

@implementation SuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = @"意见反馈";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitSuggestion:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    __block SuggestionViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell";
            staticContentCell.cellHeight = 150;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            blockself.contentView = [[SSTextView alloc]initWithFrame:cell.frame];
            blockself.contentView.placeholder = @"请输入您的反馈意见";
            blockself.contentView.font = [UIFont systemFontOfSize:17.f];
            [cell addSubview:blockself.contentView];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (BOOL)checkValidity {
    if (![self.contentView.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"反馈意见没有填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    return true;
}

- (void)submitSuggestion:(id)sender {
    if (![self checkValidity])
        return;
    SellerModel *seller = [SellerModel sharedClient];
    
    NSDictionary *params = @{@"role":@"seller", @"seller_id":seller.seller_id, @"suggestion":self.contentView.text};
    __block SuggestionViewController *blockself = self;
    [RCar POST:rcar_api_seller_suggestion modelClass:@"APIResponseModel" config:nil params:params success:^(APIResponseModel *reply) {
        if (reply.api_result == APIE_OK) {
            [blockself.navigationController popViewControllerAnimated:YES];
            
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
        }
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力,请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        
    }];
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
