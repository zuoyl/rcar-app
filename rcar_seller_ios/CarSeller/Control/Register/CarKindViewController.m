//
//  CarKindViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 31/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "CarKindViewController.h"
#import "DCArrayMapping.h"
#import "DataArrayModel.h"
#import "CarTypeViewController.h"
#import "SelectionTableViewCell.h"

@interface CarKindViewController () <MxAlertViewDelegate>

@end

@implementation CarKindViewController {
    NSMutableArray *_carlist;
    NSDictionary *_curCars;
    NSMutableArray *_selectionCars;
    BOOL _enableMultiSelection;
}

@synthesize delegate;
@synthesize rootController;
@synthesize presetCars;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"车系选择";
    self.hidesBottomBarWhenPushed = YES;
    _selectionCars = [[NSMutableArray alloc]init];
    
    // display activity indicator
    [self.tableView registerClass:[SelectionTableViewCell class] forCellReuseIdentifier:@"SelectionTableViewCell"];
    
    if (self.delegate && [self.delegate onGetCarSelectionMode] == CarSelectionModeMultiply) {
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeSelection:)];
        [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
        _enableMultiSelection = true;
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"cars" ofType:@"plist"];
    _carlist = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    [self.tableView reloadData];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)completeSelection:(id)sender {
    [self.delegate carSelectionCompleted:_selectionCars];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _carlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"SelectionTableViewCell";
    SelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil)
        cell = [[SelectionTableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
   
    // set selection mode
    [cell.checkedImageView setFrame:CGRectMake(self.view.frame.size.width - 40.f, 10, 30, 30)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell enableMultiSelection:_enableMultiSelection];
    
    
    // set accessory indicator
    if (self.delegate && [self.delegate onGetCarSelectionType] == CarSelectionKindWithType)
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
   
    NSDictionary *model = [_carlist objectAtIndex:indexPath.row];
    NSString *brand = [model objectForKey:@"brand"];
    cell.textLabel.text = brand;
    cell.imageView.image = [UIImage imageNamed:[model objectForKey:@"icon"]];
    
    // check wether the car is selected
    if (self.presetCars != nil) {
        for (NSString *car in self.presetCars) {
            if (car != nil && [car isEqualToString:brand]) {
                [cell setSelected:YES];
                [_selectionCars addObject:car];
                break;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *model = [_carlist objectAtIndex:indexPath.row];
    NSString *carName = [model objectForKey:@"brand"];
    SelectionTableViewCell *cell = (SelectionTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    // get selection type
    if (self.delegate && [self.delegate onGetCarSelectionType] == CarSelectionKindOnly) {
        if ([self.delegate onGetCarSelectionMode] == CarSelectionModeMultiply) {
            if (![_selectionCars containsObject:carName]) {
                [_selectionCars addObject:carName];
                [cell setSelected:YES];
            }
            else {
                [_selectionCars removeObject:carName];
                [cell setSelected:NO];
            }
        } else {
            NSString *carkind = [_carlist objectAtIndex:indexPath.row];
            NSArray *result = @[carkind];
            [self.delegate carSelectionCompleted:result];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    } else {
        self.hidesBottomBarWhenPushed = YES;
        _curCars = [_carlist objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"car_type" sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 
    UIViewController *controller = segue.destinationViewController;
    if ([controller respondsToSelector:@selector(setCars:)]) {
        [controller setValue:_curCars forKey:@"cars"];
        [controller setValue:self.rootController forKey:@"rootController"];
        [controller setValue:self.delegate forKey:@"delegate"];
    }
}


#pragma mark -MxAlertViewDelegate
- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
