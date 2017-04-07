//
//  AccusationViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 27/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "AccusationViewController.h"
#import "SellerModel.h"
#import "DCArrayMapping.h"
#import "DataArrayModel.h"
#import "PhotoAlbumView.h"
#import "SellerModel.h"
#import "PhotoAlbumView.h"
#import "AccusationCell.h"
#import "SSTextView.h"

@interface AccusationViewController () <MxAlertViewDelegate>
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UITextView *detailTextView;
@property (nonatomic, strong) SSTextView *replyTextView;
@property (nonatomic, strong) PhotoAlbumView *photoAlbumView;

@end

@implementation AccusationViewController 

@synthesize model;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"处理投诉";
    self.hidesBottomBarWhenPushed = YES;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    __block AccusationViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.reuseIdentifier = @"DetailTextCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"状态";
            if ([blockself.model.status isEqualToString: kAccusationStatusNew])
                cell.detailTextLabel.text = @"新投诉";
            else if ([blockself.model.status isEqualToString:kAccusationStatusCompleted])
                cell.detailTextLabel.text = @"结束";
            else if ([blockself.model.status isEqualToString:kAccusationStatusSystemWait])
                cell.detailTextLabel.text = @"等待系统确认";
            else
                cell.detailTextLabel.text = @"等待商家回复";
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"DetailTextCell2";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.textLabel.text = @"投诉时间";
            cell.detailTextLabel.text = blockself.model.date;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"DetailTextCell3";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.textLabel.text = @"用户";
            cell.detailTextLabel.text = blockself.model.user_id;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"DetailTextCell4";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.textLabel.text = @"概要";
            cell.detailTextLabel.text = blockself.model.title;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"详细内容";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell5";
            staticContentCell.cellHeight = 90.f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            blockself.detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, cell.frame.size.width - 10, 80)];
            blockself.detailTextView.contentInset = UIEdgeInsetsMake(0, 10.f, 0, 10.f);
            blockself.detailTextView.text = blockself.model.detail;
            [blockself.detailTextView setEditable:false];
            blockself.detailTextView.font = [UIFont systemFontOfSize:14.f];
            [cell.contentView addSubview:blockself.detailTextView];
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell6";
            if (blockself.model.images == nil || blockself.model.images.count == 0) {
                cell.textLabel.text = @"该投诉没有图片";
                staticContentCell.cellHeight = 40.f;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                staticContentCell.cellHeight = 90.f;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                if (blockself.photoAlbumView == nil)
                    blockself.photoAlbumView = [PhotoAlbumView initWithViewController:blockself frame:cell.contentView.frame mode:PhotoAlbumMode_View];
                [blockself.photoAlbumView loadImages:blockself.model.images];
                [cell.contentView addSubview:blockself.photoAlbumView];
            }
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"商家回复";
        
        if (blockself.model.replies != nil && blockself.model.replies.count > 0) {
            for (NSInteger i = 0; i < blockself.model.replies.count; i++) {
                [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
                    staticContentCell.reuseIdentifier = @"UIControlCellReply";
                    staticContentCell.cellStyle = UITableViewCellStyleSubtitle;
                    staticContentCell.cellHeight = 45.f;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    NSArray *replies = blockself.model.replies;
                    NSDictionary *reply = [replies objectAtIndex:i];
                    cell.textLabel.text = [reply objectForKey:@"content"];
                    cell.detailTextLabel.text = [reply objectForKey:@"time"];
                    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.f];
                    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                }];
            }
        }
        
        if (![blockself.model.status isEqualToString:kAccusationStatusCompleted]) {
            [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
                staticContentCell.reuseIdentifier = @"UIControlCell6";
                staticContentCell.cellHeight = 90.f;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                blockself.replyTextView = [[SSTextView alloc]initWithFrame:CGRectMake(5, 5, cell.frame.size.width - 10, 80)];
                blockself.replyTextView.contentInset = UIEdgeInsetsMake(0, 10.f, 0, 10.f);
                blockself.replyTextView.font = [UIFont systemFontOfSize:14.f];
                blockself.replyTextView.placeholder = @"请输入商家回复";
                [cell.contentView addSubview:blockself.replyTextView];
            }];
        
            section.sectionFooterHeight = 40.f;
            section.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, blockself.tableView.frame.size.width, 40.f)];
            blockself.submitBtn = [[UIButton alloc]initWithFrame:section.footerView.frame];
            [blockself.submitBtn addTarget:blockself action:@selector(replyAccusation:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)viewDidDisappear:(BOOL)animated {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)replyAccusation:(id)sender {
    if ([self.replyTextView.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请输入投诉反馈意见" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    [self.submitBtn setEnabled:NO];
    
    SellerModel *seller = [SellerModel sharedClient];
   // NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSDateFormatter *formator = [[NSDateFormatter alloc]init];
    [formator setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *replyTime = [formator stringFromDate:[NSDate date]];
    
    
    NSDictionary *params = @{@"role":@"seller", @"accusation_id":self.model.accusation_id, @"seller_id":seller.seller_id, @"time":replyTime, @"content":self.replyTextView.text};
    
    __block AccusationViewController *blockself = self;
    [RCar POST:rcar_api_seller_accusation modelClass:@"APIResponseModel" config:nil params:params success:^(APIResponseModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            [blockself.submitBtn setEnabled:YES];
            // update local reply
           // [blockself.model.replies addObject:@{@"role":@"seller", @"time":replyTime, @"content":blockself.replyTextView.text}];
            [blockself.navigationController popViewControllerAnimated:YES];
        } else {
            [blockself handleError:nil];
            return;
        }
    } failure:^(NSString *errorStr) {
        [blockself handleError:errorStr];
    }];
}

- (void)handleError:(NSString *)error {
    [self.submitBtn setEnabled:YES];
    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误,请检查网络设置" delegate:self cancelButtonTitle:@"重新提交" otherButtonTitles:@"取消", nil];
    [alert show:self];
    return;
}


- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self replyAccusation:self];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
