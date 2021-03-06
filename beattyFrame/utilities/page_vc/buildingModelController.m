//
//  buildingModelController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 8/19/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "buildingModelController.h"
#import "buildingDataViewController.h"
#import "LibraryAPI.h"

@interface buildingModelController()
@property (readonly, strong, nonatomic) NSArray *pageData;
@end

@implementation buildingModelController
- (id)init
{
    self = [super init];
    if (self) {
        // Create the data model.
//        _pageData = [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"building_data" ofType:@"plist"]] copy];
        
        _pageData = [[LibraryAPI sharedInstance] getCurrentEvents];

    }
    return self;
}

- (buildingDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    buildingDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"buildingDataViewController"];
    dataViewController.dataObject = self.pageData[index];
    dataViewController.vcIndex = index;
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(buildingDataViewController *)viewController
{
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pageData indexOfObject:viewController.dataObject];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(buildingDataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(buildingDataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
