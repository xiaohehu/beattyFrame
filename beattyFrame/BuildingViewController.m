//
//  BuildingViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 8/3/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "BuildingViewController.h"
#import "UIColor+Extensions.h"
#import "buildingDataViewController.h"
#import "buildingModelController.h"
#import "GalleryViewController.h"
#import "LibraryAPI.h"
#import "embBuilding.h"
#import "xhWebViewController.h"

#define dataExpansion YES

@interface BuildingViewController () <UIPageViewControllerDelegate, UIGestureRecognizerDelegate>
{
    CGRect              bigContainerFrame;
    CGRect              smallContainerFrame;
    // Building menu & content
    UIImageView         *uiiv_data;
    UIView              *uiv_menuContainer;
    UIView              *uiv_buildingMenu;
    UIView              *uiv_buildingContent;
    UIButton            *uib_expand;
    // Building menu items
    UIImageView         *uiiv_viewImage;
    UILabel             *uil_viewLabel;
    UILabel             *uil_buildingName;
    NSArray             *arr_buttonIcons;
    NSMutableArray      *arr_menuButtons;
    int                 currentPageIndex;
    embBuilding         *currentBuilding;
    embBuilding *newBuilding;
   
}

@property (readonly, strong, nonatomic) buildingModelController         *modelController;
@property (strong, nonatomic)           UIPageViewController            *pageViewController;
@property (strong, nonatomic)           UIButton                        *webButton;

@end

@implementation BuildingViewController

@synthesize modelController = _modelController;
@synthesize pageIndex;

#pragma mark - View Controller Life-cycle

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _modelController = [[buildingModelController alloc] init];
    
    [self prepareData];
}

- (void)viewWillAppear:(BOOL)animated {
    if (uiv_menuContainer) {
        return;
    }
    [self prepareData];
    [self initPageView:pageIndex];
    [self createMenuContainer];
    [self createMenuItems];
}

- (void)viewDidAppear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create UI Elements

- (void)prepareData {
    arr_buttonIcons = @[
                        @"grfx_buildingGallery.jpg",
                        @"grfx_buildingPlayground.jpg",
                        @"grfx_buildingList.jpg",
                        @"grfx_buildingPre.jpg",
                        @"grfx_buildingNext.jpg"
                        ];
    
    currentBuilding = [[LibraryAPI sharedInstance] getCurrentEvent];
    NSLog(@"prepareData currentBuilding %@", currentBuilding.buildingImage);
}

- (void)createMenuContainer {
    
    bigContainerFrame = CGRectMake(571, 28, 360, 390);
    smallContainerFrame = CGRectMake(571, 28, 360, 130);
    
    uiv_menuContainer = [UIView new];
    uiv_menuContainer.frame = smallContainerFrame;
    uiv_menuContainer.clipsToBounds = YES;
    
    uiv_menuContainer.backgroundColor = [UIColor redColor];
    [self.view insertSubview:uiv_menuContainer aboveSubview:self.pageViewController.view];
    
    uiv_buildingMenu = [UIView new];
    uiv_buildingMenu.frame = CGRectMake(0.0, 0.0, 360, 130);
    uiv_buildingMenu.backgroundColor = [UIColor whiteColor];
    [uiv_menuContainer addSubview:uiv_buildingMenu];
    

    if ( dataExpansion ) {
        
        uiv_buildingContent = [UIView new];
        uiv_buildingContent.frame = CGRectMake(0.0, 130.0, 360.0, 260.0);
        uiv_buildingContent.backgroundColor = [UIColor whiteColor];
        [uiv_menuContainer addSubview: uiv_buildingContent];
        
        
        uiiv_data = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, uiv_buildingContent.frame.size.width, uiv_buildingContent.frame.size.height)];
        uiiv_data.image = [UIImage imageNamed:currentBuilding.buildingData];
        [uiv_buildingContent addSubview:uiiv_data];
        
        //[self.view addSubview:uiiv_data];
        
        //[uiv_menuContainer addSubview:uiiv_data];
    
        uib_expand = [UIButton buttonWithType:UIButtonTypeCustom];
        uib_expand.frame = CGRectMake(uiv_menuContainer.frame.origin.x + (uiv_buildingMenu.frame.size.width - 50)/2, uiv_menuContainer.frame.origin.y + uiv_buildingMenu.frame.size.height - 50/2, 50, 50);
        [uib_expand setImage:[UIImage imageNamed:@"grfx_expand.png"] forState:UIControlStateNormal];
        [uib_expand addTarget:self action:@selector(expandBuildingMenu:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: uib_expand];
    }
}

- (void)createMenuItems {
    uiiv_viewImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:currentBuilding.buildingSite]];
    uiiv_viewImage.frame = CGRectMake(0.0, 0.0, uiiv_viewImage.frame.size.width, uiiv_viewImage.frame.size.height);
    [uiv_buildingMenu addSubview: uiiv_viewImage];
    
    uil_viewLabel = [[UILabel alloc] initWithFrame:CGRectMake(11.0, 108.0, 111, 22)];
    [uil_viewLabel setText:currentBuilding.buildingSiteCaption];
    [uil_viewLabel setFont:[UIFont fontWithName:@"GoodPro-Book" size:14.0]];
    uil_viewLabel.backgroundColor =  [UIColor clearColor];
    [uiv_buildingMenu addSubview: uil_viewLabel];
    
    uil_buildingName = [[UILabel alloc] initWithFrame:CGRectMake(uiiv_viewImage.frame.origin.x+uiiv_viewImage.frame.size.width, 2.0, 202, 47)];
    [uil_buildingName setText:currentBuilding.buildingTitle];
    uil_buildingName.backgroundColor = [UIColor clearColor];
    [uiv_buildingMenu addSubview: uil_buildingName];
    
    UIView *uiv_bar = [[UIView alloc] initWithFrame:CGRectMake(uil_buildingName.frame.origin.x, uil_buildingName.frame.size.height, uil_buildingName.frame.size.width, 1.0)];
    uiv_bar.backgroundColor = [UIColor grayColor];
    [uiv_buildingMenu addSubview: uiv_bar];
    
    arr_menuButtons = [NSMutableArray new];
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((uiiv_viewImage.frame.size.width - 10) + (i * 45), uiv_bar.frame.origin.y + 1, 45, 45);
        button.tag = i;
        [button setImage:[UIImage imageNamed:arr_buttonIcons[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tapMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        [arr_menuButtons addObject: button];
        [uiv_buildingMenu addSubview: button];
    }
}

- (void)tapMenuButton:(id)sender {
    int index = (int)[sender tag];
    switch (index) {
        case 0: {
            [self loadGallery];
            break;
        }
        case 1: {
            
            break;
        }
        case 2: {
            
            break;
        }
        case 3: {
            //[self loadPage:currentPageIndex-1];
            [self determinePageIndex:3];
            break;
        }
        case 4: {
            //[self loadPage:currentPageIndex+1];
            [self determinePageIndex:4];
            break;
        }
        default:
            break;
    }
}

-(void)determinePageIndex:(int)index
{
    if (index==3) {
        if (currentPageIndex == 0) {
            currentPageIndex=8;
        }
        else {
            currentPageIndex--;
        }
    } else {
        if (index==4){
            
            if (currentPageIndex == 8) {
                currentPageIndex=0;
            } else {
                currentPageIndex++;
            }
        }
    }
    [self loadPage:currentPageIndex];
}

- (void)loadGallery {
    GalleryViewController *gallery = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryViewController"];
    [self presentViewController:gallery animated:YES completion:^(void){
        [gallery scrollToIndex:3];
    }];
}

- (void)loadPlayGround {

}

- (void)loadList {

}


- (void)expandBuildingMenu:(id)sender {
    if (uiv_menuContainer.frame.size.height > smallContainerFrame.size.height) {
        [UIView animateWithDuration:0.33
                         animations:^(void){
                             uiv_menuContainer.frame = smallContainerFrame;
                             uib_expand.transform = CGAffineTransformIdentity;
                         } completion:^(BOOL finished){
                             
                         }];
    } else {
        [UIView animateWithDuration:0.33
                         animations:^(void){
                             uib_expand.transform = CGAffineTransformTranslate(uib_expand.transform, 0.0, bigContainerFrame.size.height - smallContainerFrame.size.height);
                             uib_expand.transform = CGAffineTransformRotate(uib_expand.transform, M_PI);
                             uiv_menuContainer.frame = bigContainerFrame;
                         } completion:^(BOOL finished){
                            
                         }];
    }
}

- (IBAction)tapCloseButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeBuilding" object:nil];
}

# pragma mark - UIPageView Controller
/*
 * Init page view controller
 */
- (void)initPageView:(NSInteger)index {
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
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
    
    buildingDataViewController *startingViewController = [self.modelController viewControllerAtIndex:page storyboard:self.storyboard];
    currentPageIndex = page;
    [self setBuildingData];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
}

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
    
    NSLog(@"update data");

    [self setBuildingData];

}

-(void)setBuildingData
{
    newBuilding = [[[LibraryAPI sharedInstance] getEvents] objectAtIndex:currentPageIndex];
    [[LibraryAPI sharedInstance] setCurrentEvent:newBuilding];
    
    [uil_buildingName setText:newBuilding.buildingTitle];
    [uil_viewLabel setText:newBuilding.buildingSiteCaption];
    uiiv_viewImage.image = [UIImage imageNamed:newBuilding.buildingSite];
    
    if ( ! newBuilding.buildingWeb.length == 0) {
        NSLog(@" newbuilding.buildingWeb %@",newBuilding.buildingWeb);
        _webButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _webButton.frame = CGRectMake(307,6,40,40);
        [_webButton setImage:[UIImage imageNamed:@"grfx_buildingWeb.png"] forState:UIControlStateNormal];
        [_webButton addTarget:self action:@selector(createWebButtonWithAddress:) forControlEvents:UIControlEventTouchUpInside];
        [uiv_buildingMenu addSubview: _webButton];
    } else {
        [_webButton removeFromSuperview];
    }
    
    uiiv_data.image = [UIImage imageNamed:newBuilding.buildingData];
}

-(void)createWebButtonWithAddress:(UIButton*)address
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    xhWebViewController *vc = (xhWebViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"xhWebViewController"];
    [vc socialButton:newBuilding.buildingWeb];
    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) setpageIndex {
    buildingDataViewController *theCurrentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    currentPageIndex = (int)[self.modelController indexOfViewController:theCurrentViewController];
}
- (buildingModelController *)modelController
{
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[buildingModelController alloc] init];
    }
    return _modelController;
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
