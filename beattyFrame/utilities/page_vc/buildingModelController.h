//
//  buildingModelController.h
//  beattyFrame
//
//  Created by Xiaohe Hu on 8/19/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class buildingDataViewController;

@interface buildingModelController : NSObject <UIPageViewControllerDataSource>

- (buildingDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(buildingDataViewController *)viewController;

@end
