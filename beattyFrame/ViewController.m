//
//  ViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 7/20/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "ViewController.h"
#import "SummaryViewController.h"
#import "Site360ViewController.h"
#import "GalleryViewController.h"
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
    
//    summary = [[SummaryViewController alloc] init];
//    summary.view.frame = self.view.bounds;
//    [self addChildViewController: summary];
//    [self.view addSubview: summary.view];
    
//    Site360ViewController *site360 = [self.storyboard instantiateViewControllerWithIdentifier:@"Site360ViewController"];
//    site360.view.frame = self.view.bounds;
//    [self addChildViewController: site360];
//    [self.view addSubview: site360.view];
    
    GalleryViewController *gallery = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryViewController"];
    gallery.view.frame = self.view.bounds;
    [self addChildViewController:gallery];
    [self.view addSubview: gallery.view];
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
