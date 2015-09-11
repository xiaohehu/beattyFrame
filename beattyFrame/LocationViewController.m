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
#import "ButtonStack.h"
static float    bottomWidth = 236;
static float    bottomHeight = 37;

@interface LocationViewController () <ButtonStackDelegate>
{
    UIView              *uiv_bottomMenu;
    UIView              *uiv_menuIndicator;
    UIImageView         *uiiv_tmpMap;
    NSArray             *arr_mapImageNames;
    
    ButtonStack         *overlayMenu;
    UIImageView         *overlayAsset;
    int                 overlayMenuIndex;
    NSArray             *arr_OverlayData;
    NSDictionary        *menuData;
}

@property (nonatomic, strong) ebZoomingScrollView			*zoomingScroll;

@end

@implementation LocationViewController

#warning Make sure the hotspot's tag > 100 to keep their size while the map is zoomed!!!!!!

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
                          @"grfx_areaMap_base_map.png",
                          @"grfx-city-base-map.png",
                          @"grfx_regionalMap_base_map.png"
                          ];
    
    NSString *textPath = [[NSBundle mainBundle] pathForResource:@"buttonstack" ofType:@"json"];
    
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:textPath encoding:NSUTF8StringEncoding error:&error];  //error checking omitted
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    menuData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
}

#pragma mark - menu for overlays
-(void)createButtonStack:(int)index
{
    NSMutableArray *d = [[NSMutableArray alloc] init];
    for (NSArray *menuAsset in menuData )
    {
        [d addObject:menuAsset];
        NSLog(@"%@", menuAsset);
    }
    // sort them alphabetically
    [d sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    arr_OverlayData = menuData[d[index]];
    
    NSMutableArray *overlayAssets = [[NSMutableArray alloc] init];
    for ( NSDictionary *menuAsset in arr_OverlayData )
    {
        [overlayAssets addObject:menuAsset[@"name"]];
    }

    if (overlayMenu) {
        [overlayMenu removeFromSuperview];
    }
    
    overlayMenu = [[ButtonStack alloc] initWithFrame:CGRectZero];
    overlayMenu.delegate = self;
    [overlayMenu setupfromArray:overlayAssets maxWidth:300];
    [overlayMenu setBackgroundColor:[UIColor whiteColor]];
    overlayMenu.layer.borderWidth = 1;
    overlayMenu.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:overlayMenu];
}

- (void)buttonStack:(ButtonStack *)buttonStack selectedIndex:(int)index
{
    NSLog(@"tapped %d", index);
    if ( ! overlayAsset) {
        overlayAsset = [[UIImageView alloc] initWithFrame:_zoomingScroll.frame];
        [_zoomingScroll.blurView addSubview:overlayAsset];
        overlayMenuIndex = -1;
    }
    
    NSString *imgNm = [arr_OverlayData[index] objectForKey:@"overlay"];
    
    if (index != overlayMenuIndex) {
        overlayAsset.image = [UIImage imageNamed:imgNm];
        overlayMenuIndex = index;
    } else {
        [self clearOverlayData];
    }
}

-(void)clearOverlayData
{
    [overlayAsset removeFromSuperview];
    overlayAsset = nil;
    overlayMenuIndex = -1;
}

#pragma mark - maps
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

#pragma mark - menu @ bottom
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

#pragma mark - UI interaction methods

- (void)createBottomButtons:(NSArray *)titles {
    
    CGFloat buttonWidth = 78;
    
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
        button.frame = CGRectMake(1 + i * buttonWidth, 0, buttonWidth, bottomHeight);
        [button setTitle:titles[i] forState: UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"GoodPro-Book" size:13.0]];
        button.tag = i;
        [button addTarget:self action:@selector(tapBottomMenu:) forControlEvents:UIControlEventTouchUpInside];
        [uiv_bottomMenu addSubview: button];
        
        if (i == 0) {
            [self tapBottomMenu:button];
        }
    }
    
    uiv_menuIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, bottomHeight-4, buttonWidth, 4)];
    uiv_menuIndicator.backgroundColor = [UIColor themeRed];
    [uiv_bottomMenu addSubview: uiv_menuIndicator];
    
}

- (void)tapBottomMenu:(id)sender {
    
    [self clearOverlayData];

    [self createButtonStack: (int)[sender tag] ];
    
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

@end
