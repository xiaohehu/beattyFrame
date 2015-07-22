//
//  ViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 7/20/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "ViewController.h"
#import "SummaryViewController.h"

@interface ViewController () {

    SummaryViewController *summary;
}
@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSummary:) name:@"RemoveSummeary" object:nil];
}


- (IBAction)loadSummary:(id)sender {
    
    summary = [[SummaryViewController alloc] init];
    summary.view.frame = self.view.bounds;
    [self addChildViewController: summary];
    [self.view addSubview: summary.view];
}

- (void)removeSummary:(NSNotification *)notification {
    [summary.view removeFromSuperview];
    summary.view = nil;
    [summary removeFromParentViewController];
    summary = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
