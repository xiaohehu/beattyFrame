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
    ButtonStack *overlayMenu;
    UIImageView *parcelNames;
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
    [self createButtonStack:1 atFrame:CGRectMake(15, 250, 195, 0) withHeader:@"Overlays"];
    //[self createButtonStack:0 atFrame:CGRectMake(15, 450, 0, 0)];
    
    [self createHeaderViewWithText:@"Overlays" atFrame:CGRectMake(15, 220, 195, 30)];
    //[self createHeaderViewWithText:@"Parking" atFrame:CGRectMake(15, 410, 150, 40)];
    
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        NSLog(@"from summary");
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationItem.title = @"Master Plan Detail";
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [overlayMenu setSelectedButton:_index];
        self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeThisView:)];

    } else {
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
        
        [self createTopButtons];
    }
    
    NSLog(@"index %i",_index);
}

-(void)createHeaderViewWithText:(NSString*)text atFrame:(CGRect)frame
{
    UIView *header = [[UIView alloc] initWithFrame:frame];
    [header setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:header];
    
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectZero];
    [header addSubview:lbl1];
    [lbl1 setFrame:CGRectMake(15, 0, 150, 30)];
    [lbl1 setFont:[UIFont fontWithName:@"GoodPro-Book" size:16.0]];
    lbl1.backgroundColor=[UIColor clearColor];
    lbl1.textColor=[UIColor whiteColor];
    [lbl1 setTextAlignment:NSTextAlignmentLeft];
    lbl1.text= text;
}

- (void)createBGContent {
    if (!_zoomingScroll) {
        CGRect theFrame = self.view.bounds;
        _zoomingScroll = [[ebZoomingScrollView alloc] initWithFrame:theFrame image:nil shouldZoom:YES];
        [self.view addSubview:_zoomingScroll];
        _zoomingScroll.backgroundColor = [UIColor clearColor];
        _zoomingScroll.delegate=self;
        _zoomingScroll.blurView.image = [UIImage imageNamed:@"master-plan-default.png"];
        
        //master-plan-parcel-names.png
        parcelNames = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"master-plan-parcel-names.png"]];
        [_zoomingScroll.blurView insertSubview:parcelNames atIndex:10];
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
-(void)createButtonStack:(int)index atFrame:(CGRect)frame withHeader:(NSString*)text
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
        
        overlayMenu = [[ButtonStack alloc] initWithFrame:CGRectZero];
        overlayMenu.tag = index;
        overlayMenu.delegate = self;
        [overlayMenu setupfromArray:overlayAssets maxWidth:frame];
        [overlayMenu setBackgroundColor:[UIColor whiteColor]];
        overlayMenu.layer.borderWidth = 1;
        overlayMenu.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.view addSubview:overlayMenu];
        
    } else {
        arr_OverlayParkData = menuData[d[index]];
        overlayMenu = [[ButtonStack alloc] initWithFrame:CGRectZero];
        overlayMenu.tag = index;
        overlayMenu.delegate = self;
        [overlayMenu setupfromArray:arr_OverlayParkData maxWidth:frame];
        [overlayMenu setBackgroundColor:[UIColor whiteColor]];
        overlayMenu.layer.borderWidth = 1;
        overlayMenu.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.view addSubview:overlayMenu];
    }
}

- (void)buttonStack:(ButtonStack *)buttonStack selectedIndex:(int)index
{
    UIColor *selectedColor;

    switch (index) {
        case 0:
            selectedColor = [UIColor darkGrayColor];
            break;
        case 1:
            selectedColor = [UIColor colorWithRed:0.42 green:0.7 blue:0.9 alpha:1];
            break;
        case 2:
            selectedColor = [UIColor colorWithRed:0.96 green:0.65 blue:0.14 alpha:1];
            break;
        case 3:
            selectedColor = [UIColor colorWithRed:0.85 green:0.32 blue:0.32 alpha:1];
            break;
        case 4:
            selectedColor = [UIColor colorWithRed:0.55 green:0.4 blue:0.65 alpha:1];
            break;
        default:
            selectedColor = [UIColor colorWithRed:0.5 green:0.64 blue:0.8 alpha:1];
            break;
    }
    
    [buttonStack setSelectedButtonColor:selectedColor];

    
    NSString *imgNm;
    
    if (buttonStack.tag == 1) {
        NSLog(@"park tag %i", index);
        
        imgNm = [arr_OverlayParkData[index] objectForKey:@"overlay"];

        if ( ! overlayAssetParking) {
            overlayAssetParking = [[UIImageView alloc] initWithFrame:_zoomingScroll.frame];
            overlayParkingMenuIndex = -1;
        }
        
        if (index > 4) {
            [_zoomingScroll.blurView insertSubview:overlayAssetParking aboveSubview:parcelNames];
        } else {
            [_zoomingScroll.blurView insertSubview:overlayAssetParking belowSubview:parcelNames];
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
