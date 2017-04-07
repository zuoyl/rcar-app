//
//  SellerCommentListViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 8/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerCommentListViewController.h"
#import "SellerCommentModel.h"
#import "DataArrayModel.h"
#import "SellerModel.h"
#import "SellerCommentCell.h"
#import "MJRefresh.h"
#import "SellerCommentDetailViewController.h"

enum {
    AlertReasonNoComment = 0x10,
};

@interface SellerCommentListViewController () <MxAlertViewDelegate>

@end

@implementation SellerCommentListViewController {
    NSMutableArray *_comments;
    SellerModel *_seller;
    NSInteger _index;
    BOOL _hasMore;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商家评价";
    self.hidesBottomBarWhenPushed = YES;
    //self.navigationController.hidesBottomBarWhenPushed = YES;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    _comments = [[NSMutableArray alloc] init];
    _seller = [SellerModel sharedClient];
    _index = 0;
    _hasMore = false;
    
    [self loadSellerComment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)loadSellerComment {
    
    NSDictionary *params = @{@"role":@"seller", @"seller_id":_seller.seller_id, @"offset":[NSNumber numberWithInteger:_index], @"number":[NSNumber numberWithInteger:10]};
    // get advertisement
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[SellerCommentModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    __block SellerCommentListViewController *blockself = self;
    [RCar GET:rcar_api_seller_comment_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            if (dataModel.data.count > 0 && dataModel.data.count <= 10) {
                [_comments addObjectsFromArray:dataModel.data];
                _index += _comments.count;
                _hasMore = (dataModel.data.count == 10);
                
                [blockself.tableView reloadData];
                [blockself.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
            } else if (dataModel.data.count == 0) {
                _hasMore = false;
                MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"本商家没有网友评价" delegate:blockself cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show:self];
                return;
            }
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
            
        }
    }failure:^(NSString *errorStr) {
        //[self handleLoadError:errorStr];
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力,请稍后测试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identfier = @"SellerCommentCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identfier];
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identfier];
    else {
        for (UIView *view in cell.subviews) {
            [view removeFromSuperview];
        }
    }
    SellerCommentModel *model = [_comments objectAtIndex:indexPath.row];
    if (model.user == nil || [model.user isEqualToString:@""])
        model.user = @"匿名用户";
    
    cell.textLabel.text = model.content;
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@发表于%@", model.user, model.time];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SellerCommentModel *model = [_comments objectAtIndex:indexPath.row];
    CGSize size = [SellerCommentCell sizeOfCommentCell:model];
    return size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    SellerCommentModel *model = [_comments objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
    UIViewController *controler = [storyboard instantiateViewControllerWithIdentifier:@"SellerCommentDetailViewController"];
    if ([controler respondsToSelector:@selector(setModel:)]) {
        [controler setValue:model forKey:@"model"];
    }
    controler.hidesBottomBarWhenPushed = YES;
    [self.navigationController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controler animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5f;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *loadView = nil;
   if (_hasMore) {
        loadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30.f)];
        UIButton *button = [[UIButton alloc]initWithFrame:loadView.frame];
        [button setTitle:@"点击加载更多" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.f];
        button.backgroundColor = [UIColor lightGrayColor];
       [button addTarget:self action:@selector(loadMoreComments:) forControlEvents:UIControlEventTouchUpInside];
        [loadView addSubview:button];
   }
    
    return loadView;
}

-(void)loadMoreComments:(id)sender {
    [self loadSellerComment];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - MxAlertViewDelegate
- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertReasonNoComment) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
