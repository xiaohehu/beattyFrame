//
//  SupportingViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 7/29/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "SupportingViewController.h"
#import "embModelController.h"
#import "embDataViewController.h"
static CGFloat  bottomMenuWidth = 570;
static CGFloat  bottomMenuHeight = 37;
@interface SupportingViewController ()<UIPageViewControllerDelegate>
{
    UIView          *uiv_bottomMenu;
    NSArray         *arr_menuTitles;
    NSMutableArray  *arr_menuButton;
}

@property (readonly, strong, nonatomic) embModelController		*modelController;
@property (strong, nonatomic)           UIPageViewController	*pageViewController;

@end

@implementation SupportingViewController

@synthesize modelController = _modelController;

# pragma mark - View Controller Lift-cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _modelController = [[embModelController alloc] init];
    [self prepareData];
    [self initPageView:0];
    [self createBottomMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - View Controller Data
- (void)prepareData {
    arr_menuButton = [[NSMutableArray alloc] init];
    
    arr_menuTitles = @[
                       @"History",
                       @"Trends",
                       @"Lifestyle & Culture",
                       @"Facts & Figures",
                       @"Eco-District"
                       ];
}
# pragma mark - Create UI elements
-(void)initPageView:(NSInteger)index {
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self.modelController;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.autoresizesSubviews =YES;
    self.pageViewController.view.frame = self.view.bounds;
    [self.pageViewController didMoveToParentViewController:self];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview: self.pageViewController.view];
    [self.pageViewController.view setBackgroundColor:[UIColor redColor]];
    
    [self loadPage:(int)index];
}

-(void)loadPage:(int)page {
    
    embDataViewController *startingViewController = [self.modelController viewControllerAtIndex:page storyboard:self.storyboard];
    
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
}

- (embModelController *)modelController
{
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[embModelController alloc] init];
    }
    return _modelController;
}

- (void)createBottomMenu {
    uiv_bottomMenu = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - bottomMenuWidth)/2, self.view.bounds.size.height - 22 - bottomMenuHeight, bottomMenuWidth, bottomMenuHeight)];
    uiv_bottomMenu.clipsToBounds = YES;
    uiv_bottomMenu.backgroundColor = [UIColor redColor];
    [self.view addSubview: uiv_bottomMenu];
    
    for (int i = 0 ; i < arr_menuTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:arr_menuTitles[i] forState:UIControlStateNormal];
        [button sizeToFit];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        if (i%2 == 0) {
            button.backgroundColor = [UIColor whiteColor];
        }
        CGRect frame = button.frame;
        frame.size.width += 19;
        frame.size.height = bottomMenuHeight;
        button.frame = frame;
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
        button.tag = i;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
