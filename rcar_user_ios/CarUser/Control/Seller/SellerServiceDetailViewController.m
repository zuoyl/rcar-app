//
//  SellerServiceListViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 30/11/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerServiceDetailViewController.h"
#import "SellerServiceCell.h"
#import "SSTextView.h"
#import "SellerInfoViewController.h"
#import "ServiceReserveViewController.h"
#import "PhotoAlbumView.h"

@interface SellerServiceDetailViewController () <MxAlertViewDelegate>
@property (nonatomic, retain) PhotoAlbumView *albumView;

@end

@implementation SellerServiceDetailViewController
@synthesize serviceModel;
@synthesize sellerModel;
@synthesize isDisplaySellerInfo;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"服务详细";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.clearsSelectionOnViewWillAppear = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *controller = segue.destinationViewController;
    NSMutableArray *serviceList = [[NSMutableArray alloc]initWithObjects:serviceModel, nil];
    // for ServiceOrderViewController
    if ([controller respondsToSelector:@selector(setServiceList:)]) {
        [controller setValue:serviceList forKey:@"serviceList"];
        [controller setValue:self.sellerModel forKey:@"seller"];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (self.isDisplaySellerInfo == NO) return 1;
    else return  2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.isDisplaySellerInfo == YES) return 3;
    else {
        if (section == 0) return 5;
        else  return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isDisplaySellerInfo == NO) {
        if (indexPath.row == 3 && serviceModel.detail != nil) return 70.f;
        else if (indexPath.row == 4 && self.serviceModel.images.count > 0) return 90.f;
        else return 40.f;
    } else {
       if (indexPath.section == 1 &&
                 indexPath.row == 3 && serviceModel.detail != nil) return 70.f;
        else if (indexPath.section == 1 &&
            indexPath.row == 4 && self.serviceModel.images.count > 0) return 90.f;
        else return 40.f;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.isDisplaySellerInfo == NO) return @"服务信息";
    else {
        if (section == 1) return @"服务信息";
        else if (section == 0) return @"商家信息";
        else return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.isDisplaySellerInfo == NO) return 40.f;
    else {
        if (section == 1) return 40.f;
        else return 5.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = nil;
    if ((self.isDisplaySellerInfo == NO && section == 0) || (section == 1)) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40.f)];
        UIButton *button = [[UIButton alloc]initWithFrame:view.frame];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"预订服务" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithHex:@"2480FF"];
        [button addTarget:self action:@selector(onServiceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"ServiceDetailCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    // create radio button and check box
    if (self.isDisplaySellerInfo == NO || (indexPath.section == 1)) {
            if (indexPath.row == 0) {
                cell.textLabel.text = serviceModel.title;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@", serviceModel.price];
                
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"服务时间";
                cell.detailTextLabel.text = @"不限时间";
                
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"服务车系";
                cell.detailTextLabel.text = @"不限车系";
                
            } else if (indexPath.row == 3) {
                SSTextView *textView = [[SSTextView alloc]initWithFrame:cell.contentView.frame];
                textView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
                [textView setEditable:false];
                [textView setSelectable:false];
                textView.font = [UIFont systemFontOfSize:15.f];
                [cell.contentView addSubview:textView];
                if (serviceModel.detail == nil || ![serviceModel.detail isEqualToString:@""])
                    textView.placeholder = @"该服务没有详细介绍";
                else
                    textView.placeholder = self.serviceModel.detail;
            }  else if (indexPath.row == 4){
                if (self.serviceModel.images != nil && self.serviceModel.images.count > 0) {
                    // there are images for the service
                    if (self.albumView == nil) {
                        self.albumView = [PhotoAlbumView initWithViewController:self frame:cell.contentView.frame mode:PhotoAlbumMode_View];
                        [self.albumView loadImagesFromTarget:self.serviceModel.images target:@"seller"];
                        [cell.contentView addSubview:self.albumView];
                        
                    }
                } else {
                    SSTextView *textView = [[SSTextView alloc]initWithFrame:cell.contentView.frame];
                    textView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
                    [textView setEditable:false];
                    [textView setSelectable:false];
                    textView.font = [UIFont systemFontOfSize:15.f];
                    [cell.contentView addSubview:textView];
                    textView.placeholder = @"该服务没有图片";
                }
            } else {}
    } else {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"商家名称";
                cell.detailTextLabel.text = sellerModel.name;
                cell.accessoryType = UITableViewCellAccessoryNone;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"商家地址";
                cell.detailTextLabel.text = sellerModel.address;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"联系电话";
                cell.detailTextLabel.text = sellerModel.telephone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {}
    }
    return cell;
}

enum {
    AlertReasonCall = 0x400,
    AlertReasonNavi,
};

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
#if 0
    if (indexPath.section == SectionSeller && indexPath.row == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
        SellerInfoViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SellerInfoViewController"];
        controller.sellerId = sellerModel.seller_id;
        [self.navigationController pushViewController:controller animated:YES];
        return;
        
    }
#endif 
    if (self.isDisplaySellerInfo == YES && indexPath.section == 0 && indexPath.row == 1) {
        // call map
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"您要调用外部地图应用吗?" delegate:self cancelButtonTitle:@"调用" otherButtonTitles:@"取消", nil];
        alert.tag = AlertReasonCall;
        [alert show:self];
        return;
    
    } else if (self.isDisplaySellerInfo == YES && indexPath.section == 0 && indexPath.row == 2) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"您要呼叫该商家的联系电话吗?" delegate:self cancelButtonTitle:@"呼叫" otherButtonTitles:@"取消", nil];
        alert.tag = AlertReasonCall;
        [alert show:self];
        return;
    }
}

- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertReasonCall && buttonIndex == 0) {
        // call local telephone book
        NSString *tel = [@"tel://" stringByAppendingString:sellerModel.telephone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
    } else if (alertView.tag == AlertReasonNavi && buttonIndex == 0) {
        NSString *searchQuery =[sellerModel.address stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSString* urlString =[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", searchQuery];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}

- (void)onServiceBtnClicked:(id) sender {
     [self performSegueWithIdentifier:@"ServiceDetailToServiceReserve" sender:self];
    
}



@end
