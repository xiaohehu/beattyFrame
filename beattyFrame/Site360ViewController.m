//
//  Site360ViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 7/23/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "Site360ViewController.h"
#import "BuildingViewController.h"
#import "UIColor+Extensions.h"
#import <QuartzCore/QuartzCore.h>

#define kPhaseAColor @"phase_a_color"
#define kPhaseBColor @"phase_b_color"
#define kPhaseCColor @"phase_c_color"
#define kPhaseDColor @"phase_d_color"
#define kPhaseABase @"phase_a_base"
#define kPhaseBBase @"phase_b_base"
#define kPhaseCBase @"phase_c_base"
#define kPhaseDBase @"phase_d_base"

static int  phaseNumber = 4;
static float bottomMenuHeight  = 37.0;
@interface Site360ViewController ()
{
    IBOutlet UIView     *uiv_bottomContainer;
    UIView              *uiv_buttonIndicator;
    IBOutlet UIButton   *uib_summary;
    NSMutableArray      *arr_menuButton;
    NSMutableArray      *arr_highlightViews;

    __weak IBOutlet UIView *uiv_masterContainer;
    __weak IBOutlet UIButton *uib_Masterplan;
    __weak IBOutlet UIButton *uib_Parking;
//    UILabel             *uil_buildingTitle;
}
@end

@implementation Site360ViewController

@synthesize uis_scrollView, uiiv_imageView, colorWheel, uiv_container;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeBuilding:) name:@"removeBuilding" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self appInit];
    NSLog(@"viewDidLoad");

    [self createBottomMenu];

    //[self tapBottomButton:btn];
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"viewWillAppear");
    
    [self performSelector:@selector(tapBottomButton:) withObject:arr_menuButton[3] afterDelay:1.0];
}

- (void)viewDidAppear:(BOOL)animated {
//    if (uil_buildingTitle == nil) {
//        uil_buildingTitle = [[UILabel alloc] initWithFrame:CGRectMake(68.5, 219.5, 100, 50)];
//        uil_buildingTitle.backgroundColor = [UIColor blueColor];
//        [self.view addSubview: uil_buildingTitle];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeBuilding:(NSNotification *)notification {
    isColorPicked = NO;
    NSLog(@"remove in 360");
}

-(void)appInit {
    
    colorWheel.pickedColorDelegate = self;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [uiv_container addGestureRecognizer:panGesture];
    panGesture.delegate = self;
    
    currentFrame = 0;
    
    numberOfFrames = [self imageCount]-1;
    uiiv_imageView.image = [self imageAtIndex: currentFrame phaseType:kPhaseDBase];
    uiiv_imageView.alpha = 1.0;
    colorWheel.image = [self maskAtIndex: currentFrame maskType:kPhaseDColor];
    
    // setup scrollview
    self.uis_scrollView.minimumZoomScale=1.0;
    self.uis_scrollView.maximumZoomScale=2.0;
    self.uis_scrollView.contentSize=CGSizeMake(1024, 768);
    [uis_scrollView setDelegate:self];
    
    UITapGestureRecognizer *tap2Recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomPlan:)];
   	[tap2Recognizer setNumberOfTapsRequired:2];
    [tap2Recognizer setDelegate:self];
    [uis_scrollView addGestureRecognizer:tap2Recognizer];
    
    // makes it so that only two finger scrolls go
    for (id gestureRecognizer in uis_scrollView.gestureRecognizers) {
        if ([gestureRecognizer  isKindOfClass:[UIPanGestureRecognizer class]])
        {
            UIPanGestureRecognizer *panGR = gestureRecognizer;
            panGR.minimumNumberOfTouches = 2;
            panGR.maximumNumberOfTouches = 2;
        }
    }
    
    NSArray *colorsArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"colors" ofType:@"plist"]];
    
    for(NSDictionary* dict in colorsArray)
    {
        NSString* innerDict = dict[@"os"];
        if([innerDict isEqualToString:[[self deviceInfo] objectForKey:@"EMBOSValue"]])
        {
            namesArray = [[dict valueForKey:@"devices"]objectForKey:[[self deviceInfo] objectForKey:@"EMBDeviceType"]];
        }
    }
    
    arr_highlightViews = [[NSMutableArray alloc] init];
}

- (void)createBottomMenu {
    
    arr_menuButton = [[NSMutableArray alloc] init];
    CGRect buttonFrame = CGRectZero;
    for (int i = 0 ; i < phaseNumber; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [NSString stringWithFormat:@"Phase %i",i+1];
        [button setTitle:title forState:UIControlStateNormal];
        [button sizeToFit];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"GoodPro-Book" size:15.0]];
        button.backgroundColor = [UIColor whiteColor];
        CGRect frame = button.frame;
        frame.size.width += 19;
        frame.size.height = bottomMenuHeight;
        button.frame = frame;
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
        button.tag = i;
        buttonFrame = button.frame;
        [button addTarget:self action:@selector(tapBottomButton:) forControlEvents:UIControlEventTouchUpInside];
        [arr_menuButton addObject: button];
    }
    CGFloat menuWidth = buttonFrame.size.width * phaseNumber;
    uiv_bottomContainer.frame = CGRectMake(self.view.bounds.size.width - 86 - menuWidth, self.view.bounds.size.height - 22 - bottomMenuHeight, menuWidth, bottomMenuHeight);
    uiv_bottomContainer.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < arr_menuButton.count; i++) {
        UIButton *button = arr_menuButton[i];
        button.frame = CGRectMake(buttonFrame.size.width*i, 0, buttonFrame.size.width, bottomMenuHeight);
        [uiv_bottomContainer addSubview:button];
    }
    
//    uiv_buttonIndicator = [[UIView alloc] initWithFrame:CGRectMake(0.0, bottomMenuHeight - 4.0, buttonFrame.size.width, 4.0)];
//    uiv_buttonIndicator.backgroundColor = [UIColor themeRed];
//    [uiv_bottomContainer addSubview: uiv_buttonIndicator];

    [self addButtonHighlightViewTo:uiv_bottomContainer];
    
    uib_summary.backgroundColor = [UIColor whiteColor];
    [uib_summary setTitle:@"Summary" forState:UIControlStateNormal];
    [uib_summary setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [uib_summary.titleLabel setFont:[UIFont fontWithName:@"GoodPro-Book" size:15.0]];
    
    
    
    [uib_Masterplan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [uib_Masterplan.titleLabel setFont:[UIFont fontWithName:@"GoodPro-Book" size:15.0]];
}

-(void)addButtonHighlightViewTo:(UIView*)container
{
    UIView *highlightView = [[UIView alloc] initWithFrame:CGRectMake(0.0, bottomMenuHeight-4.0, 80, 4.0)];
    highlightView.backgroundColor = [UIColor themeRed];
    [container addSubview: highlightView];
    [arr_highlightViews addObject:highlightView];
    [self.view bringSubviewToFront:highlightView];
}

- (IBAction)tapMasterMenu:(id)sender {
//    
//    if ([arr_highlightViews count] == 1) {
//        [self addButtonHighlightViewTo:uiv_masterContainer];
//    }
//
//    UIButton *tappedButton = sender;
//    NSLog(@"tapMasterMenu %li",(long)tappedButton.tag);
//    
//    UIView *selctedView = arr_highlightViews[1];
//    CGRect indicatorFrame = selctedView.frame;
//    
//    [UIView animateWithDuration:0.33 animations:^(void){
//        selctedView.frame = CGRectMake(tappedButton.frame.origin.x, indicatorFrame.origin.y, tappedButton.frame.size.width, indicatorFrame.size.height);
//    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMasterPlan" object:nil];
}


- (void)tapBottomButton:(id)sender {
    UIButton *tappedButton = sender;
    
    //NSLog(@"tappedButton %li",(long)tappedButton.tag);
    
    //CGRect indicatorFrame = uiv_buttonIndicator.frame;
    
    UIView *selctedView = arr_highlightViews[0];
    CGRect indicatorFrame = selctedView.frame;
    
    phaseIndex = tappedButton.tag;
    [UIView animateWithDuration:0.33 animations:^(void){
        selctedView.frame = CGRectMake(tappedButton.frame.origin.x, indicatorFrame.origin.y, tappedButton.frame.size.width, indicatorFrame.size.height);
    }];
    
    switch (tappedButton.tag) {
        case 0: {
            uiiv_imageView.image = [self imageAtIndex: currentFrame phaseType:kPhaseABase];
            colorWheel.image = [self maskAtIndex: currentFrame maskType:kPhaseAColor];
            break;
        }
        case 1: {
            uiiv_imageView.image = [self imageAtIndex: currentFrame phaseType:kPhaseBBase];
            colorWheel.image = [self maskAtIndex: currentFrame maskType:kPhaseBColor];
            break;
        }
        case 2: {
            uiiv_imageView.image = [self imageAtIndex: currentFrame phaseType:kPhaseCBase];
            colorWheel.image = [self maskAtIndex: currentFrame maskType:kPhaseCColor];
            break;
        }
        case 3: {
            uiiv_imageView.image = [self imageAtIndex: currentFrame phaseType:kPhaseDBase];
            colorWheel.image = [self maskAtIndex: currentFrame maskType:kPhaseDColor];
            break;
        }
        default:
            break;
    }
}

- (IBAction)tapSummaryButton:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadSummary" object:nil];
}

#pragma mark - METHODS FOR PICKING BUILDING
#pragma mark picked color from color

- (void) pickedColor:(UIColor*)color {
    
    if (isColorPicked==YES) {
        return;
    }
    
    [self.view setNeedsDisplay];
    
    const CGFloat* components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    CGFloat a = CGColorGetAlpha(color.CGColor);
    
    int red = floor(r == 1.0 ? 255 : r * 256.0);
    int green = floor(g == 1.0 ? 255 : g * 256.0);
    int blue = floor(b == 1.0 ? 255 : b * 256.0);
    int alpha = floor(a == 1.0 ? 255 : a * 256.0);
    
    NSLog(@"\nRGB A %i %i %i  %i",red,green,blue,alpha);
    incomingColor = [NSString stringWithFormat:@"RGB A %i %i %i  %i",red,green,blue,alpha];
    NSLog(@"\n\nincomingColor %@", incomingColor);
    
    NSInteger redValue = -1;
    NSInteger greenValue = -1;
    NSInteger blueValue = -1;
    
    for (NSString *rgba in namesArray) {
        
        NSArray *array = [rgba componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
        
        redValue = [array[2] integerValue];
        greenValue = [array[3] integerValue];
        blueValue = [array[4] integerValue];
        
        NSUInteger index;
        NSString *answer = nil;
    
        if ( (labs(red - redValue) < 2) && (labs(green - greenValue) < 2) && (labs(blue - blueValue) < 2) ) {
            
            index = [namesArray indexOfObject:rgba];
            answer = [namesArray objectAtIndex:index];
            currentIndex = index;
            
            isColorEligible = YES;
            isColorPicked=YES;
            
            NSDictionary* userInfo = @{@"buildingindex": @(index)};
            NSLog(@"running twice!");
            // Need to add userInfo to trach the index of building
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadBuilding" object:nil userInfo:userInfo];

        } else {
            isColorEligible = NO;
            isColorPicked=NO;
        }
    }
    
//    NSString *answer = nil;
//    NSUInteger index = [namesArray indexOfObject:incomingColor];
//    if (index != NSNotFound) {
//        isColorEligible = YES;
//        answer = [namesArray objectAtIndex:index];
//        currentIndex = index;
//        isColorPicked=YES;
//        
//        NSDictionary* userInfo = @{@"buildingindex": @(index)};
//        
//        // Need to add userInfo to trach the index of building
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadBuilding" object:nil userInfo:userInfo];
//        
//    } else {
//        isColorEligible = NO;
//        isColorPicked=NO;
//    }
}

#pragma mark - controls/gestures on BG
#pragma mark Pan Gesture
-(IBAction)handlePanGesture:(UIPanGestureRecognizer *) sender {
    
    [self.view setUserInteractionEnabled:NO];
    
    UIView *myView = [sender view];
    
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [(UIPanGestureRecognizer *) sender translationInView:(sender.view)];
        
        if (translation.x > 5) {
            
            if (currentFrame > 1) {
                currentFrame--;
            }
            else {
                currentFrame = numberOfFrames;
            }
            
            //[self animateLabelAtIndex:currentFrame];
            
            if (phaseIndex == 0) {
                uiiv_imageView.image = [self imageAtIndex: currentFrame phaseType:kPhaseABase];
                colorWheel.image = [self maskAtIndex: currentFrame maskType:kPhaseAColor];
            } else if (phaseIndex == 1) {
                uiiv_imageView.image = [self imageAtIndex: currentFrame phaseType:kPhaseBBase];
                colorWheel.image = [self maskAtIndex: currentFrame maskType:kPhaseBColor];
            } else if (phaseIndex == 2) {
                uiiv_imageView.image = [self imageAtIndex: currentFrame phaseType:kPhaseCBase];
                colorWheel.image = [self maskAtIndex: currentFrame maskType:kPhaseCColor];
            } else if (phaseIndex == 3) {
                uiiv_imageView.image = [self imageAtIndex: currentFrame phaseType:kPhaseDBase];
                colorWheel.image = [self maskAtIndex: currentFrame maskType:kPhaseDColor];
            }
            [sender setTranslation:CGPointZero inView:[myView superview]];
            
            
        }else {
            
            if (translation.x < -5){
                
                if (currentFrame < numberOfFrames) {
                    currentFrame++;
                }else {
                    currentFrame = 0;
                }
                
                //[self animateLabelAtIndex:currentFrame];
                
                if (phaseIndex == 0) {
                    uiiv_imageView.image = [self imageAtIndex: currentFrame phaseType:kPhaseABase];
                    colorWheel.image = [self maskAtIndex: currentFrame maskType:kPhaseAColor];
                } else if (phaseIndex == 1) {
                    uiiv_imageView.image = [self imageAtIndex: currentFrame phaseType:kPhaseBBase];
                    colorWheel.image = [self maskAtIndex: currentFrame maskType:kPhaseBColor];
                } else if (phaseIndex == 2) {
                    uiiv_imageView.image = [self imageAtIndex: currentFrame phaseType:kPhaseCBase];
                    colorWheel.image = [self maskAtIndex: currentFrame maskType:kPhaseCColor];
                } else if (phaseIndex == 3) {
                    uiiv_imageView.image = [self imageAtIndex: currentFrame phaseType:kPhaseDBase];
                    colorWheel.image = [self maskAtIndex: currentFrame maskType:kPhaseDColor];
                }

                [sender setTranslation:CGPointZero inView:[myView superview]];
            }
        }
        
    }
    [self.view setUserInteractionEnabled:YES];
}

#pragma mark Zoom BG Scroll
-(void)zoomPlan:(UITapGestureRecognizer *)sender {
    
    // 1
    CGPoint pointInView = [sender locationInView:self.uiiv_imageView];
    
    // 2
    CGFloat newZoomScale = self.uis_scrollView.zoomScale * 2.0f;
    newZoomScale = MIN(newZoomScale, self.uis_scrollView.maximumZoomScale);
    
    // 3
    CGSize scrollViewSize = self.uis_scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    // 4
    
    if (uis_scrollView.zoomScale > 1.9) {
        [uis_scrollView setZoomScale: 1.0 animated:YES];
    } else if (uis_scrollView.zoomScale < 2) {
        [self.uis_scrollView zoomToRect:rectToZoomTo animated:YES];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return uiv_container;
}

- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated
{
    [UIView animateWithDuration:(animated?0.3f:0.0f)
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [uis_scrollView zoomToRect:rect animated:NO];
                     }
                     completion:nil];
}

#pragma mark - Utilities
#pragma mark Device Info
-(NSDictionary*)deviceInfo
{
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
    
    BOOL isSimulator;
    
#if TARGET_IPHONE_SIMULATOR
    isSimulator = YES;
#else
    isSimulator = NO;
#endif
    //	NSLog(@"BOOL = %@\n", (isSimulator ? @"YES" : @"NO"));
    
    NSString* osValue;
    NSString* deviceType;
    NSArray* arr_deviceTypes = @[@"simulator",@"ipad_3",@"ipad_4"];
    // check system version
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {
        
        osValue = @"8";
        
        NSLog(@"great 8");
        if(isSimulator) {
            NSLog(@"sim 8");
            deviceType = arr_deviceTypes[0];
        } else {
            NSLog(@"not sim 8");
            deviceType = arr_deviceTypes[0];
        }
        
    } else {
        
        osValue = @"7";
        
        if(isSimulator) {
            NSLog(@"sim 7");
            deviceType = arr_deviceTypes[0];
        } else {
            NSLog(@"not sim 7");
            deviceType = arr_deviceTypes[0];
        }
    }
    
    NSDictionary* embDeviceDictionary = @{
                                          @"EMBOSValue": osValue,
                                          @"EMBDeviceType": deviceType,
                                          };
    
    return embDeviceDictionary;
}


#pragma mark - Images Array for PHASES

- (NSArray *)imageData {
    static NSArray *__imageData = nil; // only load the imageData array once
    
    if (__imageData == nil) {
        // read the filenames/sizes out of a plist in the app bundle
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ImageData" ofType:@"plist"];
        NSData *plistData = [NSData dataWithContentsOfFile:path];
        NSError *error;
        NSPropertyListFormat format;
        
        __imageData = [NSPropertyListSerialization propertyListWithData:plistData
                                                                options:NSPropertyListImmutable
                                                                 format:&format
                                                                  error:&error];
        
        if (!__imageData) {
        }
    }
    
    return __imageData;
}

- (UIImage *)maskAtIndex:(NSUInteger)index maskType:(NSString*)maskName {
    // use "imageWithContentsOfFile:" instead of "imageNamed:" here to avoid caching our images
    NSString *maskkName = [self maskNameAtIndex:index maskType:maskName];
    NSString *path = [[NSBundle mainBundle] pathForResource:maskkName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}

- (UIImage *)imageAtIndex:(NSUInteger)index phaseType:(NSString*)phaseName {
    // use "imageWithContentsOfFile:" instead of "imageNamed:" here to avoid caching our images
    NSString *imageName = [self imageNameAtIndex:index phaseType:phaseName];
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
    return [UIImage imageWithContentsOfFile:path];
}

- (UIImage *)phaseaAtIndex:(NSUInteger)index {
    // use "imageWithContentsOfFile:" instead of "imageNamed:" here to avoid caching our images
    NSString *phaseaName = [self phaseaNameAtIndex:index];
    NSString *path = [[NSBundle mainBundle] pathForResource:phaseaName ofType:@"jpg"];
    return [UIImage imageWithContentsOfFile:path];
    //NSLog(@"phasea: %@", path);
}

- (NSString *)imageNameAtIndex:(NSUInteger)index phaseType:(NSString*)phaseName {
    NSString *name = nil;
    if (index < [self imageCount]) {
        NSDictionary *data = [[self imageData] objectAtIndex:index];
        name = [data valueForKey:phaseName];
    }
    return name;
}

- (NSString *)maskNameAtIndex:(NSUInteger)index maskType:(NSString*)maskName{
    NSString *mask = nil;
    if (index < [self imageCount]) {
        NSDictionary *data = [[self imageData] objectAtIndex:index];
        mask = [data valueForKey:maskName];
    }
    return mask;
}

- (NSString *)phaseaNameAtIndex:(NSUInteger)index {
    NSString *phasea = nil;
    if (index < [self imageCount]) {
        NSDictionary *data = [[self imageData] objectAtIndex:index];
        phasea = [data valueForKey:@"phasea"];
    }
    return phasea;
}

// works both ways
- (CGSize)imageSizeAtIndex:(NSUInteger)index {
    CGSize size = CGSizeZero;
    if (index < [self imageCount]) {
        NSDictionary *data = [[self imageData] objectAtIndex:index];
        size.width = [[data valueForKey:@"width"] floatValue];
        size.height = [[data valueForKey:@"height"] floatValue];
    }
    return size;
}

// works both ways
- (NSUInteger)imageCount {
    static NSUInteger __count = NSNotFound;  // only count the images once
    if (__count == NSNotFound) {
        __count = [[self imageData] count];
    }
    return __count;
}

@end
