//
//  ProblemsViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 29/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "ProblemsViewController.h"

@interface ProblemsViewController ()
@property (nonatomic, strong) NSMutableArray *questions;
@property (nonatomic, strong) NSMutableArray *shows;

@end

@implementation ProblemsViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = @"常见问题";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"];
    self.questions = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    self.shows = [[NSMutableArray alloc]initWithCapacity:self.questions.count];
    for (int index = 0; index < self.questions.count; index++)
        self.shows[index] = @"NO";
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
  }

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.questions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ([self.shows[section] isEqualToString:@"YES"])
        return 1;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    NSDictionary *item  = [self.questions objectAtIndex:indexPath.section];
    cell.textLabel.text = [item objectForKey:@"answer"];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 20.f)];
    footerView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 0.f, self.view.frame.size.width, 20.f)];
    NSDictionary *item  = [self.questions objectAtIndex:section];
    label.text = [@"Q:" stringByAppendingString: [item objectForKey:@"question"]];
    
    label.font = [UIFont systemFontOfSize:15.f];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionLabelClicked:)];
    [label addGestureRecognizer:gesture];
    label.tag = section;
    
    [footerView addSubview:label];
    return footerView;
}

- (CGSize)contentCellHeightWithText:(NSString*)text font:(UIFont *)font {
    //设置字体
    CGSize size = CGSizeMake(self.view.frame.size.width, 20000.0f);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    return size;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item  = [self.questions objectAtIndex:indexPath.section];
    NSString *text = [item objectForKey:@"question"];
    UIFont *font = [UIFont systemFontOfSize:17.f];
    return [self contentCellHeightWithText:text font:font].height;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.hidesBottomBarWhenPushed = YES;
}

- (void)sectionLabelClicked:(UITapGestureRecognizer *)tap {
    NSInteger section = tap.view.tag;
    if ([self.shows[section] isEqualToString:@"YES"]) self.shows[section] = @"NO";
    else self.shows[section] = @"YES";
    
    [self.tableView reloadData];
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
