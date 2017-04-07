//
//  RecordSearchResultViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 28/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "RecordSearchResultViewController.h"
#import "RecordItemCell.h"
#import "RecordSearchSetViewController.h"
#import "DCArrayMapping.h"
#import "DataArrayModel.h"
#import "SellerModel.h"

@interface RecordSearchResultViewController ()

@end

@implementation RecordSearchResultViewController

@synthesize records;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"检索结果";
    self.hidesBottomBarWhenPushed = YES;
    // initialize tableview
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    
    [self.tableView registerClass:[RecordItemCell class] forCellReuseIdentifier:@"RecordItemCell"];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnRecordList:)];
    [leftItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)returnRecordList:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath != nil) {
        RecordModel *record = [self.records objectAtIndex:indexPath.row];
        
        UIViewController *controller = segue.destinationViewController;
        if ([controller respondsToSelector:@selector(setModel:)])
            [controller setValue:record  forKey:@"model"];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.records.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"RecordItemCell";
    RecordItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[RecordItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setModel:self.records[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordModel *record = [self.records objectAtIndex:indexPath.row];
    if (!record.record_id || ![record.record_id isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"不能取得记录详细信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    [self performSegueWithIdentifier:@"record_view" sender:self];
}



@end
