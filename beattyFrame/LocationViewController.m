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
#import "KeyOverlay.h"
#import "ImageOverlay.h"
#import "AppDelegate.h"
#import "MapViewAnnotation.h"
#import <MapKit/MapKit.h>
#import "tappableview.h"
#import "neighborhoodpanelview.h"

#define METERS_PER_MILE 109.344

static float    bottomWidth = 236;
static float    bottomHeight = 37;

@interface LocationViewController () <ButtonStackDelegate, MKMapViewDelegate, tapviewDeleagte>
{
    UIView              *uiv_bottomMenu;
    UIView              *uiv_menuIndicator;
    UIImageView         *uiiv_tmpMap;
    NSArray             *arr_mapImageNames;
    
    ButtonStack         *overlayMenu;
    UIImageView         *overlayAsset;
    int                 overlayMenuIndex;
    int                 mapIndex;
    NSArray             *arr_OverlayData;
    NSDictionary        *menuData;
    
    NSArray             *neighborhoodData;
    NSInteger           incomingIndex;
    
    IBOutlet            UIButton            *uib_appleMap;
}

@property (nonatomic, strong) ebZoomingScrollView			*zoomingScroll;
@property (nonatomic, retain) AppDelegate                   *appDelegate;
@property (nonatomic, strong) UIButton                      *uib_appleMap;
@property (nonatomic, strong) MKMapView                     *mapView;
@property (nonatomic, strong) UIView                        *uiv_mapContainer;
@property (nonatomic, strong) tappableview                  *tview;
@property (nonatomic, strong) neighborhoodpanelview         *npview;

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
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [_uib_appleMap setTitle:@"Apple Maps" forState:UIControlStateNormal];
    [uib_appleMap setTitleColor:[UIColor themeRed] forState:UIControlStateNormal];
    [_uib_appleMap sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create UI elements and UI data

- (void)prepareData {
    arr_mapImageNames = @[
                          @"grfx_siteMap_base_map.png",
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
    //[d sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    arr_OverlayData = menuData[d[index]];
//    
//    NSMutableArray *overlayAssets = [[NSMutableArray alloc] init];
//    for ( NSDictionary *menuAsset in arr_OverlayData )
//    {
//        [overlayAssets addObject:menuAsset[@"name"]];
//    }

    if (overlayMenu) {
        [overlayMenu removeFromSuperview];
    }
    
    overlayMenu = [[ButtonStack alloc] initWithFrame:CGRectZero];
    overlayMenu.delegate = self;
    [overlayMenu setupfromArray:arr_OverlayData maxWidth:CGRectMake(15,100,150,0)];
    [overlayMenu setCenter];
    [overlayMenu setBackgroundColor:[UIColor whiteColor]];
    overlayMenu.layer.borderWidth = 1;
    overlayMenu.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:overlayMenu];
}

-(void)createKeyForMap
{
    UIImage*key = [UIImage imageNamed:@"grfx_regionalMap_overlay_key.png"];
    KeyOverlay *keyOverlay = [[KeyOverlay alloc] initWithFrame:CGRectMake(20, 320, key.size.width, key.size.height)];
    [keyOverlay setKeyImage:key];
    [self.view addSubview:keyOverlay];
    
    key = [UIImage imageNamed:@"grfx_regionalMap_overlay_stats.png"];
    keyOverlay = [[KeyOverlay alloc] initWithFrame:CGRectMake(600, 350, key.size.width, key.size.height)];
    [keyOverlay setKeyImage:key];
    [self.view addSubview:keyOverlay];
    
    //grfx_cityMap_overlay_legend_light_rail.png
}

-(void)createKeyForCity
{
    UIImage*key = [UIImage imageNamed:@"grfx_cityMap_overlay_legend_light_rail.png"];
    KeyOverlay *keyOverlay = [[KeyOverlay alloc] initWithFrame:CGRectMake(20, 620, key.size.width, key.size.height)];
    [keyOverlay setKeyImage:key];
    [self.view addSubview:keyOverlay];
}

- (void)buttonStack:(ButtonStack *)buttonStack selectedIndex:(int)index
{
    NSLog(@"tapped %d", index);
    [self clearKeys];
    [self clearOverlayData];
    [buttonStack setSelectedButtonColor:[UIColor themeRed]];

    
    // if mapIndex and overlayIndex
    if (( mapIndex == 1 ) && ( index == 0 )) {
        [self createKeyForCity];
    } else if ((( mapIndex == 1 ) && ( index == 1 )) || (( mapIndex == 0 ) && ( index == 1 ))) {
        [self addNeighborhoods];
        return;
    }
    
    if ( ! overlayAsset) {
        overlayAsset = [[UIImageView alloc] initWithFrame:_zoomingScroll.frame];
        [_zoomingScroll.blurView addSubview:overlayAsset];
        overlayMenuIndex = -1;
    }

    
    NSString *imgNm = [arr_OverlayData[index] objectForKey:@"overlay"];
    
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
        [self clearKeys];
    }
}

-(void)clearOverlayData
{
    [overlayAsset removeFromSuperview];
    overlayAsset = nil;
    overlayMenuIndex = -1;
}

-(void)clearKeys
{
    for (UIView *key in self.view.subviews) {
        if ([key  isKindOfClass:[KeyOverlay class]])
            [key removeFromSuperview];
    }
    
    for (UIView *key in [_zoomingScroll.blurView subviews]) {
        if ([key  isKindOfClass:[KeyOverlay class]])
            [key removeFromSuperview];
    }
    
    if (_tview) {
        [_tview removeFromSuperview];
        _tview=nil;
    }
    
    if (_npview) {
        [_npview removeFromSuperview];
        _npview=nil;
    }
    
    for (UIView *key in [_zoomingScroll.blurView subviews]) {
        if ([key  isKindOfClass:[tappableview class]])
            [key removeFromSuperview];
    }
}

-(void)clearLogoOverlay
{
    for (UIView *key in [_zoomingScroll.blurView subviews]) {
        if ([key  isKindOfClass:[ImageOverlay class]])
            [key removeFromSuperview];
    }
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
    [self.view insertSubview: uiiv_tmpMap belowSubview:_uib_appleMap];
}

#pragma mark - menu @ bottom
- (void)createBottomMenu {
    uiv_bottomMenu = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - bottomWidth)/2, self.view.frame.size.height - 22 - bottomHeight, bottomWidth, bottomHeight)];
    uiv_bottomMenu.backgroundColor = [UIColor whiteColor];
    uiv_bottomMenu.layer.borderWidth = 1.0;
    uiv_bottomMenu.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview: uiv_bottomMenu];
    
    NSArray *arr_menuTitles = @[
                                @"Site",
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
    [self clearKeys];

    if ([sender tag] !=2) {
        [self createButtonStack: (int)[sender tag] ];
    } else {
        [overlayMenu removeFromSuperview];
        [self createKeyForMap];
    }
    
    [self clearLogoOverlay];
    
    UIButton *tappedButton = sender;
    
    mapIndex = (int)[sender tag];
    NSLog(@"mapIndex %d",mapIndex);

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
        
        // create logo hotspot
        if ([sender tag] == 1) {
            [self createLogoPinForMapAtRect:(CGPointMake(548,333))];
            _uib_appleMap.hidden = NO;
        } else if ([sender tag] == 2) {
            [self createLogoPinForMapAtRect:(CGPointMake(159,582))];
            _uib_appleMap.hidden = YES;
        }

    }];
}

-(void)createLogoPinForMapAtRect:(CGPoint)point
{
    UIImage*key = [UIImage imageNamed:@"grfx-site-marker.png"];
    ImageOverlay *keyOverlay = [[ImageOverlay alloc] initWithFrame:CGRectMake(point.x, point.y, key.size.width, key.size.height)];
    keyOverlay.alpha = 0.0;
    [keyOverlay setKeyImage:key];
    [_zoomingScroll.blurView addSubview:keyOverlay];
    
    [UIView animateWithDuration:0.33 animations:^(void) {
        keyOverlay.alpha = 1.0;
    }];
}

-(IBAction)loadAppleMap
{
    NSLog(@"loadAppleMap");
    
    [_uib_appleMap setTitle:@"Close Apple Maps" forState:UIControlStateNormal];
    [uib_appleMap setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_uib_appleMap sizeToFit];

    
    if ([_appDelegate.isWirelessAvailable isEqualToString:@"NO"]) {
        NSLog(@"Wireless NO");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Offline"
                                                        message:@"A network connection is required to view the live map. A static map has been loaded instead. Please check your internet connection and try again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [self initOfflineMapView];
        
        
        [alert show];
    } else if ([_appDelegate.isWirelessAvailable isEqualToString:@"YES"]) {
        NSLog(@"Wireless YES");
        
        [_uib_appleMap setSelected:YES];
        
        [self initMapView];
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = 39.280328;
        zoomLocation.longitude= -76.599012;
    
        MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:@"Harbor Point" andCoordinate:zoomLocation];
        [self.mapView addAnnotation:newAnnotation];

    }
}

-(void)initOfflineMapView
{
    _uiv_mapContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    
    CGRect theFrame = self.view.bounds;
    _zoomingScroll = [[ebZoomingScrollView alloc] initWithFrame:theFrame image:nil shouldZoom:YES];
    [self.view addSubview:_zoomingScroll];
    _zoomingScroll.backgroundColor = [UIColor clearColor];
    _zoomingScroll.delegate=self;
    _zoomingScroll.closeBtn = YES;
    _zoomingScroll.blurView.image = [UIImage imageNamed:@"map_apple_offline.jpg"];
    [_uiv_mapContainer addSubview: _mapView];
    [self.view insertSubview:_uiv_mapContainer belowSubview:_uib_appleMap];
}

-(void)didRemove:(ebZoomingScrollView *)didRemove
{
    [_uiv_mapContainer removeFromSuperview];
    _mapView=nil;
    overlayMenu.hidden = NO;
    
    [_uib_appleMap setSelected:NO];
    
    [_uib_appleMap setTitle:@"Apple Maps" forState:UIControlStateNormal];
    [uib_appleMap setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_uib_appleMap sizeToFit];
}


-(void)initMapView
{
    if (_mapView) {
        [self didRemove:nil];
        return;
    }
    
    overlayMenu.hidden = YES;
    _uiv_mapContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;
    
    [_uiv_mapContainer addSubview: _mapView];
    [self.view insertSubview:_uiv_mapContainer belowSubview:_uib_appleMap];
}


- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id <MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region;
    
    region = MKCoordinateRegionMakeWithDistance([mp coordinate], 55000, 55000);
    
    [mv setRegion:region animated:YES];
    [mv selectAnnotation:mp animated:YES];
}

-(void)addNeighborhoods
{
    NSString *textPath = [[NSBundle mainBundle] pathForResource:@"neighborhoods" ofType:@"json"];
    
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:textPath encoding:NSUTF8StringEncoding error:&error];  //error checking omitted
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *maps = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString*maptype;
    if (mapIndex == 0) {
        maptype = @"city";
    } else {
        maptype = @"site";
    }
    neighborhoodData = maps[maptype];
    
    int i = 0;
    for (NSDictionary *dict in neighborhoodData) {
        
        NSString *txt = dict[@"center"];
        NSArray *xy = [txt componentsSeparatedByString:@","];
        CGFloat viewX = [xy[0] floatValue];
        CGFloat viewY = [xy[1] floatValue];
        
        _tview = [[tappableview alloc] initWithFrame:CGRectMake(viewX, viewY, 64, 64) title:dict[@"name"] tag:i++];
        _tview.delegate = self;
        [_zoomingScroll.blurView addSubview:_tview];
    }
}

-(void)tappedView:(NSInteger)index
{
    if (_npview) {
        [_npview removeFromSuperview];
        _npview = nil;
    }
    
    if (incomingIndex == index) {
        NSLog(@"already selected %ld", index);
        for (UIView *key in [_zoomingScroll.blurView subviews]) {
            if ([key  isKindOfClass:[tappableview class]])
                [(tappableview*)key setSelected:NO];
        }
    } else {
        
        for (UIView *key in [_zoomingScroll.blurView subviews]) {
            if ([key  isKindOfClass:[tappableview class]])
                [(tappableview*)key setSelected:YES];
        }
        
        NSDictionary *selectedDict = neighborhoodData[index];
        
        if (! _npview) {
            _npview = [[neighborhoodpanelview alloc] initWithFrame:CGRectMake(670, 440, 308, 224) title:selectedDict[@"name"] pop:selectedDict[@"Population"] inc:selectedDict[@"Avg HH Income"] age:selectedDict[@"Median Age"]];
            [self.view addSubview:_npview];
            incomingIndex = index;
        }
        
        UITextView *txtview = [[UITextView alloc] initWithFrame:CGRectMake(15, 120, _npview.frame.size.width-30,  98)];
        txtview.textContainerInset = UIEdgeInsetsZero;
        txtview.textContainer.lineFragmentPadding = 0;
        txtview.editable = NO;
        txtview.selectable = NO;
        txtview.font = [UIFont fontWithName:@"GoodPro" size:15];
        [txtview setTextColor:[UIColor themeTextGray]];
        txtview.text = selectedDict[@"desc"];
        [_npview addSubview:txtview];
        
    }
}

@end
