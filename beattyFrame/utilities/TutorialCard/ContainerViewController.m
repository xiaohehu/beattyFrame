//
//  ViewController.m
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "ContainerViewController.h"
#import "TutorialPageViewController.h"
#import "ModelController.h"
#import "Tutorial.h"

@interface ContainerViewController () <UIGestureRecognizerDelegate> {
    UIView *helpHolder;
    NSUInteger indexOfCCurrentViewController;
    TutorialViewController *currentView;
}

@property (readonly, strong, nonatomic) ModelController *modelController;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) TutorialViewController *startingViewController;

@end

@implementation ContainerViewController

@synthesize modelController = _modelController;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)createPageViewController
{
    if (self.pageViewController == nil) {
        self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        self.pageViewController.delegate = self;
    }
    
    TutorialViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.dataSource = self.modelController;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
   [self.pageViewController didMoveToParentViewController:self];
}

-(void)deletePageViewController
{
    [self.pageViewController  willMoveToParentViewController:nil];
    [self.pageViewController.view removeFromSuperview];
    [self.pageViewController removeFromParentViewController];
    self.pageViewController = nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    currentView = [self.pageViewController.viewControllers lastObject];
    indexOfCCurrentViewController = currentView.indexNumber;
}

- (ModelController *)modelController
{
	// Return the model controller object, creating it if necessary.
	// In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[ModelController alloc] init];
    }
    return _modelController;
}

#pragma mark - load data page within pvc
-(void)loadPage:(int)page
{
    [self createPageViewController];
    _startingViewController = [self.modelController viewControllerAtIndex:page storyboard:self.storyboard];
    self.modelController.indexPath = _indexPath;
    
    if (_startingViewController != nil) {
        
        NSArray *viewControllers = @[_startingViewController];

        [self.pageViewController setViewControllers:viewControllers
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
    }
}

#pragma mark - Notifications
#pragma mark Open List View
-(void)handleNotification:(NSNotification *)pNotification
{
    NSLog(@"handleNotification");
    NSDictionary* userInfo = pNotification.userInfo;
    int page = [[userInfo objectForKey:@"myRow"] intValue];
    [self loadPage:page];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
