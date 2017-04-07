//
//  AboutViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 29/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = @"关于";
    
    __block AboutViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
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
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated {
   self.hidesBottomBarWhenPushed = YES;
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
