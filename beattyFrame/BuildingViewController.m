//
//  BuildingViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 8/3/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "BuildingViewController.h"

@interface BuildingViewController ()

@end

@implementation BuildingViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapCloseButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeBuilding" object:nil];
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
