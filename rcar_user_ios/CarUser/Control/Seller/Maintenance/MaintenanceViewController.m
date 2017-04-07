//
//  MaintenanceViewController.m
//  CarUser
//
//  Created by jenson.zuo on 12/1/2016.
//  Copyright © 2016 CloudStone Tech. All rights reserved.
//

#import "MaintenanceViewController.h"
#import "HMSegmentedControl.h"
#import "OrderModel.h"
#import "ServiceListViewController.h"

@interface MaintenanceViewController ()
@property (nonatomic, strong) HMSegmentedControl *segmentCtrl;
@property (nonatomic, strong) UIViewController *controller1;
@property (nonatomic, strong) ServiceListViewController *controller2;
@end

@implementation MaintenanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self loadSubviews];
    
    
    self.segmentCtrl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"保养询价", @"直接预约"]];
    self.segmentCtrl.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    [self.segmentCtrl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    self.segmentCtrl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.segmentCtrl.segmentEdgeInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.segmentCtrl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentCtrl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentCtrl.selectionIndicatorColor = [UIColor whiteColor];
    self.segmentCtrl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.segmentCtrl.verticalDividerWidth = 1.0f;
    self.segmentCtrl.selectionIndicatorHeight = 2.f;
    self.segmentCtrl.backgroundColor = [UIColor clearColor];
    
    [self.segmentCtrl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:17.f],NSBackgroundColorAttributeName:[UIColor colorWithHex:@"2480ff"]}];
        return attString;
    }];
    
    
    self.navigationItem.titleView = self.segmentCtrl;
    [self.segmentCtrl setSelectedSegmentIndex:0 animated:YES];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)segmentedControlChangedValue:(id) sender {
    NSInteger index = self.segmentCtrl.selectedSegmentIndex;
    if (index == 0) {
        [self.controller1.view setHidden:NO];
        [self.view bringSubviewToFront:self.controller1.view];
        [self.controller2.view setHidden:YES];
    } else {
        [self.controller2.view setHidden:NO];
        [self.view bringSubviewToFront:self.controller2.view];
        [self.controller1.view setHidden:YES];
    }
}

- (void)loadSubviews {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Maintenance" bundle:nil];
    
    self.controller1 = [storyboard instantiateViewControllerWithIdentifier:@"MTPublicateStep1ViewController"];
    [self addChildViewController:self.controller1];
    [self.view addSubview:self.controller1.view];
    
    storyboard = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
    self.controller2 = [storyboard instantiateViewControllerWithIdentifier:@"ServiceListViewController"];
    [self.controller2 setValue:kServiceType_CarMaintenance forKey:@"type"];
    self.controller2.view.autoresizingMask = UIViewAutoresizingNone;
    
    [self.controller2.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.controller2.isChildController = YES;
    
    [self addChildViewController:self.controller2];
    [self.view addSubview:self.controller2.view];
    
    
    [self.controller1.view setHidden:NO];
    [self.controller2.view setHidden:YES];
}

- (void)refreshSubview {
   // [self.controller1 reloadData:self];
   // [self.controller2 reloadData:self];
}

@end
