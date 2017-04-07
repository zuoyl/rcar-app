//
//  CitySelectViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 16/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "CitySelectViewController.h"

#define kBarHeight 44.f

@interface CitySelectViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CitySelectViewController {
    NSMutableDictionary *_cities;
    NSMutableArray *_keys; //城市首字母
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择城市";
    
    CGFloat startX = self.navigationController.navigationBar.frame.size.height + 20.f;
    
    // create search bar
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, startX, self.view.frame.size.width, kBarHeight)];
    [self.searchBar setBarTintColor:[UIColor colorWithHex:@"509400"]];
    
    CALayer *layer = [self.searchBar layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:0.0];
    [layer setBorderWidth:1];
    UIColor *color = [UIColor colorWithHex:@"509400"];
    [layer setBorderColor:color.CGColor];
    
    [self.view addSubview:self.searchBar];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, startX + kBarHeight,self.view.frame.size.width, self.view.frame.size.height - (startX + kBarHeight)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"citydict" ofType:@"plist"];
    _cities = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    
    NSMutableArray *arrayHotCity = [NSMutableArray arrayWithObjects:@"广州市",@"北京市",@"天津市",@"西安市",@"重庆市",@"沈阳市",@"青岛市",@"济南市",@"深圳市",@"长沙市",@"无锡市", nil];
    _keys = [[NSMutableArray alloc]initWithArray:[[_cities allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
     NSString *strHot = @"热";
    [_keys insertObject:strHot atIndex:0];
    [_cities setObject:arrayHotCity forKey:strHot];
    
    [self.tableView reloadData];
}

#pragma mark - tableView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    bgView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 250, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    
    NSString *key = [_keys objectAtIndex:section];
    if ([key rangeOfString:@"热"].location != NSNotFound) {
        titleLabel.text = @"热门城市";
    }
    else
        titleLabel.text = key;
    
    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _keys;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [_keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSString *key = [_keys objectAtIndex:section];
    NSArray *citySection = [_cities objectForKey:key];
    return [citySection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CitySelectViewCell";
    
    NSString *key = [_keys objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    cell.textLabel.text = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [_keys objectAtIndex:indexPath.section];
    if ([self.delegate respondsToSelector:@selector(citySelected:)]) {
        [self.delegate citySelected:[[_cities objectForKey:key] objectAtIndex:indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end

