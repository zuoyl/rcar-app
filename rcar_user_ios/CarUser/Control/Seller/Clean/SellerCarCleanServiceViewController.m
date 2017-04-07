//
//  SellerCarCleanServiceViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 17/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerCarCleanServiceViewController.h"

@interface SellerCarCleanServiceViewController ()

@end

@implementation SellerCarCleanServiceViewController {
}
@synthesize model;
@synthesize dateLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"洗车服务";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *controller = [segue destinationViewController];
    self.hidesBottomBarWhenPushed = YES;
    controller.hidesBottomBarWhenPushed = YES;
    if ([controller respondsToSelector:@selector(setModel:)]) {
        [controller setValue:self.model forKey:@"model"];
    }
}


- (IBAction)selectDateBtnTaped:(id)sender {
    NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n";
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"确定", nil];
    [actionsheet showInView:self.view];
    
    UIDatePicker *datepicker = [[UIDatePicker alloc] init];
    datepicker.tag = 101;
    datepicker.datePickerMode = UIDatePickerModeDateAndTime;
    [actionsheet addSubview:datepicker];
}

- (IBAction)continueBtnTaped:(id)sender {
    if (self.model.time == nil) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"提示信息" message:@"您没有选择服务预约时间" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
        
    }
    
    //[self performSegueWithIdentifier:@"service_carclean_contact" sender:self];
}


#pragma mark - UIActionSheetDelegate

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIDatePicker *datePicker = (UIDatePicker *)[actionSheet viewWithTag:101];
    NSDateFormatter *formattor = [[NSDateFormatter alloc] init];
    formattor.dateFormat = @"MM/dd/YY h:mm";
    self.model.time = [formattor stringFromDate:datePicker.date];
    self.dateLabel.text = self.model.time;
}


@end
