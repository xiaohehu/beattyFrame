//
//  animationView.m
//  beatty_animation
//
//  Created by Xiaohe Hu on 7/20/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "animationView.h"

static float    smallGridSize = 117.0;
static float    largeGridSize = 360.0;

@interface animationView() {
    
    BOOL            expanded;
    BOOL            largeGrid;
    int             currentIndex;
    UIView          *uiv_gridContainer;
    UIView          *uiv_textContent;
    UIView          *uiv_indicatorContainer;
    UIButton        *uib_arrow;
    NSMutableArray  *arr_grids;
    NSMutableArray  *arr_indicator;
    NSMutableArray  *arr_smallImages;
    NSMutableArray  *arr_largeImages;
    NSMutableArray  *arr_checkedIndex;
}

@end

@implementation animationView

#pragma mark - View's life cycle
- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0,0,1024,768)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *uiiv_bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lifeStyle_bg.jpg"]];
        uiiv_bg.frame = self.bounds;
        [self addSubview: uiiv_bg];
        
        [self createGridArray];
        [self setupHierarchy];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        UIImageView *uiiv_bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lifeStyle_bg.jpg"]];
        uiiv_bg.frame = self.bounds;
        [self addSubview: uiiv_bg];
        
        [self createGridArray];
        [self setupHierarchy];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {

}

- (void)didMoveToSuperview {
    [self performSelector:@selector(loadInAnimaiton) withObject:nil afterDelay:1.0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swipeLeftGrib:) name:@"swipeLeft" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swipeRightGrib:) name:@"swipeRight" object:nil];
}

#pragma mark - Init all UI elements
- (void)createGridArray {
    // Init all grid views
    arr_grids = [[NSMutableArray alloc] init];
    arr_smallImages = [[NSMutableArray alloc] init];
    arr_largeImages = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 9; i++) {
        UIImageView *uiiv = [UIImageView new];
        [arr_grids addObject:uiiv];
        [arr_smallImages addObject:[NSString stringWithFormat:@"fact-grid-0%i-sm.png",i+1]];
        [arr_largeImages addObject:[NSString stringWithFormat:@"fact-grid-0%i-lg.png",i+1]];
        
        // Set tag to grid views
        [arr_grids[i] setTag: i];
        UIImageView *grid = arr_grids[i];
        [grid setImage:[UIImage imageNamed:arr_smallImages[i]]];
    }
}

- (void)setupHierarchy {

    uiv_gridContainer = [[UIView alloc] initWithFrame:CGRectMake(22, 204, largeGridSize, largeGridSize)];
    uiv_gridContainer.backgroundColor = [UIColor clearColor];
    uiv_gridContainer.clipsToBounds = YES;
    [self addSubview: uiv_gridContainer];
    // Grid top space against container
    float gridTopGap = 2.0;
    // Grid size 117, space between 2 gird is 3
    float gridAndGap = 120;
    
    for (UIImageView *grid in arr_grids) {
        // Column position
        int x_position = (int)grid.tag%3;
        // Row position
        int y_position = (int)grid.tag/3;
        grid.frame = CGRectMake(x_position * gridAndGap, y_position * gridAndGap+gridTopGap, smallGridSize, smallGridSize);
        grid.backgroundColor = [UIColor colorWithRed:30.0*grid.tag/255.0 green:18.0*grid.tag/255.0 blue:20.0*grid.tag/255.0 alpha:1.0];
        [uiv_gridContainer addSubview: grid];
        grid.alpha = 0.0;
    }
    
    float expandButtonSize = 40;
    float expandButtonX = 342;
    float expandButtonY = 364;
    uib_arrow = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_arrow.frame = CGRectMake(expandButtonX, expandButtonY, expandButtonSize, expandButtonSize);
    uib_arrow.backgroundColor = [UIColor clearColor];
    [uib_arrow setImage:[UIImage imageNamed:@"grfx-arrow-right.png"] forState:UIControlStateNormal];
    [self insertSubview:uib_arrow belowSubview:uiv_gridContainer];
    uib_arrow.hidden = YES;
    [uib_arrow addTarget:self action:@selector(tapArrowButtonOpen:) forControlEvents:UIControlEventTouchUpInside];
    
    uiv_textContent = [[UIView alloc] initWithFrame:CGRectMake(380, 100, 271, 167)];
    uiv_textContent.backgroundColor = [UIColor clearColor];
    uiv_textContent.alpha = 0.8;
    UIImageView *textImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fact-copy-01.png"]];;
    [uiv_textContent addSubview: textImage];
    [uiv_gridContainer addSubview: uiv_textContent];
    
    [self createIndicatorView];
}

- (void)createIndicatorView {
    /*
     * Indicator view is hidden by default
     * When a grid is expanded, indicator will show up
     */
    uiv_indicatorContainer = [[UIView alloc] initWithFrame:CGRectMake(326, 5, 30, 30)];
    uiv_indicatorContainer.backgroundColor = [UIColor whiteColor];
    UIView *uiv_indicator = [[UIView alloc] initWithFrame:CGRectMake(6, 6, 17, 17)];
    [uiv_indicatorContainer addSubview: uiv_indicator];
    
    [uiv_gridContainer addSubview: uiv_indicatorContainer];
    uiv_indicatorContainer.hidden = YES;
    
    UIColor *uic_normal = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0];
    
    arr_indicator = [[NSMutableArray alloc] init];
    for (int i = 0; i < 9; i++) {
        UIView *uiv = [UIView new];
        [arr_indicator addObject:uiv];
    }

    for (int i = 0; i < arr_indicator.count; i++) {
        [arr_indicator[i] setTag:i];
    }
    /*
     * Small grid's size is 5.0
     * Space between grids is 1.0;
     */
    float smallGridAndSpace = 6.0;
    float smallGridSize = 5.0;
    
    for (UIView *indicator in arr_indicator) {
        // Column position
        int x_position = (int)indicator.tag%3;
        // Row position
        int y_position = (int)indicator.tag/3;
        indicator.frame = CGRectMake(x_position * smallGridAndSpace, y_position * smallGridAndSpace, smallGridSize, smallGridSize);
        indicator.backgroundColor = uic_normal;
        [uiv_indicator addSubview: indicator];
    }
    
    UITapGestureRecognizer *tapOnIndicator = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetWholeGrids:)];
    uiv_indicatorContainer.userInteractionEnabled = YES;
    [uiv_indicatorContainer addGestureRecognizer: tapOnIndicator];
}

#pragma mark - Initial Animation
- (void)loadInAnimaiton {
    for (UIImageView *grid in arr_grids) {
        int x_position = (int)grid.tag%3;
        int y_position = (int)grid.tag/3;
        float animation_time = 0.6-0.1*x_position-0.1*y_position;
        [UIView animateWithDuration:animation_time delay:animation_time/2 options:0 animations:^(void){
            grid.alpha = 1.0;
        } completion:^(BOOL finished){
            UITapGestureRecognizer *tapOnGrid = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandGrid:)];
            grid.userInteractionEnabled = YES;
            [grid addGestureRecognizer: tapOnGrid];
        }];
    }
}

#pragma mark - Logic programming tool
- (void)checkIndex:(int)index {
    
    if (arr_checkedIndex == nil) {
        arr_checkedIndex = [[NSMutableArray alloc] init];
    }
    
    NSNumber *indexNum = [NSNumber numberWithInt:index];
    for (NSNumber *index in arr_checkedIndex) {
        if (indexNum == index) {
            return;
        }
    }
    [arr_checkedIndex addObject: indexNum];
}

#pragma mark - Button action / UIGesture action

#pragma mark Reset all grids
- (void)resetWholeGrids:(UIGestureRecognizer *)gesture {
    // Reset indicator's color and hide
    [self resetIndicatorColor];

    // If detail text is on, close it first
    if (expanded) {
        [self tapArrowButtonClose:nil];
        [self performSelector:@selector(resetToGrids) withObject:nil afterDelay:0.5];
    } else {
        [self resetToGrids];
        uiv_indicatorContainer.hidden = YES;
    }
    largeGrid = NO;
}

- (void)resetToGrids {
    
    uiv_indicatorContainer.hidden = YES;

    float gridTopGap = 2.0;
    float gridAndGap = 120;
    
    float expandButtonSize = 40;
    float expandButtonX = 342;
    float expandButtonY = 364;
    
    /*
     * Reset all grids on back to original position
     */
    for (UIImageView *grid in arr_grids) {
        if (grid.tag != currentIndex) {
            int x_position = (int)grid.tag%3;
            int y_position = (int)grid.tag/3;
            grid.frame = CGRectMake(x_position * gridAndGap, y_position * gridAndGap+gridTopGap, smallGridSize, smallGridSize);
            [grid setImage:[UIImage imageNamed:arr_smallImages[grid.tag]]];
            
            // set all z's to 0 so we can bring the selected one to the front
            grid.layer.zPosition=0;
        }
    }
    /*
     * Animate current big grid back to original position
     * Set all the rest grids alpha value as 1.0
     * Move arrow button
     */
    UIImageView *currentView = arr_grids[currentIndex];
    
    // bring the selected view zindex to the front
    currentView.layer.zPosition = 1;
    
    UIImage * toImage = [UIImage imageNamed:arr_smallImages[currentIndex]];
    [UIView transitionWithView:self
                      duration:0.2f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        currentView.image = toImage;
                    } completion:^(BOOL finished)
     {
         
         [UIView animateWithDuration:0.5 animations:^(void){
             int x_position = (int)currentView.tag%3;
             int y_position = (int)currentView.tag/3;
             currentView.frame = CGRectMake(x_position * gridAndGap, y_position * gridAndGap+gridTopGap, smallGridSize, smallGridSize);
             
             //[currentView setImage:[UIImage imageNamed:arr_smallImages[currentIndex]]];
             
             for (UIImageView *grid in arr_grids) {
                 grid.alpha = 1.0;
                 NSNumber *tagNum = [NSNumber numberWithInt:grid.tag];
                 for (NSNumber *index in arr_checkedIndex) {
                     if (tagNum == index) {
                         grid.alpha = 0.9;
                     }
                 }
             }
             
             uib_arrow.frame = CGRectMake(expandButtonX + 60, expandButtonY, expandButtonSize, expandButtonSize);
             
         } completion:^(BOOL finished){
             /*
              * Move arrow button layer under girds' contaier
              * Remove siwpe getsture from grids and add tap gesture to them
              * Move arrow button's position to original
              */
             
             currentView.layer.zPosition = 0;
             
             uiv_indicatorContainer.hidden = YES;

             [self insertSubview:uib_arrow belowSubview:uiv_gridContainer];
             for (UIImageView *grid in arr_grids) {
                 for (UIGestureRecognizer *gesture in grid.gestureRecognizers) {
                     [grid removeGestureRecognizer: gesture];
                 }
                 UITapGestureRecognizer *tapOnGrid = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandGrid:)];
                 grid.userInteractionEnabled = YES;
                 [grid addGestureRecognizer: tapOnGrid];
             }
             [UIView animateWithDuration:0.33 animations:^(void){
                 uib_arrow.frame = CGRectMake(expandButtonX, expandButtonY, expandButtonSize, expandButtonSize);
             } completion:^(BOOL finished){
                 uib_arrow.hidden = YES;
             }];
         }];
     }];
}

/*
 * Reset indicators color to gray
 */
- (void)resetIndicatorColor {
    for (UIView *grid in arr_indicator) {
        grid.backgroundColor = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0];
    }
}

- (void)updateIndicatorColor {
    
    UIColor *uic_normal = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0];
    UIColor *uic_selected = [UIColor colorWithRed:216.0/255.0 green:35.0/255.0 blue:42.0/255.0 alpha:1.0];
    
    for (UIView *indicator in arr_indicator) {
        indicator.backgroundColor = uic_normal;
        if (indicator.tag == currentIndex) {
            indicator.backgroundColor = uic_selected;
        }
    }
}
#pragma mark Tap Small Grid to expand
- (void)expandGrid:(UIGestureRecognizer *)gesture {
    
    uib_arrow.alpha = 0.0;
    uib_arrow.hidden = NO;
    largeGrid = YES;
    
    currentIndex = (int)[gesture.view tag];
    
    [self checkIndex:currentIndex];
    
    [self updateIndicatorColor];
    
    float expandButtonSize = 40;
    float expandButtonX = 342;
    float expandButtonY = 364;
    
    UIImageView*selected = arr_grids[currentIndex];
    
    UIImage * toImage = [UIImage imageNamed:arr_largeImages[currentIndex]];
    [UIView transitionWithView:self
                      duration:0.2f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [selected setImage:toImage];

                    } completion:^(BOOL finished)
     {
         
         [UIView animateWithDuration:0.5 animations:^(void){
             
             [gesture view].frame = uiv_gridContainer.bounds;
             
             // bring the selected one to the front
             [gesture view].layer.zPosition = 1;
             
             for (UIImageView *grid in arr_grids) {
                 if ([grid isEqual: gesture.view]) {
                     grid.alpha = 1.0;
                     continue;
                 } else {
                     grid.alpha = 0.0;
                 }
             }
             
         } completion:^(BOOL finished){
             
             uib_arrow.alpha = 1.0;
             uiv_indicatorContainer.alpha = 0.0;
             uiv_indicatorContainer.hidden = NO;
             
             [UIView animateWithDuration:0.5 animations:^(void){
//                 uiv_indicatorContainer.hidden = NO;
                 uib_arrow.frame = CGRectMake(expandButtonX + 60, expandButtonY, expandButtonSize, expandButtonSize);
                 
             } completion:^(BOOL finished){
                 // now set it to the back again so the text view appears over the top
                 [gesture view].layer.zPosition = 0;
                 [self bringSubviewToFront:uib_arrow];
                 
                 [UIView animateWithDuration:0.3 animations:^(void){
                     uiv_indicatorContainer.alpha = 1.0;
                     uib_arrow.frame = CGRectMake(expandButtonX + 20, expandButtonY, expandButtonSize, expandButtonSize);
                 }];
                 /*
                  * Updated gesture of grid (From tap to swipe)
                  */
                 for (UIImageView *grid in arr_grids) {
                     
                     [grid setImage:[UIImage imageNamed:arr_largeImages[currentIndex]]];
                     
                     for (UIGestureRecognizer *gesture in grid.gestureRecognizers) {
                         [grid removeGestureRecognizer: gesture];
                     }
                     
                     UISwipeGestureRecognizer *swipeLeftOnGrib = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftGrib:)];
                     swipeLeftOnGrib.direction = UISwipeGestureRecognizerDirectionLeft;
                     [grid addGestureRecognizer: swipeLeftOnGrib];
                     
                     UISwipeGestureRecognizer *swipeRightOnGrib = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightGrib:)];
                     swipeRightOnGrib.direction = UISwipeGestureRecognizerDirectionRight;
                     [grid addGestureRecognizer: swipeRightOnGrib];
                 }
             }];
             
         }];
     
     }];
}

#pragma mark Swipe on big grid to load next/previous one
- (void)swipeLeftGrib:(UIGestureRecognizer *)gesture {
    /*
     * If detail text view is expanded, close it first then load next gird
     */
    if (!largeGrid) {
        return;
    }
    
    if (expanded) {
        [self tapArrowButtonClose:nil];
        [self performSelector:@selector(loadGrid:) withObject:[NSNumber numberWithInt:1] afterDelay:0.5];
        return;
    } else {
        [self loadGrid:[NSNumber numberWithInt:1] ];
    }
}

- (void)swipeRightGrib:(UIGestureRecognizer *)gesture {
    /*
     * If detail text view is expanded, close it first then load previous gird
     */
    if (!largeGrid) {
        return;
    }
    
    if (expanded) {
        [self tapArrowButtonClose:nil];
        [self performSelector:@selector(loadGrid:) withObject:[NSNumber numberWithInt:-1] afterDelay:0.5];
        return;
    } else {
        [self loadGrid:[NSNumber numberWithInt:-1]];
    }
}

/*
 * If direction is > 0, load next
 * If direction is < 0, load previous
 */
- (void)loadGrid:(NSNumber *)direc {
    /*
     * Check direction
     * And set next grid's index
     */
    int direction = [direc intValue];
    int nextIndex = 0;
    
    if (direction == 0) {
        return;
    } else if (direction > 0) {
        direction = 1;
        nextIndex = 0;
        if (currentIndex != 8) {
            nextIndex = currentIndex + 1;
        }
    } else {
        direction = -1;
        nextIndex = 8;
        if (currentIndex != 0) {
            nextIndex = currentIndex - 1;
        }
    }
    /*
     * According to direction move next grid to current one's left/right
     */
    UIImageView *nextView = arr_grids[nextIndex];
    nextView.image = [UIImage imageNamed:arr_largeImages[nextIndex]];
    UIImageView *currView = arr_grids[currentIndex];
    currView.image = [UIImage imageNamed:arr_largeImages[currentIndex]];
    nextView.frame = uiv_gridContainer.bounds;
    nextView.transform = CGAffineTransformMakeTranslation(largeGridSize * direction, 0.0);
    nextView.alpha = 1.0;
    [UIView animateWithDuration:0.33 animations:^(void){
        nextView.transform = CGAffineTransformIdentity;
        currView.transform = CGAffineTransformMakeTranslation(largeGridSize * -direction, 0.0);
    } completion:^(BOOL finished){
        currView.transform = CGAffineTransformIdentity;
        currView.alpha = 0.0;
        currentIndex = nextIndex;
        [self checkIndex:currentIndex];
        [self updateIndicatorColor];
    }];
}

#pragma mark Tap on arrow button to expand/hide detail view
- (void)tapArrowButtonOpen:(id)sender {
    
    uiv_gridContainer.backgroundColor = [UIColor whiteColor];
    expanded = YES;
    float moveDistance = 250.0;
    
    CGAffineTransform move = CGAffineTransformMakeTranslation(moveDistance, 0.0);
    CGAffineTransform rotation = CGAffineTransformRotate(move, M_PI);
    
    [UIView animateWithDuration:0.5 animations:^(void){
        uiv_gridContainer.frame = CGRectMake(uiv_gridContainer.frame.origin.x, uiv_gridContainer.frame.origin.y, 610, uiv_gridContainer.frame.size.height);
        uib_arrow.transform = rotation;
        uiv_textContent.alpha = 1.0;
        uiv_textContent.transform = CGAffineTransformMakeTranslation(-70, 0.0);
        uiv_indicatorContainer.transform = CGAffineTransformMakeTranslation(moveDistance, 0.0);
    } completion:^(BOOL finished){
        [uib_arrow removeTarget:self action:@selector(tapArrowButtonOpen:) forControlEvents:UIControlEventAllEvents];
        [uib_arrow addTarget:self action:@selector(tapArrowButtonClose:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)tapArrowButtonClose:(id)sender {
    
    expanded = NO;
    
    [UIView animateWithDuration:0.5 animations:^(void){
        uiv_gridContainer.frame = CGRectMake(uiv_gridContainer.frame.origin.x, uiv_gridContainer.frame.origin.y, 360, uiv_gridContainer.frame.size.height);
        uib_arrow.transform = CGAffineTransformIdentity;
        uiv_textContent.alpha = 0.8;
        uiv_textContent.transform = CGAffineTransformIdentity;
        uiv_indicatorContainer.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        uiv_gridContainer.backgroundColor = [UIColor clearColor];
        [uib_arrow removeTarget:self action:@selector(tapArrowButtonClose:) forControlEvents:UIControlEventAllEvents];
        [uib_arrow addTarget:self action:@selector(tapArrowButtonOpen:) forControlEvents:UIControlEventTouchUpInside];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
