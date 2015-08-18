//
//  BuildingViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 8/3/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "BuildingViewController.h"

@interface BuildingViewController ()
{
    UIImageView         *uiiv_bg;
    UIView              *uiv_menuContainer;
    UIView              *uiv_buildingMenu;
    UIView              *uiv_buildingContent;
}
@end

@implementation BuildingViewController

#pragma mark - View Controller Life-cycle

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createMenuContainer];
}

- (void)viewWillAppear:(BOOL)animated {

}

- (void)viewDidAppear:(BOOL)animated {
    for (UIView *view in [self.view subviews]) {
        NSLog(@"\n\n%@\n\n", view);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create UI Elements

- (void)createMenuContainer {
    
    uiiv_bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grfx_building.jpg"]];
    uiiv_bg.frame = self.view.bounds;
    [self.view addSubview: uiiv_bg];
    
    uiv_menuContainer = [UIView new];
    uiv_menuContainer.frame = CGRectMake(571, 28, 360, 390);
    
    uiv_menuContainer.backgroundColor = [UIColor redColor];
    [self.view insertSubview:uiv_menuContainer aboveSubview:uiiv_bg];
    
    uiv_buildingMenu = [UIView new];
    uiv_buildingMenu.frame = CGRectMake(0.0, 0.0, 360, 130);
    uiv_buildingMenu.backgroundColor = [UIColor whiteColor];
    [uiv_menuContainer addSubview:uiv_buildingMenu];
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
