//
//  SummaryViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 7/21/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "SummaryViewController.h"
#import "UIColor+Extensions.h"
#import "ebZoomingScrollView.h"
#import "MasterplanParkingViewController.h"

@interface SummaryViewController () <ebZoomingScrollViewDelegate>
@property (nonatomic, strong) ebZoomingScrollView *zoomingScroll;
@property (nonatomic, strong) MasterplanParkingViewController *mpvc;
@end

@implementation SummaryViewController

#pragma mark - View controller life-cycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)tapCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^(void){
    }];
}

-(IBAction)loadMasterPlan:(id)sender
{
    [self performSegueWithIdentifier:@"MasterplanParkingViewController" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"MasterplanParkingViewController"]){
        MasterplanParkingViewController *vc = [segue destinationViewController];
        vc.index = (int)[sender tag];
    }
}

-(IBAction)loadBrownfield:(id)sender
{
    if (!_zoomingScroll) {
        CGRect theFrame = self.view.bounds;
        _zoomingScroll = [[ebZoomingScrollView alloc] initWithFrame:theFrame image:nil shouldZoom:YES];
        _zoomingScroll.closeBtn = YES;
        [self.view addSubview:_zoomingScroll];
        _zoomingScroll.backgroundColor = [UIColor clearColor];
        _zoomingScroll.delegate=self;
        [self loadInImge:@"brownfield.png"];
    }
}

-(IBAction)loadPark:(id)sender
{
    if (!_zoomingScroll) {
        CGRect theFrame = self.view.bounds;
        _zoomingScroll = [[ebZoomingScrollView alloc] initWithFrame:theFrame image:nil shouldZoom:YES];
        _zoomingScroll.closeBtn = YES;
        [self.view addSubview:_zoomingScroll];
        _zoomingScroll.backgroundColor = [UIColor clearColor];
        _zoomingScroll.delegate=self;
        [self loadInImge:@"parks.jpg"];
    }
}

-(void)loadInImge:(NSString *)imageName
{
    [UIView animateWithDuration:0.0 animations:^{
        _zoomingScroll.blurView.alpha = 0.0;
        _zoomingScroll.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished){
        _zoomingScroll.blurView.image = [UIImage imageNamed:imageName];
        [UIView animateWithDuration:0.3 animations:^{
            _zoomingScroll.blurView.alpha = 1.0;
            _zoomingScroll.transform = CGAffineTransformIdentity;
        }];
    }];
}

-(void)didRemove:(ebZoomingScrollView *)customClass
{
    _zoomingScroll=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
