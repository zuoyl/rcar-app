//
//  CarTypeViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 31/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "CarTypeViewController.h"
#import "CarModel.h"
//#import "RegisterModel.h"
#import "SelectionTableViewCell.h"
#import "CarAddViewController.h"

@interface CarTypeViewController ()

@end

@implementation CarTypeViewController {
    NSMutableArray *_regCarList;
}

@synthesize cars;
@synthesize delegate;
@synthesize viewMode;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    if(self.viewMode == nil) self.viewMode = kCarKindViewModeSingle;
    
    if ([self.viewMode isEqualToString:kCarKindViewModeMutiply]) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeSelection:)];
        [leftItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = leftItem;
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(selectAllCars:)];
        [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"车型选择";
    [self.tableView registerClass:[SelectionTableViewCell class] forCellReuseIdentifier:@"SelectionTableViewCell"];
    
    _regCarList = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectAllCars:(id)sender {
    UIBarButtonItem *button = sender;
    BOOL selectAll = true;
    if ([button.title isEqualToString:@"全选"]) {
        button.title = @"取消";
        selectAll = true;
    }
    else {
        button.title = @"全选";
        selectAll = false;
    }
    
    NSMutableArray *list = [self.cars objectForKey:@"cars"];
    
    NSArray *anArrayOfIndexPath = [NSArray arrayWithArray:[self.tableView indexPathsForVisibleRows]];
    for (int index = 0; index < [anArrayOfIndexPath count]; index++) {
        NSIndexPath *indexPath = [anArrayOfIndexPath objectAtIndex:index];
        SelectionTableViewCell *cell = (SelectionTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        
        NSString *carName = [list objectAtIndex:indexPath.row];
        
        if (selectAll) {
            if ([_regCarList containsObject:carName] == false)
                    [_regCarList addObject:carName];
            [cell setChecked:YES];
        } else {
            [_regCarList removeObject:carName];
            [cell setChecked:NO];
        }
    }
}

- (void)completeSelection:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate != nil) {
        NSString *brand = [self.cars objectForKey:@"brand"];
       [self.delegate carKindViewComplete:brand types:_regCarList];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSMutableArray *list = [self.cars objectForKey:@"cars"];
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {;
    static NSString *reuseIdentifier = @"SelectionTableViewCell";
    SelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil)
        cell = [[SelectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableArray *list = [self.cars objectForKey:@"cars"];
    cell.textLabel.text = [list objectAtIndex:indexPath.row];
    
    if ([self.viewMode isEqualToString:kCarKindViewModeSingle])
       [cell hideSelectionImage:YES];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *carList = [self.cars objectForKey:@"cars"];
    NSString *carName = [carList objectAtIndex:indexPath.row];
   
    if ([self.viewMode isEqualToString:kCarKindViewModeSingle]) {
        if (self.delegate != nil) {
            NSString *brand = [self.cars objectForKey:@"brand"];
            [self.delegate carKindViewComplete:brand types:@[carName]];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        if ([_regCarList containsObject:carName] == false) {
            [_regCarList addObject:carName];
        }
        else {
            [_regCarList removeObject:carName];
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


@end
