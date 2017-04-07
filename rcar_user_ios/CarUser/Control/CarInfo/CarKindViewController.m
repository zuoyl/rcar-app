//
//  CarKindViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 31/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "CarKindViewController.h"
#import "CarModel.h"
#import "GeneralTableViewCell.h"
#import "DCArrayMapping.h"
#import "DataArrayModel.h"
#import "CarTypeViewController.h"

NSString *const kCarKindViewModeSingle = @"single";
NSString *const kCarKindViewModeMutiply = @"multiply";


@interface CarKindViewController () <MxAlertViewDelegate, CarKindViewDelegate>

@end

@implementation CarKindViewController {
    CarTypeListModel *_carlist;
    NSDictionary *_curCars;
}

@synthesize viewMode;
@synthesize delegate;
@synthesize rootViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"车系选择";
    if(self.viewMode == nil) self.viewMode = kCarKindViewModeSingle;
    
    // display activity indicator
    _carlist = [CarTypeListModel getInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _carlist.cars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"CarKindViewCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    NSDictionary *model = [_carlist.cars objectAtIndex:indexPath.row];
    NSString *icon = [model objectForKey:@"icon"];
    NSString *brand = [model objectForKey:@"brand"];
    
    cell.textLabel.text = brand;
    [cell.imageView setImage:[UIImage imageNamed:icon]];
    [cell.imageView setFrame:CGRectMake(15, 5, 35, 35)];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.hidesBottomBarWhenPushed = YES;
    _curCars = [_carlist.cars objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"SegueCarType" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 
    UIViewController *controller = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"SegueCarType"]) {
        [controller setValue:_curCars forKey:@"cars"];
        [controller setValue:self forKey:@"delegate"];
        [controller setValue:self.viewMode forKey:@"viewMode"];
    }
}


#pragma mark -MxAlertViewDelegate
- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -CarKindViewDelegate
- (void)carKindViewComplete:(NSString *)brand types:(NSArray *)types {
    if (self.delegate) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate carKindViewComplete:brand types:types];
    }
}

@end
