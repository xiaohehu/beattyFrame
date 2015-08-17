//
//  sponsorshipModelController.h
//  beattyFrame
//
//  Created by Xiaohe Hu on 8/17/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class sponsorDataViewController;

@interface sponsorshipModelController : NSObject <UIPageViewControllerDataSource>

- (sponsorDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(sponsorDataViewController *)viewController;

@end
