//
//  sponsorshipModelController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 8/17/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "sponsorshipModelController.h"
#import "sponsorDataViewController.h"

@interface sponsorshipModelController()
@property (readonly, strong, nonatomic) NSArray *pageData;
@end

@implementation sponsorshipModelController
- (id)init
{
    self = [super init];
    if (self) {
        // Create the data model.
        _pageData = [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sponsorship_data" ofType:@"plist"]] copy];
    }
    return self;
}

- (sponsorDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    sponsorDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"sponsorDataViewController"];
    dataViewController.dataObject = self.pageData[index];
    dataViewController.vcIndex = index;
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(sponsorDataViewController *)viewController
{
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pageData indexOfObject:viewController.dataObject];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(sponsorDataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(sponsorDataViewController *)viewController];
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
