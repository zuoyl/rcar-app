//
//  FaultDetailRecordViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 25/11/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "FaultDetailRecordViewController.h"
#import "FaultDetailModel.h"
#import "UserModel.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "CSImageView.h"

#define Image_Base_Tag 1000

@interface FaultDetailRecordViewController ()

@end

@implementation FaultDetailRecordViewController {
    NSInteger _curPage;
    NSMutableArray *_imagePages;
    FaultDetailModel *_faultDetailModel;
    UIActivityIndicatorView *_activity;
    PhotoAlbumView *_PhotoAlbumView;
}
@synthesize order_id;
@synthesize activity;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"详细故障记录";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    
    [self.activity startAnimating];
    
    _curPage = 0;
    _imagePages = [[NSMutableArray alloc] init];
    _faultDetailModel = nil;
    
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[indexPaths objectAtIndex:7]];
    
    
    _PhotoAlbumView = [PhotoAlbumView initWithViewController:self frame:cell.contentView.frame mode:PhotoAlbumMode_View];
    [cell.contentView addSubview:_PhotoAlbumView];
    [self loadFaultDetailRecordInfo];
}

- (void)loadFaultDetailRecordInfo {
    // call rcar service to get fault detail info
    NSDictionary *params = @{@"role":@"user", @"order_id":self.order_id};
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    DCObjectMapping *imagesMaping = [DCObjectMapping mapKeyPath:@"images" toAttribute:@"images" onClass:[FaultDetailModel class]];
    [config addObjectMapping:imagesMaping];
#if 0
    [RCar callService:rcar_api_user_get_fault_info modelClass:@"FaultDetailModel" config:config params:params success:^(FaultDetailModel *model) {
        if (model.api_result == APIE_OK) {
            _faultDetailModel = model;
            [self refreshView];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    } failure:^(NSString *errorStr) {
        [self.activity stopAnimating];
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
#endif
}

- (void)refreshView {
    // update record details
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[indexPaths objectAtIndex:0]];
    
    // seller name
    cell.detailTextLabel.text = _faultDetailModel.seller;
    
    // date
    cell = [self.tableView cellForRowAtIndexPath:[indexPaths objectAtIndex:1]];
    cell.detailTextLabel.text = _faultDetailModel.date;
    
    // insurance
    cell = [self.tableView cellForRowAtIndexPath:[indexPaths objectAtIndex:2]];
    cell.detailTextLabel.text = _faultDetailModel.insurance;
    
    // insruance man
    cell = [self.tableView cellForRowAtIndexPath:[indexPaths objectAtIndex:3]];
    cell.detailTextLabel.text = _faultDetailModel.insurance_man;
    
    // repair man
    cell = [self.tableView cellForRowAtIndexPath:[indexPaths objectAtIndex:4]];
    cell.detailTextLabel.text = _faultDetailModel.repair;
    
    // estimation
    cell = [self.tableView cellForRowAtIndexPath:[indexPaths objectAtIndex:5]];
    cell.detailTextLabel.text = _faultDetailModel.estimate;
    
    // cost
    cell = [self.tableView cellForRowAtIndexPath:[indexPaths objectAtIndex:6]];
    cell.detailTextLabel.text = _faultDetailModel.cost;
    
    // load images
    [_PhotoAlbumView loadImagesFromTarget:_faultDetailModel.images target:@"user"];
    [self.activity stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
