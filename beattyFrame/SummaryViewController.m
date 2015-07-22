//
//  SummaryViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 7/21/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "SummaryViewController.h"

static float containerWidth = 896.0;
static float containerHeight = 709.0;
static float topButtonHeight = 38.0;

@interface SummaryViewController () {
    // Basic UI elements
    UIView          *uiv_container;
    UIButton        *uib_summary;
    UIButton        *uib_sitePlan;
    UIView          *uiv_buttonHighlight;
    UIButton        *uib_close;
    // Summary view UI elements
    UIImageView     *uiiv_leftSummary;
    UIImageView     *uiiv_rightSummary;
    // Site Plan view UI elements
    UIView          *uiv_sitePlanContainer;
    UIView          *uiv_buttonPanel;
    UIImageView     *uiiv_sitePlanBg;
    NSArray         *arr_optionColors;
    NSMutableArray  *arr_siteOptions;
    NSMutableArray  *arr_siteOverlay;
}

@end

@implementation SummaryViewController
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create UI elements
- (void)createContainer {
    uiv_container = [UIView new];
    uiv_container.frame = CGRectMake((self.view.frame.size.width-containerWidth)/2, (self.view.frame.size.height-containerHeight)/2, containerWidth, containerHeight);
    uiv_container.backgroundColor = [UIColor clearColor];
    uiv_container.layer.borderWidth = 1.0;
    uiv_container.layer.borderColor = [UIColor whiteColor].CGColor;
    uiv_container.clipsToBounds = YES;
    [self.view addSubview: uiv_container];
}

- (void)createTopButtons {
    uib_summary = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_summary.frame = CGRectMake(0.0, 0.0, containerWidth/2, topButtonHeight);
    uib_summary.backgroundColor = [UIColor whiteColor];
    [uib_summary setTitle:@"Project Summary" forState:UIControlStateNormal];
    [uib_summary setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    uib_summary.tag = 1;
    [uib_summary addTarget:self action:@selector(tapSummary:) forControlEvents:UIControlEventTouchUpInside];
    [uiv_container addSubview: uib_summary];
    
    uib_sitePlan = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_sitePlan.frame = CGRectMake(containerWidth/2, 0.0, containerWidth/2, topButtonHeight);
    uib_sitePlan.backgroundColor = [UIColor whiteColor];
    [uib_sitePlan setTitle:@"Site Plan" forState:UIControlStateNormal];
    [uib_sitePlan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    uib_sitePlan.tag = 2;
    [uib_sitePlan addTarget:self action:@selector(tapSitePlan:) forControlEvents:UIControlEventTouchUpInside];
    [uiv_container addSubview: uib_sitePlan];
    
    uiv_buttonHighlight = [UIView new];
    uiv_buttonHighlight.frame = CGRectMake(4.0, uib_sitePlan.frame.size.height-6, uib_sitePlan.frame.size.width-8, 5);
    uiv_buttonHighlight.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:35.0/255.0 blue:42.0/255.0 alpha:1.0];
    [uiv_container addSubview: uiv_buttonHighlight];
    
    uib_close = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_close.frame = CGRectMake(uiv_container.frame.origin.x+uiv_container.frame.size.width - 15, uiv_container.frame.origin.y - 15, 30, 30);
    [uib_close setTitle:@"X" forState:UIControlStateNormal];
    uib_close.backgroundColor = [UIColor redColor];
    uib_close.layer.cornerRadius = 15;
    [uib_close addTarget:self action:@selector(closeThisView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uib_close];
}

- (void)createSummaryContent {
    uiiv_leftSummary = [UIImageView new];
    uiiv_rightSummary = [UIImageView new];
    
    UIImage *summary = [UIImage imageNamed:@"grfx_summary.jpg"];
    CGImageRef tmpImageRef = summary.CGImage;
    CGImageRef left_summaryRef = CGImageCreateWithImageInRect(tmpImageRef, CGRectMake(0.0, 0.0, summary.size.width/2, summary.size.height));
    CGImageRef right_summaryRef = CGImageCreateWithImageInRect(tmpImageRef, CGRectMake(summary.size.width/2, 0.0, summary.size.width/2, summary.size.height));
    
    UIImage *left_summary = [UIImage imageWithCGImage:left_summaryRef];
    UIImage *right_summary = [UIImage imageWithCGImage:right_summaryRef];
    
    [uiiv_leftSummary setImage: left_summary];
    uiiv_leftSummary.frame = CGRectMake(0.0, uib_summary.frame.size.height, left_summary.size.width, left_summary.size.height);
    [uiiv_rightSummary setImage: right_summary];
    uiiv_rightSummary.frame = CGRectMake(left_summary.size.width, topButtonHeight, right_summary.size.width, right_summary.size.height);
    [uiv_container addSubview: uiiv_leftSummary];
    [uiv_container addSubview: uiiv_rightSummary];
}

-(void)createSitePlanView {
    uiv_sitePlanContainer = [UIView new];
    uiv_sitePlanContainer.frame = CGRectMake(0, topButtonHeight, containerWidth, containerHeight-topButtonHeight);
    uiv_sitePlanContainer.backgroundColor = [UIColor clearColor];
    [uiv_container insertSubview:uiv_sitePlanContainer belowSubview:uiiv_leftSummary];
    
    uiiv_sitePlanBg = [UIImageView new];
    [uiiv_sitePlanBg setImage:[UIImage imageNamed:@"grfx_siteplan.jpg"]];
    uiiv_sitePlanBg.frame = uiv_sitePlanContainer.bounds;
    [uiv_sitePlanContainer addSubview: uiiv_sitePlanBg];
    
    uiv_buttonPanel = [UIView new];
    uiv_buttonPanel.frame = CGRectMake(16, 266, 136, 186);
    uiv_buttonPanel.backgroundColor = [UIColor clearColor];
    uiv_buttonPanel.layer.borderWidth = 2.0;
    uiv_buttonPanel.layer.borderColor = [UIColor whiteColor].CGColor;
    [uiv_sitePlanContainer addSubview: uiv_buttonPanel];
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
    [self createSitePlanButtons:arr_names andColors:arr_optionColors];
}

- (void)createSitePlanButtons:(NSArray *)arr_names andColors:(NSArray *)arr_colors {
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
        button.frame = CGRectMake(0.0, i * 37.0+ 1, uiv_buttonPanel.frame.size.width, 37.0);
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
        UIView *uiv_bar = [[UIView alloc] initWithFrame:CGRectMake(2.0, 0.0, 5.0, button.frame.size.height)];
        uiv_bar.backgroundColor = arr_colors[i];
        uiv_bar.tag = 10;
        uiv_bar.alpha = 0.7;
        [button addSubview: uiv_bar];
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
        [uiv_sitePlanContainer addSubview: overlay];
    }
}

- (void)closeThisView:(id)sender {
    [UIView animateWithDuration:0.33 animations:^(void){
        self.view.alpha = 0.0;
    } completion:^(BOOL finished){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveSummary" object:nil];
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
