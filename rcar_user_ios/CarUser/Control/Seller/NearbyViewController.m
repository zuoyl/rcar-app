//
//  NearbyViewController.m
//  CarUser
//
//  Created by jenson.zuo on 12/1/2016.
//  Copyright © 2016 CloudStone Tech. All rights reserved.
//

#import "NearbyViewController.h"
#import "HMSegmentedControl.h"
#import "ServiceListViewController.h"
#import "OrderModel.h"

@interface NearbyViewController ()
@property (nonatomic, strong) HMSegmentedControl *segmentCtrl;
@property (nonatomic, strong) NSMutableDictionary *controlers;
@end

@implementation NearbyViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.navigationItem.title = @"周边商家";
    
    self.controlers = [[NSMutableDictionary alloc]init];
    
    ServiceInfoList *serviceList = [ServiceInfoList shared];
    self.segmentCtrl = [[HMSegmentedControl alloc] initWithSectionTitles:serviceList.types];
    self.segmentCtrl.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    [self.segmentCtrl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    self.segmentCtrl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.segmentCtrl.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.segmentCtrl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentCtrl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentCtrl.selectionIndicatorColor = [UIColor whiteColor];
    self.segmentCtrl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.segmentCtrl.selectionIndicatorHeight = 2.f;
    self.segmentCtrl.backgroundColor = [UIColor clearColor];
    
    [self.segmentCtrl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        if (selected) {
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:17.f],NSBackgroundColorAttributeName:[UIColor colorWithHex:@"2480ff"]}];
            return attString;
        } else {
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:15.f],NSBackgroundColorAttributeName:[UIColor colorWithHex:@"2480ff"]}];
            return attString;
        }
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
    ServiceInfoList *serviceList = [ServiceInfoList shared];
    NSString *type = [serviceList.types objectAtIndex:index];
    
    
    ServiceListViewController *controller = [self.controlers objectForKey:type];
    if (controller == nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
        controller = [storyboard instantiateViewControllerWithIdentifier:@"ServiceListViewController"];
        
        [controller setValue:type forKey:@"type"];
        [self.controlers setObject:controller forKey:type];
        controller.isChildController = YES;
        controller.view.autoresizingMask = UIViewAutoresizingNone;
        [controller.view setFrame:CGRectMake(0, 64.f, self.view.frame.size.width, self.view.frame.size.height)];
        [self addChildViewController:controller];
        [self.view addSubview:controller.view];
    }
    [self.view bringSubviewToFront:controller.view];
    
    
    // create view controler
    
}


@end
