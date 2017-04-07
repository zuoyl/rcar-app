//
//  ProfileViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 22/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "ProfileViewController.h"
#import "SellerModel.h"

enum {
    Tag_UserTextField = 100,
    Tag_CityTextField,
    Tag_AddressTextField,
    Tag_PhoneTextField,
    Tag_LocationTextField,
    Tag_CarsTextField,
    Tag_ServiceStartTextField,
    Tag_ServiceEndTextField,
    Tag_ServiceStartPicker,
    Tag_ServiceEndPicker,
};

@interface ProfileViewController ()<UITextFieldDelegate>
@end

@implementation ProfileViewController {
    
}


- (id) init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) return nil;
    
    return self;
}

#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = @"我的";
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
    
    
    __block ProfileViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.sectionHeight = 0.f;
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            SellerModel *seller = [SellerModel sharedClient];
            cell.textLabel.text = [NSString stringWithFormat:@"商家:%@", seller.name];
            cell.detailTextLabel.text = seller.telephone;
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
        } whenSelected:^(NSIndexPath *indexPath) {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
            UIViewController *controller = [story instantiateViewControllerWithIdentifier:@"SellerInfoView"];
            blockself.hidesBottomBarWhenPushed = YES;
            [blockself.navigationController pushViewController:controller animated:YES];
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"系统消息";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
        } whenSelected:^(NSIndexPath *indexPath) {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
            UIViewController *controller = [story instantiateViewControllerWithIdentifier:@"ProfileSystemMsgView"];
            blockself.hidesBottomBarWhenPushed = YES;
            [blockself.navigationController pushViewController:controller animated:YES];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"设置";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
        } whenSelected:^(NSIndexPath *indexPath) {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
            UIViewController *controller = [story instantiateViewControllerWithIdentifier:@"ProfileSetupView"];
            blockself.hidesBottomBarWhenPushed = YES;
            [blockself.navigationController pushViewController:controller animated:YES];
        }];
    }];
    
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"升级新版本";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
        } whenSelected:^(NSIndexPath *indexPath) {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
            UIViewController *controller = [story instantiateViewControllerWithIdentifier:@"AboutNewVersionView"];
            blockself.hidesBottomBarWhenPushed = YES;
            [blockself.navigationController pushViewController:controller animated:YES];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"新功能介绍";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
        } whenSelected:^(NSIndexPath *indexPath) {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
            UIViewController *controller = [story instantiateViewControllerWithIdentifier:@"AboutNewFeatureView"];
            blockself.hidesBottomBarWhenPushed = YES;
            [blockself.navigationController pushViewController:controller animated:YES];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"常见问题";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
        } whenSelected:^(NSIndexPath *indexPath) {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
            UIViewController *controller = [story instantiateViewControllerWithIdentifier:@"AboutProblemsView"];
            blockself.hidesBottomBarWhenPushed = YES;
            [blockself.navigationController pushViewController:controller animated:YES];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"意见反馈";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
        } whenSelected:^(NSIndexPath *indexPath) {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
            UIViewController *controller = [story instantiateViewControllerWithIdentifier:@"AboutSuggestionView"];
            blockself.hidesBottomBarWhenPushed = YES;
            [blockself.navigationController pushViewController:controller animated:YES];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"推荐给好友";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
        } whenSelected:^(NSIndexPath *indexPath) {
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"关于";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
        } whenSelected:^(NSIndexPath *indexPath) {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
            UIViewController *controller = [story instantiateViewControllerWithIdentifier:@"ProfileAboutView"];
            blockself.hidesBottomBarWhenPushed = YES;
            [blockself.navigationController pushViewController:controller animated:YES];
        }];
        
        
    }];
    
}
- (void) viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
