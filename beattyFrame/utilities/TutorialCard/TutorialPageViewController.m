//
//  TutorialPageViewController.m
//  embTutorialCard
//
//  Created by Evan Buxton on 9/1/15.
//  Copyright (c) 2015 Evan Buxton. All rights reserved.
//

#import "TutorialPageViewController.h"

@interface TutorialViewController ()

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@end

@implementation TutorialViewController

-(IBAction)popToTableView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"self.dataObject = %@", self.dataObject);

    
    // Set Data
    _tutorial = self.dataObject;
    _uil_Title.text = [self.dataObject objectForKey:@"Title"];
    _uil_Subtitle.text = [self.dataObject objectForKey:@"Subtitle"];
    _uitv_description.text = [self.dataObject objectForKey:@"Description"];
    _uitv_description.textContainer.lineFragmentPadding = 0;
    _uitv_description.textContainerInset = UIEdgeInsetsMake(5, 0, 0, 0);
    [_uitv_description setContentOffset:CGPointZero animated:YES];
    _uil_tip.text = [self.dataObject objectForKey:@"Tip"];

    if ( ! [self.dataObject objectForKey:@"Tip"])
        _uil_note.hidden = YES;
    
    // GIF
    NSString *pathForGif = [[NSBundle mainBundle] pathForResource: [self.dataObject objectForKey:@"GIF"] ofType: @"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile: pathForGif];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:gifData];
    _uiiv_tutorial.animatedImage = image;

    // Icon
    NSString *iconType = [self.dataObject objectForKey:@"Icontype"];
    
    if ([iconType isEqualToString:@"pinch"]) {
        _uiiv_icon.image = [UIImage imageNamed:@"icon_0000.png"];
    } else if ([iconType isEqualToString:@"swipe"]) {
        _uiiv_icon.image = [UIImage imageNamed:@"icon_0003.png"];
    } else if ([iconType isEqualToString:@"tap"]) {
        _uiiv_icon.image = [UIImage imageNamed:@"icon_0002.png"];
    } else if ([iconType isEqualToString:@"drag"]) {
        _uiiv_icon.image = [UIImage imageNamed:@"icon_0001.png"];
    } else if ([iconType isEqualToString:@"doubletap"]) {
        _uiiv_icon.image = [UIImage imageNamed:@"icon_0004.png"];
    }
    
    _uil_numbering.text = [NSString stringWithFormat:@"%ld of %lu",_indexNumber+1,(unsigned long)_pagetotal];

}

@end