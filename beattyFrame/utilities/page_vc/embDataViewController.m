//
//  embDataViewController.m
//  Example
//
//  Created by Evan Buxton on 11/23/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import "embDataViewController.h"
#import "ebZoomingScrollView.h"
#import "UIColor+Extensions.h"
#import "animationView.h"
//#import "motionImageViewController.h"

#define animationIndex  6

@interface embDataViewController () {

}

@property (nonatomic, strong) ebZoomingScrollView			*zoomingScroll;
@property (nonatomic, strong) NSDictionary                  *dict;


@end

@implementation embDataViewController
@synthesize vcIndex;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _dict = self.dataObject;
    [self loadDataAndView];
}

#pragma mark - LAYOUT FLOOR PLAN DATA
-(void)loadDataAndView
{
    if (vcIndex == animationIndex) { // Load the animated grids view
        animationView *animation = [[animationView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview: animation];
    } else {
        
        if (!_zoomingScroll) {
            CGRect theFrame = self.view.bounds;
            _zoomingScroll = [[ebZoomingScrollView alloc] initWithFrame:theFrame image:nil shouldZoom:YES];
            [self.view addSubview:_zoomingScroll];
            _zoomingScroll.backgroundColor = [UIColor clearColor];
            _zoomingScroll.delegate=self;
        }
        [self loadInImge:_dict[@"image"]];
        
    }

}

-(void)loadInImge:(NSString *)imageName
{
    [UIView animateWithDuration:0.0 animations:^{
        _zoomingScroll.blurView.alpha = 0.0;
    } completion:^(BOOL finished){
        _zoomingScroll.blurView.image = [UIImage imageNamed:imageName];
        [UIView animateWithDuration:0.3 animations:^{
            _zoomingScroll.blurView.alpha = 1.0;
        }];
    }];
}

#pragma mark - BOILERPLATE
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{

}

- (void)viewDidDisappear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
