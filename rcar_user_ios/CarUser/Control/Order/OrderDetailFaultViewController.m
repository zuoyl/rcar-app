//
//  OrderDetailFaultViewController.m
//  CarUser
//
//  Created by jenson.zuo on 10/8/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "OrderDetailFaultViewController.h"

#import "SellerServiceModel.h"
#import "SellerInfoViewController.h"
#import "PhotoAlbumView.h"
enum {
    SectionInfo = 0,
    SectionDetail,
    SectionImages,
    SectionMax,
};

@interface OrderDetailFaultViewController ()

@end

@implementation OrderDetailFaultViewController {
    PhotoAlbumView *_photoAlbumView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _photoAlbumView = [PhotoAlbumView initWithViewController:self frame:CGRectZero mode:PhotoAlbumMode_View];
    _photoAlbumView.maxOfImage = 4;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"show_order_waiting"]) {
        [segue.destinationViewController setValue:self.order.order_id forKey:@"order_id"];
        [segue.destinationViewController setValue:@"maintenance" forKey:@"order_type"];
        [segue.destinationViewController setValue:self forKey:@"rootController"];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return SectionMax;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == SectionInfo) return 5;
    else if (section == SectionDetail) {
        NSArray *items = [self.order.detail objectForKey:@"items"];
        NSString *touser = [self.order.detail objectForKey:@"touser"];
        if ([touser isEqualToString:@"yes"])
            return items.count + 2;
        else
            return items.count + 1;
    }
    else return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionInfo) return 35.f;
    else if (indexPath.section == SectionDetail) return 35.f;
    // else if (indexPath.section == SectionReply) return 60.f;
    else if (indexPath.section == SectionImages) {
        if (self.order.images == nil || self.order.images.count == 0)
            return 40.f;
        else
            return 90.f;
    }
    else return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == SectionImages) return 40.f;
    else return 0.5f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *titles = @[@"订单信息", @"故障项目", @"故障照片"];
    return [titles objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *loadView = nil;
    if (section == SectionImages && ![self.order.status isEqualToString:@"canceled"]) {
        loadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40.f)];
        UIButton *button = [[UIButton alloc]initWithFrame:loadView.frame];
        [button setTitle:@"撤销订单" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        button.backgroundColor = [UIColor colorWithHex:@"2480ff"];
        [button addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [loadView addSubview:button];
    } else if (section == SectionImages && [self.order.status isEqualToString:@"canceled"]) {
        loadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40.f)];
        UIButton *button = [[UIButton alloc]initWithFrame:loadView.frame];
        [button setTitle:@"删除订单" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        button.backgroundColor = [UIColor colorWithHex:@"2480ff"];
        [button addTarget:self action:@selector(delBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [loadView addSubview:button];
    }
    
    return loadView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"itemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
    // Configure the cell...
    switch (indexPath.section) {
        case SectionInfo:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"服务项目";
                cell.detailTextLabel.text = @"故障维修";
                
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"商家名称";
                if ([self.order.status isEqualToString:@"new"]) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"已推送%ld商家", self.order.target_seller.count];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                } else if ([self.order.status isEqualToString:@"selected"] ||
                           [self.order.status isEqualToString:@"completed"]) {
                    cell.detailTextLabel.text = self.order.selected_seller;
                } else {}
                
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"预约时间";
                cell.detailTextLabel.text = self.order.date_time;
            } else if (indexPath.row == 3) {
                cell.textLabel.text = @"订单状态";
                if ([self.order.status isEqualToString:@"new"]) {
                    cell.detailTextLabel.text = @"推送中";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                } else if ([self.order.status isEqualToString:@"completed"])
                    cell.detailTextLabel.text = @"处理完了";
                else if ([self.order.status isEqualToString:@"canceled"])
                    cell.detailTextLabel.text = @"已撤销";
                else
                    cell.detailTextLabel.text = @"处理中";
            } else {
                cell.textLabel.text = @"车牌号";
                cell.detailTextLabel.text = self.order.platenumber;
            }
            break;
            
        case SectionDetail:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"是否出现场维修";
                NSString *touser = [self.order.detail objectForKey:@"touser"];
                if ([touser isEqualToString:@"yes"])
                    cell.detailTextLabel.text = @"出现场";
                else
                    cell.detailTextLabel.text = @"不出现场";
                
            } else {
                NSArray *items = [self.order.detail objectForKey:@"items"];
                NSString *touser = [self.order.detail objectForKey:@"touser"];
                if ([touser isEqualToString:@"yes"]) {
                    if (indexPath.row == 1) {
                        cell.textLabel.text = @"故障位置";
                        cell.detailTextLabel.text = [self.order.detail objectForKey:@"position"];
                        break;
                    } else {
                        NSString *descs = [items objectAtIndex:(indexPath.row - 2)];
                        NSArray *descArray = [descs componentsSeparatedByString:@"-"];
                        cell.textLabel.text = [descArray[0] stringByAppendingString:descArray[1]];
                        cell.detailTextLabel.text = descArray[2];
                    }
                } else {
                    NSString *descs = [items objectAtIndex:(indexPath.row - 1)];
                    NSArray *descArray = [descs componentsSeparatedByString:@"-"];
                    cell.textLabel.text = [descArray[0] stringByAppendingString:descArray[1]];
                    cell.detailTextLabel.text = descArray[2];
                }
            }
            break;
        case SectionImages:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(indexPath.row == 0) {
                if (self.order.images != nil && self.order.images.count > 0) {
                    [_photoAlbumView setFrame:cell.contentView.frame];
                    [cell.contentView addSubview:_photoAlbumView];
                    [_photoAlbumView loadImagesFromTarget:self.order.images target:@"user"];
                } else {
                    cell.textLabel.text = @"没有车辆故障照片";
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                }
            }
            
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionInfo && (indexPath.row == 1 || indexPath.row == 3)) {
        if ([self.order.status isEqualToString:@"new"])
            [self performSegueWithIdentifier:@"show_order_waiting" sender:self];
    }
}
@end
