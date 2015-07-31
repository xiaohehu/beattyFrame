//
//  xhPageViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 7/31/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "xhPageViewController.h"

@interface xhPageViewController ()<UIGestureRecognizerDelegate>
{
    UIPanGestureRecognizer  *_scrollViewPanGestureRecognzier;
    CGPoint                 startPoint;
}
@end

@implementation xhPageViewController

@synthesize swipeArea;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]])
        {
            UIScrollView *scrollView = (UIScrollView *)view;
            _scrollViewPanGestureRecognzier = [[UIPanGestureRecognizer alloc] init];
            [_scrollViewPanGestureRecognzier addTarget:self action:@selector(panGestureAction:)];
            _scrollViewPanGestureRecognzier.delegate = self;
            [scrollView addGestureRecognizer:_scrollViewPanGestureRecognzier];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGRect frame = swipeArea;
    if (gestureRecognizer == _scrollViewPanGestureRecognzier)
    {
        CGPoint locationInView = [gestureRecognizer locationInView:self.view];
        if (CGRectContainsPoint(frame, locationInView))
        {
            return YES;
        }
        return NO;
    }
    return NO;
}

- (void)panGestureAction:(UIPanGestureRecognizer *)gesture
{
    CGPoint velocity = [gesture velocityInView:self.view];
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if(velocity.x > 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"swipeRight" object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"swipeLeft" object:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
