//
//  SellerCommentListViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 8/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerCommentListViewController.h"
#import "SellerCommentCell.h"
#import "SellerCommentModel.h"
#import "DataArrayModel.h"

@interface SellerCommentListViewController ()

@end

@implementation SellerCommentListViewController {
    NSMutableArray *_comments;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商家评价";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addComment:)];
    _comments = [[NSMutableArray alloc] init];
    
    [self.tableView registerClass:[SellerCommentCell class] forCellReuseIdentifier:@"SellerCommentCell"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    if (self.model != nil)
        [self loadSellerComment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSellerModel:(SellerInfoModel*) info {
    if (self.model == nil) {
        self.model = info;
        [self loadSellerComment];
    }
}
- (void)loadSellerComment {
    
    NSDictionary *params = @{@"role":@"user", @"name":self.model.seller_id};
    // get advertisement
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[SellerCommentModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    [RCar GET:rcar_api_user_seller_comment_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            NSArray *data = dataModel.data;
            [_comments addObjectsFromArray:data];
            [self.tableView reloadData];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    }failure:^(NSString *errorStr) {
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
        //[self handleLoadError:errorStr];
    }];
    
}

- (void)addComment:(id)sender {
    // 
    
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
    SellerCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellerCommentCell" forIndexPath:indexPath];
    [cell setModel:[_comments objectAtIndex:indexPath.row]];
    
    // Configure the cell...
    
    return cell;
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
