//
//  LocationViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 7/31/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "LocationViewController.h"
#import "ebZoomingScrollView.h"
#import "UIColor+Extensions.h"
static float    bottomWidth = 236;
static float    bottomHeight = 37;

@interface LocationViewController ()
{
    UIView              *uiv_bottomMenu;
    UIView              *uiv_menuIndicator;
    UIImageView         *uiiv_tmpMap;
    NSArray             *arr_mapImageNames;
}

@property (nonatomic, strong) ebZoomingScrollView			*zoomingScroll;

@end

@implementation LocationViewController
#pragma mark - View Controller life-cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareData];
    [self loadZoomingScrollView];
    [self createBottomMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create UI elements and UI data

- (void)prepareData {
    arr_mapImageNames = @[
                          @"grfx_areaMap.jpg",
                          @"grfx_cityMap.jpg",
                          @"grfx_regionalMap.jpg"
                          ];
}

- (void)loadZoomingScrollView {
    
    if (!_zoomingScroll) {
        CGRect theFrame = self.view.bounds;
        _zoomingScroll = [[ebZoomingScrollView alloc] initWithFrame:theFrame image:nil shouldZoom:YES];
        [self.view addSubview:_zoomingScroll];
        _zoomingScroll.backgroundColor = [UIColor clearColor];
        _zoomingScroll.delegate=self;
        _zoomingScroll.blurView.image = [UIImage imageNamed:@"grfx_areaMap.jpg"];
    }
    
    uiiv_tmpMap = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grfx_areaMap.jpg"]];;
    uiiv_tmpMap.frame = self.view.bounds;
    uiiv_tmpMap.alpha = 0.0;
    [self.view addSubview: uiiv_tmpMap];
}

- (void)createBottomMenu {
    uiv_bottomMenu = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - bottomWidth)/2, self.view.frame.size.height - 22 - bottomHeight, bottomWidth, bottomHeight)];
    uiv_bottomMenu.backgroundColor = [UIColor whiteColor];
    uiv_bottomMenu.layer.borderWidth = 1.0;
    uiv_bottomMenu.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview: uiv_bottomMenu];
    
    NSArray *arr_menuTitles = @[
                                @"Area",
                                @"City",
                                @"Regional"
                                ];
    [self createBottomButtons:arr_menuTitles];
}

#pragma mark - UI interation methods

- (void)createBottomButtons:(NSArray *)titles {
    
    CGFloat buttonWidth = 78;
    
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
        button.frame = CGRectMake(1 + i * buttonWidth, 0, buttonWidth, bottomHeight);
        [button setTitle:titles[i] forState: UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        button.tag = i;
        [button addTarget:self action:@selector(tapBottomMenu:) forControlEvents:UIControlEventTouchUpInside];
        [uiv_bottomMenu addSubview: button];
    }
    
    uiv_menuIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, bottomHeight-4, buttonWidth, 4)];
    uiv_menuIndicator.backgroundColor = [UIColor themeRed];
    [uiv_bottomMenu addSubview: uiv_menuIndicator];
}

- (void)tapBottomMenu:(id)sender {
    UIButton *tappedButton = sender;
    CGRect frame = uiv_menuIndicator.frame;
    uiiv_tmpMap.image = [UIImage imageNamed:arr_mapImageNames[tappedButton.tag]];
    [UIView animateWithDuration:0.33 animations:^(void){
        uiv_menuIndicator.frame = CGRectMake(tappedButton.frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        _zoomingScroll.blurView.alpha = 0.0;
        uiiv_tmpMap.alpha = 1.0;
    } completion:^(BOOL finished){
        [_zoomingScroll resetScroll];
        _zoomingScroll.blurView.image = [UIImage imageNamed:arr_mapImageNames[tappedButton.tag]];
        _zoomingScroll.blurView.alpha = 1.0;
        uiiv_tmpMap.alpha = 0.0;
    }];
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
