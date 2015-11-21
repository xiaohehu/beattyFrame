//
//  SummaryViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 7/21/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "MasterplanParkingViewController.h"
#import "ebZoomingScrollView.h"
#import "ButtonStack.h"
#import "UIColor+Extensions.h"

@interface MasterplanParkingViewController ()<ButtonStackDelegate>
{
    UIButton                *uib_close;
    ebZoomingScrollView     *uis_zoomSitePlan;
    NSArray                 *arr_OverlayData;
    NSArray                 *arr_OverlayParkData;
    NSDictionary            *menuData;
    UIImageView             *overlayAsset;
    UIImageView             *overlayAssetParking;
    int                     overlayMenuIndex;
    int                     overlayParkingMenuIndex;
}

@property (nonatomic, strong) ebZoomingScrollView			*zoomingScroll;

@end

@implementation MasterplanParkingViewController

#pragma mark - View controller life-cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    [self createBGContent];
    [self prepareData];
    [self createTopButtons];
    [self createButtonStack:1 atFrame:CGRectMake(15, 200, 0, 0)];
    [self createButtonStack:0 atFrame:CGRectMake(15, 450, 0, 0)];
    
    [self createHeaderViewWithText:@"Overlays" atFrame:CGRectMake(15, 160, 150, 40)];
    [self createHeaderViewWithText:@"Parking" atFrame:CGRectMake(15, 410, 150, 40)];
    
    UIButton *uib_sectionTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_sectionTitle.backgroundColor = [UIColor themeRed];
    [uib_sectionTitle setTitle:@"Masterplan" forState:UIControlStateNormal];
    [uib_sectionTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uib_sectionTitle.titleLabel setFont:[UIFont fontWithName:@"GoodPro-Book" size:25.0]];
    [uib_sectionTitle sizeToFit];
    uib_sectionTitle.userInteractionEnabled = NO;
    CGRect frame = uib_sectionTitle.frame;
    frame.size.width += 38;
    uib_sectionTitle.frame = frame;
    [self.view addSubview:uib_sectionTitle];

}

-(void)createHeaderViewWithText:(NSString*)text atFrame:(CGRect)frame
{
    UIView *header = [[UIView alloc] initWithFrame:frame];
    [header setBackgroundColor:[UIColor themeRed]];
    [self.view addSubview:header];
    
    UILabel *lbl1 = [[UILabel alloc] init];
    [lbl1 setFrame:CGRectMake(0, 0, 150, 40)];
    lbl1.backgroundColor=[UIColor clearColor];
    lbl1.textColor=[UIColor whiteColor];
    [lbl1 setTextAlignment:NSTextAlignmentCenter];
    lbl1.text= text;
    [header addSubview:lbl1];
}

- (void)createBGContent {
    if (!_zoomingScroll) {
        CGRect theFrame = self.view.bounds;
        _zoomingScroll = [[ebZoomingScrollView alloc] initWithFrame:theFrame image:nil shouldZoom:YES];
        [self.view addSubview:_zoomingScroll];
        _zoomingScroll.backgroundColor = [UIColor clearColor];
        _zoomingScroll.delegate=self;
        _zoomingScroll.blurView.image = [UIImage imageNamed:@"master-plan-default.png"];
    }
}

- (void)prepareData
{
    NSString *textPath = [[NSBundle mainBundle] pathForResource:@"masterplanstack" ofType:@"json"];
    
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:textPath encoding:NSUTF8StringEncoding error:&error];  //error checking omitted
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    menuData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
}

#pragma mark - menu for overlays
-(void)createButtonStack:(int)index atFrame:(CGRect)frame
{
    NSMutableArray *d = [[NSMutableArray alloc] init];
    for (NSArray *menuAsset in menuData )
    {
        [d addObject:menuAsset];
        NSLog(@"menuasset %@", menuAsset);
    }
    
    if (index == 0) {
        arr_OverlayData = menuData[d[index]];
        NSMutableArray *overlayAssets = [[NSMutableArray alloc] init];
        for ( NSDictionary *menuAsset in arr_OverlayData )
        {
            [overlayAssets addObject:menuAsset[@"name"]];
        }
        
        ButtonStack *overlayMenu = [[ButtonStack alloc] initWithFrame:CGRectZero];
        overlayMenu.tag = index;
        overlayMenu.delegate = self;
        [overlayMenu setupfromArray:overlayAssets maxWidth:frame];
        [overlayMenu setBackgroundColor:[UIColor whiteColor]];
        overlayMenu.layer.borderWidth = 1;
        overlayMenu.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.view addSubview:overlayMenu];
        
    } else {
        arr_OverlayParkData = menuData[d[index]];
        NSMutableArray *overlayAssets = [[NSMutableArray alloc] init];
        for ( NSDictionary *menuAsset in arr_OverlayParkData )
        {
            [overlayAssets addObject:menuAsset[@"name"]];
        }

        ButtonStack *overlayMenu = [[ButtonStack alloc] initWithFrame:CGRectZero];
        overlayMenu.tag = index;
        overlayMenu.delegate = self;
        [overlayMenu setupfromArray:overlayAssets maxWidth:frame];
        [overlayMenu setBackgroundColor:[UIColor whiteColor]];
        overlayMenu.layer.borderWidth = 1;
        overlayMenu.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.view addSubview:overlayMenu];
    }
}

- (void)buttonStack:(ButtonStack *)buttonStack selectedIndex:(int)index
{
    NSString *imgNm;
    
    if (buttonStack.tag == 1) {
        NSLog(@"park tag %li", (long)buttonStack.tag);
        
        imgNm = [arr_OverlayParkData[index] objectForKey:@"overlay"];

        if ( ! overlayAssetParking) {
            overlayAssetParking = [[UIImageView alloc] initWithFrame:_zoomingScroll.frame];
            [_zoomingScroll.blurView addSubview:overlayAssetParking];
            overlayParkingMenuIndex = -1;
        }
        
        if (index != overlayParkingMenuIndex) {
            
            UIImage * toImage = [UIImage imageNamed:imgNm];
            [UIView transitionWithView:self.view
                              duration:0.23f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                overlayAssetParking.image = toImage;
                            } completion:NULL];
            overlayParkingMenuIndex = index;
        } else {
            [self clearParkingOverlayData];
        }

    } else if (buttonStack.tag == 0) {
        NSLog(@"other tag %li", (long)buttonStack.tag);
        imgNm = [arr_OverlayData[index] objectForKey:@"overlay"];

        if ( ! overlayAsset) {
            overlayAsset = [[UIImageView alloc] initWithFrame:_zoomingScroll.frame];
            [_zoomingScroll.blurView addSubview:overlayAsset];
            overlayMenuIndex = -1;
        }
        if (index != overlayMenuIndex) {
            
            UIImage * toImage = [UIImage imageNamed:imgNm];
            [UIView transitionWithView:self.view
                              duration:0.23f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                overlayAsset.image = toImage;
                            } completion:NULL];
            overlayMenuIndex = index;
        } else {
            [self clearOverlayData];
        }
    }
}

-(void)clearParkingOverlayData
{
    [overlayAssetParking removeFromSuperview];
    overlayAssetParking = nil;
    overlayParkingMenuIndex = -1;
}

-(void)clearOverlayData
{
    [overlayAsset removeFromSuperview];
    overlayAsset = nil;
    overlayMenuIndex = -1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create UI elements

- (void)createTopButtons {
    uib_close = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_close.frame = CGRectMake(957, 0, 57, 57);
    [uib_close setImage:[UIImage imageNamed:@"grfx_closeBtn.png"] forState:UIControlStateNormal];
    uib_close.backgroundColor = [UIColor clearColor];
    [uib_close addTarget:self action:@selector(closeThisView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uib_close];
}

- (void)closeThisView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
