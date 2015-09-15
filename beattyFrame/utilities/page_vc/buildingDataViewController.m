//
//  buildingDataViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 8/19/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "buildingDataViewController.h"
#import "ebZoomingScrollView.h"
#import "UIColor+Extensions.h"

@interface buildingDataViewController ()

@property (nonatomic, strong) ebZoomingScrollView			*zoomingScroll;
@property (nonatomic, strong) NSDictionary                  *dict;

@end

@implementation buildingDataViewController
@synthesize vcIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dict = self.dataObject;
    [self loadDataAndView];
}

#pragma mark - LAYOUT FLOOR PLAN DATA
-(void)loadDataAndView
{
    if (!_zoomingScroll) {
        CGRect theFrame = self.view.bounds;
        _zoomingScroll = [[ebZoomingScrollView alloc] initWithFrame:theFrame image:nil shouldZoom:YES];
        [self.view addSubview:_zoomingScroll];
        _zoomingScroll.backgroundColor = [UIColor clearColor];
        _zoomingScroll.delegate=self;
    }
    [self loadInImge:_dict[@"buildingImage"]];
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

@end
