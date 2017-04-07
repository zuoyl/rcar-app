//
//  SellerActivityListViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 8/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerActivityListViewController.h"
#import "SellerActivityModel.h"
#import "DataArrayModel.h"
#import "SellerActivityCell.h"
#import "ActivityDetailViewController.h"

@interface SellerActivityListViewController ()
@property (nonatomic, assign) NSInteger offset;

@end

@implementation SellerActivityListViewController {
    NSMutableArray *_activities;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"商家活动";
    
   // [self.tableView registerNib:nib forCellReuseIdentifier:@"SellerActivityCell"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.offset = 0;
    
    _activities = [[NSMutableArray alloc]init];
    if (self.model != nil)
        [self loadSellerActivityList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UIViewController *controller = segue.destinationViewController;
    
    if ([controller respondsToSelector:@selector(setModel:)])
        [controller setValue:[_activities objectAtIndex:indexPath.row] forKey:@"model"];
}

- (void)setSellerModel:(SellerInfoModel*) info {
    if (self.model == nil) {
        self.model = info;
        [self loadSellerActivityList];
    }
}

- (void)loadSellerActivityList {
    
    NSDictionary *params = @{@"role":@"user", @"seller_id":self.model.seller_id, @"num":[NSNumber numberWithInteger:10], @"offset":[NSNumber numberWithInteger:self.offset]};
    // get advertisement
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[SellerActivityModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    [RCar GET:rcar_api_user_seller_activity_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            NSArray *data = dataModel.data;
            [_activities addObjectsFromArray:data];
            [self.tableView reloadData];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    }failure:^(NSString *errorStr) {
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
        //[self handleLoadError:errorStr];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _activities.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"SellerActivityCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    SellerActivityModel *activity = [_activities objectAtIndex:indexPath.row];
    cell.textLabel.text = activity.title;
    cell.detailTextLabel.text = activity.detail;
#if 0
    if (activity.images != nil) {
        [cell.imageView setImageWithURL:[NSURL URLWithString:[RCAR_SERVER stringByAppendingString:model.images]] placeholderImage:[UIImage imageNamed:@"adv_banner"] options:SDWebImageOption success:^(UIImage *image, BOOL cached) {
            if(!cached){    // 非缓存加载时使用渐变动画
                CATransition *transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionFade;
                //[blockImageView.layer addAnimation:transition forKey:nil];
            }
            //    [self.activity stopAnimating];
        } failure:^(NSError *error) {
            NSLog(@"failt to load fault detail images");
            //  [self.activity stopAnimating];
        }];
    }
#endif
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"show_seller_activity_detail" sender:self];
}

@end
