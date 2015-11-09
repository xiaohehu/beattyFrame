//
//  SummaryViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 7/21/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "MasterplanParkingViewController.h"
#import "ebZoomingScrollView.h"

static float containerWidth = 896.0;
static float containerHeight = 709.0;
static float topButtonHeight = 38.0;

@interface MasterplanParkingViewController () {
    // Basic UI elements
    UIView                  *uiv_container;
    UIButton                *uib_summary;
    UIButton                *uib_sitePlan;
    UIView                  *uiv_buttonHighlight;
    UIButton                *uib_close;
    // Summary view UI elements
    UIImageView             *uiiv_leftSummary;
    UIImageView             *uiiv_rightSummary;
    // Site Plan view UI elements
    UIView                  *uiv_sitePlanContainer;
    UIView                  *uiv_buttonPanel;
    ebZoomingScrollView     *uis_zoomSitePlan;
    NSArray                 *arr_optionColors;
    NSMutableArray          *arr_siteOptions;
    NSMutableArray          *arr_siteOverlay;
}

@end

@implementation MasterplanParkingViewController

@synthesize preloadSitePlan, loadWithAnimation;

#pragma mark - View controller life-cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    [self createContainer];
    [self createTopButtons];
    [self createSummaryContent];
    [self createSitePlanView];
}

- (void)viewWillAppear:(BOOL)animated {
    if (preloadSitePlan) {
        uiv_buttonHighlight.transform = CGAffineTransformMakeTranslation(containerWidth/2, 0.0);
        uiiv_leftSummary.transform = CGAffineTransformMakeTranslation(-uiiv_leftSummary.frame.size.width, 0.0);
        uiiv_rightSummary.transform = CGAffineTransformMakeTranslation(uiiv_rightSummary.frame.size.width, 0.0);
    }
    if (loadWithAnimation) {
        self.view.backgroundColor = [UIColor clearColor];
        uiv_container.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
        uib_close.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if (loadWithAnimation) {
        CGFloat duration = 0.8f;
        CGFloat damping = 0.75;
        CGFloat velocity = 0.5;
        [UIView animateWithDuration:0.2 animations:^(void){
            self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        } completion:^(BOOL finished){
            
            [UIView animateWithDuration:duration delay:0.5 usingSpringWithDamping:damping initialSpringVelocity:velocity options:0 animations:^{
                uiv_container.transform = CGAffineTransformIdentity;
                uib_close.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
                
            }];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create UI elements
- (void)createContainer {
    /*
     * Contianer of all centent
     */
    uiv_container = [UIView new];
    uiv_container.frame = CGRectMake((self.view.frame.size.width-containerWidth)/2, (self.view.frame.size.height-containerHeight)/2, containerWidth, containerHeight);
    uiv_container.backgroundColor = [UIColor whiteColor];
    uiv_container.layer.borderWidth = 1.0;
    uiv_container.layer.borderColor = [UIColor whiteColor].CGColor;
    uiv_container.clipsToBounds = YES;
    [self.view addSubview: uiv_container];
}

- (void)createTopButtons {
    uib_summary = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_summary.frame = CGRectMake(0.0, 0.0, containerWidth/2, topButtonHeight);
    uib_summary.backgroundColor = [UIColor whiteColor];
    [uib_summary setTitle:@"Master Plan" forState:UIControlStateNormal];
    [uib_summary setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [uib_summary.titleLabel setFont:[UIFont fontWithName:@"GoodPro-Book" size:20.0]];
    uib_summary.tag = 1;
    [uib_summary addTarget:self action:@selector(tapSitePlan:) forControlEvents:UIControlEventTouchUpInside];
    [uiv_container addSubview: uib_summary];
    
    uib_sitePlan = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_sitePlan.frame = CGRectMake(containerWidth/2, 0.0, containerWidth/2, topButtonHeight);
    uib_sitePlan.backgroundColor = [UIColor whiteColor];
    [uib_sitePlan setTitle:@"Parking" forState:UIControlStateNormal];
    [uib_sitePlan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [uib_sitePlan.titleLabel setFont:[UIFont fontWithName:@"GoodPro-Book" size:20.0]];
    uib_sitePlan.tag = 2;
    [uib_sitePlan addTarget:self action:@selector(tapSummary:) forControlEvents:UIControlEventTouchUpInside];
    [uiv_container addSubview: uib_sitePlan];
    
    uiv_buttonHighlight = [UIView new];
    uiv_buttonHighlight.frame = CGRectMake(4.0, uib_sitePlan.frame.size.height-6, uib_sitePlan.frame.size.width-8, 5);
    uiv_buttonHighlight.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:35.0/255.0 blue:42.0/255.0 alpha:1.0];
    [uiv_container addSubview: uiv_buttonHighlight];
    
    uib_close = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_close.frame = CGRectMake(uiv_container.frame.origin.x+uiv_container.frame.size.width - 15, uiv_container.frame.origin.y - 15, 30, 30);
    [uib_close setImage:[UIImage imageNamed:@"grfx_closeBtn.png"] forState:UIControlStateNormal];
    uib_close.backgroundColor = [UIColor clearColor];
    [uib_close addTarget:self action:@selector(closeThisView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uib_close];
}

- (void)createSummaryContent {
    uiiv_leftSummary = [UIImageView new];
    uiiv_rightSummary = [UIImageView new];
    /*
     * Change scale according device is retina or not
     */
    float scale = 1.0;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
        && [[UIScreen mainScreen] scale] == 2.0) {
        // Retina
        scale = 2.0;
    }
    
    /*
     * Split the summary image vertically
     * 2 UIImageView added to view
     */
    UIImage *summary = [UIImage imageNamed:@"grfx_siteplan.jpg"];
    CGImageRef tmpImageRef = summary.CGImage;
    CGImageRef left_summaryRef = CGImageCreateWithImageInRect(tmpImageRef, CGRectMake(0.0, 0.0, summary.size.width/2 * scale, summary.size.height*scale));
    CGImageRef right_summaryRef = CGImageCreateWithImageInRect(tmpImageRef, CGRectMake(summary.size.width/2*scale, 0.0, summary.size.width/2*scale, summary.size.height*scale));
    
    UIImage *left_summary = [UIImage imageWithCGImage:left_summaryRef scale:scale orientation:UIImageOrientationUp];
    UIImage *right_summary = [UIImage imageWithCGImage:right_summaryRef];
    
    [uiiv_leftSummary setImage: left_summary];
    uiiv_leftSummary.frame = CGRectMake(0.0, topButtonHeight, containerWidth/2, (containerHeight-topButtonHeight));
    [uiiv_rightSummary setImage: right_summary];
    uiiv_rightSummary.frame = CGRectMake(containerWidth/2, topButtonHeight, containerWidth/2, (containerHeight-topButtonHeight));
    [uiv_container addSubview: uiiv_leftSummary];
    [uiv_container addSubview: uiiv_rightSummary];
}

-(void)createSitePlanView {
    uiv_sitePlanContainer = [UIView new];
    uiv_sitePlanContainer.frame = CGRectMake(0, topButtonHeight, containerWidth, containerHeight-topButtonHeight);
    uiv_sitePlanContainer.backgroundColor = [UIColor clearColor];
    [uiv_container insertSubview:uiv_sitePlanContainer belowSubview:uiiv_leftSummary];
    
    
    uis_zoomSitePlan = [[ebZoomingScrollView alloc] initWithFrame:uiv_sitePlanContainer.bounds image:[UIImage imageNamed:@"grfx_summary.jpg"] shouldZoom:YES];
    uis_zoomSitePlan.backgroundColor = [UIColor whiteColor];
    [uiv_sitePlanContainer addSubview: uis_zoomSitePlan];
    
//    uiv_buttonPanel = [UIView new];
//    uiv_buttonPanel.frame = CGRectMake(19, 228, 200, 186);
//    uiv_buttonPanel.backgroundColor = [UIColor clearColor];
//    uiv_buttonPanel.layer.borderWidth = 2.0;
//    uiv_buttonPanel.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    [uiv_sitePlanContainer addSubview: uiv_buttonPanel];
    /*
     * Needed data to create site plan's control panel
     */
    NSArray *arr_names = @[@"Office",
                           @"Retail",
                           @"Residential",
                           @"Hotel",
                           @"Green Space"];
    arr_optionColors = @[[UIColor redColor],
                         [UIColor greenColor],
                         [UIColor blueColor],
                         [UIColor yellowColor],
                         [UIColor brownColor]];
    NSArray *overlayImageNames = @[@"office.png",
                                   @"retail.png",
                                   @"residential.png",
                                   @"hotel.png",
                                   @"greenspace.png"];
    
    arr_siteOverlay = [[NSMutableArray alloc] init];
    for (int i = 0; i < overlayImageNames.count; i++) {
        UIImageView *uiiv_overlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:overlayImageNames[i]]];
        uiiv_overlay.frame = uiv_sitePlanContainer.bounds;
        [arr_siteOverlay addObject:uiiv_overlay];
    }
    arr_siteOptions = [[NSMutableArray alloc] init];
    //[self createSitePlanButtons:arr_names andColors:arr_optionColors];
}

- (void)createSitePlanButtons:(NSArray *)arr_names andColors:(NSArray *)arr_colors {
    for (int i = 0; i < 5; i++) {
        // UIButton create
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
        button.frame = CGRectMake(0.0, i * 37.0, uiv_buttonPanel.frame.size.width, 37.0);
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 1.0;
        [button setTitle:arr_names[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 0);
        button.tag = i;
        // Left bar
        UIView *uiv_bar = [[UIView alloc] initWithFrame:CGRectMake(2.0, 0.0, 5.0, button.frame.size.height)];
        uiv_bar.backgroundColor = arr_colors[i];
        uiv_bar.tag = 10;
        uiv_bar.alpha = 0.7;
        [button addSubview: uiv_bar];
        // Dot next to button title
        UIView *uiv_dot = [[UIView alloc] initWithFrame:CGRectMake(15.0, (button.frame.size.height-5)/2, 5, 5)];
        uiv_dot.layer.cornerRadius = 2.5;
        uiv_dot.backgroundColor = arr_colors[i];
        uiv_dot.tag = 20;
        uiv_dot.alpha = 0.7;
        [button addSubview:uiv_dot];
        [button addTarget:self action:@selector(tapSiteOptions:) forControlEvents:UIControlEventTouchUpInside];
        [arr_siteOptions addObject:button];
        [uiv_buttonPanel addSubview: button];
    }
}

#pragma mark - Interaction

- (void)tapSummary:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^(void){
        uiv_sitePlanContainer.transform = CGAffineTransformMakeScale(0.7, 0.7);
        uiv_sitePlanContainer.alpha = 0.0;
        uiv_buttonHighlight.transform = CGAffineTransformIdentity;
        uiiv_rightSummary.transform = CGAffineTransformIdentity;
        uiiv_leftSummary.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){

    }];
}

- (void)tapSitePlan:(id)sender {
    
    uiv_sitePlanContainer.alpha = 0.0;
    uiv_sitePlanContainer.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [uis_zoomSitePlan resetScroll];
    [UIView animateWithDuration:0.33 animations:^(void){
        uiv_buttonHighlight.transform = CGAffineTransformMakeTranslation(containerWidth/2, 0.0);
        uiiv_leftSummary.transform = CGAffineTransformMakeTranslation(-uiiv_leftSummary.frame.size.width, 0.0);
        uiiv_rightSummary.transform = CGAffineTransformMakeTranslation(uiiv_rightSummary.frame.size.width, 0.0);
        uiv_sitePlanContainer.transform = CGAffineTransformIdentity;
        uiv_sitePlanContainer.alpha = 1.0;
    } completion:^(BOOL finished){
        
    }];
}

- (void)tapSiteOptions:(id)sender {
    
    UIButton *tappedButton = sender;
    
    if (tappedButton.selected) {
        tappedButton.selected = NO;
        [tappedButton viewWithTag:10].alpha = 0.7;
        [tappedButton viewWithTag:20].backgroundColor = arr_optionColors[tappedButton.tag];
        tappedButton.backgroundColor = [UIColor whiteColor];
        UIImageView *overlay = arr_siteOverlay[tappedButton.tag];
        [overlay removeFromSuperview];
    } else {
        tappedButton.selected = YES;
        [tappedButton viewWithTag:10].alpha = 1.0;
        [tappedButton viewWithTag:20].backgroundColor = [UIColor whiteColor];
        tappedButton.backgroundColor = arr_optionColors[tappedButton.tag];
        UIImageView *overlay = arr_siteOverlay[tappedButton.tag];
        [uis_zoomSitePlan.blurView addSubview: overlay];
    }
}

- (void)closeThisView:(id)sender {
    [UIView animateWithDuration:0.33 animations:^(void){
        self.view.alpha = 0.0;
    } completion:^(BOOL finished){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveSummary" object:nil];
    }];
}

@end
