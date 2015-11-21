//
//  SupportingViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 7/29/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "SupportingViewController.h"
#import "supportingModelController.h"
#import "supportingDataViewController.h"
#import "UIColor+Extensions.h"
//#import "animationView.h"
#import "xhPageViewController.h"
#import "AnimationIndex.h"
#import "gridEcoViewIndex.h"

static CGFloat  bottomMenuWidth = 728;
static CGFloat  bottomMenuHeight = 37;
static int      animationViewIndex = kAnimationIndex;
static int      gridViewIndex = kEcoIndex;

@interface SupportingViewController () <UIPageViewControllerDelegate, UIGestureRecognizerDelegate>
{
    UIView          *uiv_bottomMenu;
    UIView          *uiv_bottomHighlightView;
    UILabel         *uil_pageNum;
    NSMutableArray  *arr_menuTitles;
    NSMutableArray  *arr_menuButton;
    NSArray         *arr_lastIndex;
    NSArray         *arr_firstIndex;
    int             currentPageIndex;
}

@property (readonly, strong, nonatomic) supportingModelController		*modelController;
//@property (strong, nonatomic)           UIPageViewController	*pageViewController;
@property (strong, nonatomic)           xhPageViewController	*pageViewController;
@end

@implementation SupportingViewController

@synthesize modelController = _modelController;
@synthesize pageIndex;

# pragma mark - View Controller Lift-cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _modelController = [[supportingModelController alloc] init];
    [self prepareData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self initPageView:pageIndex];
    [self createBottomMenu];
    //[self createPageNumLabel];
    [self checkCurrentIndexPosition];
}

- (void)viewDidAppear:(BOOL)animated {
    
//    for (UIGestureRecognizer *gesture in self.view.gestureRecognizers) {
//        gesture.delegate = self;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - View Controller Data
- (void)prepareData {
    arr_menuButton = [[NSMutableArray alloc] init];
    arr_menuTitles = [[NSMutableArray alloc] init];

    NSArray *raw = [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"supporting_data" ofType:@"plist"]] copy];

    for (NSDictionary*rawDictEach in raw) {
        [arr_menuTitles addObject:rawDictEach[@"title"]];
    }
    
    NSLog(@"pageIndex %i",pageIndex);
    
//    arr_menuTitles = @[
//                       @"History",
//                       @"Trends",
//                       @"Lifestyle & Culture",
//                       @"Facts & Figures",
//                       @"Eco-District"
//                       ];
    arr_lastIndex = @[
                      @0,
                      @1,
                      @2,
                      @3,
                      @4
                      ];
    arr_firstIndex = @[
                       @0,
                       @1,
                       @2,
                       @3,
                       @4
                       ];
}
# pragma mark - UIPageView Controller
/*
 * Init page view controller
 */
- (void)initPageView:(NSInteger)index {
    self.pageViewController = [[xhPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self.modelController;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.autoresizesSubviews =YES;
    self.pageViewController.view.frame = self.view.bounds;
    [self.pageViewController didMoveToParentViewController:self];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview: self.pageViewController.view];
    [self.pageViewController.view setBackgroundColor:[UIColor whiteColor]];
    
    [self loadPage:(int)index];
}

- (void)loadPage:(int)page {
    
    supportingDataViewController *startingViewController = [self.modelController viewControllerAtIndex:page storyboard:self.storyboard];
    currentPageIndex = page;
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    //[self setGridSwipeArea];

}

-(void)setGridSwipeArea
{
    if (currentPageIndex == animationViewIndex || gridViewIndex) {
        self.pageViewController.swipeArea = CGRectMake(22, 204, 360, 360);
    } else {
        self.pageViewController.swipeArea = CGRectZero;
    }
}

#pragma mark update page index

- (void)pageViewController:(UIPageViewController *)pvc didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    // If the page did not turn
    if (!completed)
    {
        // You do nothing because whatever page you thought you were on
        // before the gesture started is still the correct page
        NSLog(@"same page");
        return;
    }
    // This is where you would know the page number changed and handle it appropriately
    //    NSLog(@"new page");
    [self setpageIndex];
}

- (void) setpageIndex {
    supportingDataViewController *theCurrentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    currentPageIndex = (int)[self.modelController indexOfViewController:theCurrentViewController];
    [self checkCurrentIndexPosition];
    
    //[self setGridSwipeArea];
}

- (void)checkCurrentIndexPosition {
    int arrayIndex = 0;
    for (int i = 0; i < arr_lastIndex.count; i++) {
        if (currentPageIndex <= [arr_lastIndex[i] integerValue]) {
            arrayIndex = i;
            break;
        }
    }
    [self highlightButton:arr_menuButton[arrayIndex]];
    [self updatePageNumLabelText];
}

- (supportingModelController *)modelController
{
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[supportingModelController alloc] init];
    }
    return _modelController;
}

#pragma mark - Bottom Menu

- (void)createPageNumLabel {
    uil_pageNum = [[UILabel alloc] initWithFrame:CGRectMake(25.0, 709, 100, 37)];
    uil_pageNum.backgroundColor = [UIColor themeRed];
    [uil_pageNum setText:@"of"];
    [uil_pageNum setTextColor:[UIColor whiteColor]];
    [uil_pageNum setTextAlignment:NSTextAlignmentCenter];
    [uil_pageNum setFont:[UIFont fontWithName:@"GoodPro-Book" size:15.0]];
    [self.view addSubview: uil_pageNum];
}

- (void)updatePageNumLabelText {
    int arrayIndex = 0;
    for (int i = 0; i < arr_lastIndex.count; i++) {
        if (currentPageIndex <= [arr_lastIndex[i] integerValue]) {
            arrayIndex = i;
            break;
        }
    }
    
    int totalPage = [arr_lastIndex[arrayIndex] integerValue] - [arr_firstIndex[arrayIndex] integerValue] + 1;
    int currPage = totalPage - ([arr_lastIndex[arrayIndex] integerValue] - currentPageIndex);
    NSString *label_text = [NSString stringWithFormat:@"%i of %i", currPage, totalPage];
    [uil_pageNum setText:label_text];
}

- (void)createBottomMenu {
    uiv_bottomMenu = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - bottomMenuWidth)/2, self.view.bounds.size.height - 22 - bottomMenuHeight, bottomMenuWidth, bottomMenuHeight)];
    uiv_bottomMenu.clipsToBounds = YES;
    uiv_bottomMenu.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: uiv_bottomMenu];
    
    uiv_bottomHighlightView = [[UIView alloc] initWithFrame:CGRectZero];
    uiv_bottomHighlightView.backgroundColor = [UIColor themeRed];
    [uiv_bottomMenu addSubview: uiv_bottomHighlightView];
    
    for (int i = 0 ; i < arr_menuTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:arr_menuTitles[i] forState:UIControlStateNormal];
        [button sizeToFit];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont fontWithName:@"GoodPro-Book" size:15.0]];
        button.backgroundColor = [UIColor whiteColor];
        CGRect frame = button.frame;
        frame.size.width += 19;
        frame.size.height = bottomMenuHeight;
        button.frame = frame;
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
        button.tag = i;
        [button addTarget:self action:@selector(tapBottomButton:) forControlEvents:UIControlEventTouchUpInside];
        [arr_menuButton addObject: button];
    }
    for (int i = 0; i < arr_menuButton.count; i++) {
        UIButton *uib_cur = arr_menuButton[i];
        if (i > 0) {
            UIButton *uib_pre = arr_menuButton[i-1];
            CGRect frame = uib_cur.frame;
            frame.origin.x = uib_pre.frame.origin.x + uib_pre.frame.size.width;
            uib_cur.frame = frame;
        }
        [uiv_bottomMenu addSubview: uib_cur];
    }
}

- (void)highlightButton:(id)sender {
    UIButton *tappedButton = sender;
    for (UIButton *btn in arr_menuButton) {
        btn.selected = NO;
        btn.backgroundColor = [UIColor clearColor];
    }
    tappedButton.selected = YES;
//    tappedButton.backgroundColor = [UIColor themeRed];
    uiv_bottomHighlightView.backgroundColor = [UIColor themeRed];
    [UIView animateWithDuration:0.33 animations:^(void){
        uiv_bottomHighlightView.frame = tappedButton.frame;
    }];
    [self updateMainMenuHighlightButton];
}

- (void)tapBottomButton:(id)sender {
    [self highlightButton:sender];
    UIButton *tappedButton = sender;
    currentPageIndex = [arr_firstIndex[tappedButton.tag] integerValue];
    [self loadPage: currentPageIndex];
    [self updatePageNumLabelText];
}

- (void)updateMainMenuHighlightButton {
    int selectedButton = -1;
    for (UIButton *button in arr_menuButton) {
        if (button.selected) {
            selectedButton = (int)button.tag;
            break;
        }
    }
    
    NSDictionary *userInfo = @{
                               @"index": arr_firstIndex[selectedButton]
                               };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatedSupportingSideMenu" object:nil userInfo:userInfo];
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
