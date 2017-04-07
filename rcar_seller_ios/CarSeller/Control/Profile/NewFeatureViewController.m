//
//  NewFeatureViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 29/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "MYBlurIntroductionView.h"

#import "MYIntroductionPanel.h"

@interface NewFeatureViewController () <MYIntroductionDelegate>
@end

@implementation NewFeatureViewController {
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = @"新功能介绍";
    NSMutableArray *panels = [[NSMutableArray alloc]init];
    
    MYIntroductionPanel *panel = [[MYIntroductionPanel alloc]initWithFrame:self.view.frame  title:nil description:nil image:[UIImage imageNamed:@"001"]];
    [panels addObject:panel];
    panel = [[MYIntroductionPanel alloc]initWithFrame:self.view.frame  title:nil description:nil image:[UIImage imageNamed:@"002"]];
    
    [panels addObject:panel];
    panel = [[MYIntroductionPanel alloc]initWithFrame:self.view.frame  title:nil description:nil image:[UIImage imageNamed:@"003"]];
    [panels addObject:panel];
    panel = [[MYIntroductionPanel alloc]initWithFrame:self.view.frame  title:nil description:nil image:[UIImage imageNamed:@"004"]];
    [panels addObject:panel];
    
    //Create the introduction view and set its delegate
    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    introductionView.delegate = self;
    introductionView.BackgroundImageView.image = [UIImage imageNamed:@"Toronto, ON.jpg"];
    //introductionView.LanguageDirection = MYLanguageDirectionRightToLeft;
    
    //Build the introduction with desired panels
    [introductionView buildIntroductionWithPanels:panels];
    
    //Add the introduction to your view
    [self.view addSubview:introductionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma  mark - MyIntroductionViewDelegate
-(void)introductionDidFinishWithType:(MYFinishType)finishType {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
