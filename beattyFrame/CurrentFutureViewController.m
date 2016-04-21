//
//  SummaryViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 7/21/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "CurrentFutureViewController.h"
#import "UIColor+Extensions.h"

@implementation CurrentFutureViewController

#pragma mark - View controller life-cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    [self createSummaryContent];
    
    UIButton *uib_sectionTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_sectionTitle.backgroundColor = [UIColor themeRed];
    [uib_sectionTitle setTitle:@"Current & Future Tenants" forState:UIControlStateNormal];
    [uib_sectionTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uib_sectionTitle.titleLabel setFont:[UIFont fontWithName:@"GoodPro-Book" size:25.0]];
    [uib_sectionTitle sizeToFit];
    uib_sectionTitle.userInteractionEnabled = NO;
    CGRect frame = uib_sectionTitle.frame;
    frame.size.width += 38;
    uib_sectionTitle.frame = frame;
    [self.view addSubview:uib_sectionTitle];
}

- (void)createSummaryContent {
    UIImageView *uiiv_Summary = [UIImageView new];
    UIImage *summary = [UIImage imageNamed:@"grfx-partners-tenants.png"];
    [uiiv_Summary setImage: summary];
    uiiv_Summary.frame = self.view.bounds;
    [self.view insertSubview: uiiv_Summary atIndex:0];
}

- (IBAction)tapCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^(void){
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
