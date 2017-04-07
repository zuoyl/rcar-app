//
//  FaultDetailViewController.m
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-21.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import "FaultDetailReportViewController.h"
#import "FaultModel.h"
#import "FaultDetailViewCell.h"
#import "FaultDetailViewCell.h"
#import "KxMenu.h"
#import "PickerView.h"

@interface FaultDetailViewController () < PickerViewDelegate>
@property (nonatomic, strong) NSDictionary *sections;
@end

@implementation FaultDetailViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"故障报告详细";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    
    // clear noused rows
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    
    // right button item
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveFaultItems:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // Do any additional setup after loading the view.
    self.sections = [[NSMutableDictionary alloc] initWithDictionary:[self sectionData]];
    
    
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

- (void)saveFaultItems:(id)sender {
    // get all fault descriptions
    NSMutableArray *decs = [[NSMutableArray alloc] init];
    
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *path in indexPaths) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        if (cell.detailTextLabel.text != nil && ![cell.detailTextLabel.text isEqualToString:@""]) {
            UITableViewHeaderFooterView * section = [self.tableView headerViewForSection:path.section];
            NSString *title = section.textLabel.text;
            title = [title stringByAppendingString:@"-"];
            title = [title stringByAppendingString:cell.textLabel.text];
            title = [title stringByAppendingString:@"-"];
            title = [title stringByAppendingString:cell.detailTextLabel.text];
            [decs addObject:title];
        }
    }
    //
    [self.delegate faultItemSelected:decs];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSDictionary *)sectionData {
    return @{ @"车头":@[
                      @[@"保险杠", @"掉漆", @"变形", @"损坏", @"其他"],
                      @[@"大灯",  @"掉漆", @"变形", @"损坏", @"其他"],
                      @[@"侧灯",  @"掉漆", @"变形", @"损坏", @"其他"],
                      ],
              @"车尾":@[
                      @[@"保险杠", @"掉漆", @"变形", @"损坏", @"其他"],
                      @[@"尾灯",  @"掉漆", @"变形", @"损坏", @"其他"],
                      @[@"侧尾灯",  @"掉漆", @"变形", @"损坏", @"其他"],
                      ],
              @"车身":@[
                      @[@"车门", @"掉漆", @"变形", @"损坏", @"其他"],
                      @[@"轮胎",  @"掉漆", @"变形", @"损坏", @"其他"],
                      ]
              };
}

-(NSInteger) numberOfSections {
    return [self.sections.allKeys count];
}

-(NSString *) nameOfSection:(NSInteger) section {
    return [self.sections.allKeys objectAtIndex:section];
}

-(NSMutableArray *)itemsOfSection:(NSString *)section {
    return [self.sections objectForKey:section];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self nameOfSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionName = [self nameOfSection:section];
    NSMutableArray *datas = [self itemsOfSection:sectionName];
    return [datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kFaultDetailViewCell = @"FaultDetailItemCell";
    // get title
    NSString *sectionName = [self nameOfSection:indexPath.section];
    NSArray *datas = [self itemsOfSection:sectionName];
    NSArray *items = [datas objectAtIndex:indexPath.row];
    NSString *title = [items objectAtIndex:0];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kFaultDetailViewCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kFaultDetailViewCell];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // get title
    NSString *sectionName = [self nameOfSection:indexPath.section];
    NSArray *datas = [self itemsOfSection:sectionName];
    NSArray *items = [datas objectAtIndex:indexPath.row];
    NSArray *details = [items subarrayWithRange:NSMakeRange(1, items.count - 1)];
    
    PickerView *picker = [[PickerView alloc ]initPickviewWithArray:details isHaveNavControler:false];
    picker.delegate = self;
    //[picker setTintColor:[UIColor blueColor]];
    [picker setToolbarTintColor:[UIColor colorWithHex:@"2480ff"]];
    [picker show];
    
}

- (void)detailItemSelected:(id)sender {
    KxMenuItem *item = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = item.title;
}

#pragma mark - PickerViewDelegate
-(void)pickerViewDone:(PickerView *)pickView result:(NSString *)result {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = result;
    
}



@end
