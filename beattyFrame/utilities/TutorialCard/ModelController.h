//
//  embModelController.h
//  tet
//
//  Created by Evan Buxton on 2/1/14.
//  Copyright (c) 2014 neoscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TutorialViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

@property (strong, nonatomic) NSIndexPath *indexPath;

- (TutorialViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(TutorialViewController *)viewController;

@end
