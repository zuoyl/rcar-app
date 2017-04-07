//
//  LaunchViewController.m
//  CarUser
//
//  Created by jenson.zuo on 11/1/2016.
//  Copyright © 2016 CloudStone Tech. All rights reserved.
//

#import "LaunchViewController.h"

#import "MYBlurIntroductionView.h"
#import "MYIntroductionPanel.h"

@interface LaunchViewController ()<MYIntroductionDelegate>

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = TRUE;
    
    [self buildIntro];

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



-(void)buildIntro{
    //Create Stock Panel with header
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:nil description:nil image:[UIImage imageNamed:@"Launch1.jpg"]];
    
    
    //Create Stock Panel With Image
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:nil description:nil image:[UIImage imageNamed:@"Launch2.png"]];

    
    //Add panels to an array
    NSArray *panels = @[panel1, panel2];
    
    //Create the introduction view and set its delegate
    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    introductionView.delegate = self;
    //introductionView.BackgroundImageView.image = [UIImage imageNamed:@"Launch1.jpg"];
    //[introductionView setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:175.0f/255.0f blue:113.0f/255.0f alpha:1]];
    //introductionView.LanguageDirection = MYLanguageDirectionRightToLeft;
    
    //Build the introduction with desired panels
    [introductionView buildIntroductionWithPanels:panels];
    
    //Add the introduction to your view
    [self.view addSubview:introductionView];
}



- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - MYIntroduction Delegate

-(void)introduction:(MYBlurIntroductionView *)introductionView didChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    
#if 0
    //You can edit introduction view properties right from the delegate method!
    //If it is the first panel, change the color to green!
    if (panelIndex == 0) {
        [introductionView setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:175.0f/255.0f blue:113.0f/255.0f alpha:1]];
    }
    //If it is the second panel, change the color to blue!
    else if (panelIndex == 1){
        [introductionView setBackgroundColor:[UIColor colorWithRed:50.0f/255.0f green:79.0f/255.0f blue:133.0f/255.0f alpha:1]];
    }
#endif
}

-(void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType {
    NSLog(@"Introduction did finish");
    [self performSegueWithIdentifier:@"show_main" sender:self];
    
}


@end
