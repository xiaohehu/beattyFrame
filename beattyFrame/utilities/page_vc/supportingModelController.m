//
//  embModelController.m
//  Example
//
//  Created by Evan Buxton on 11/23/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import "supportingDataViewController.h"
#import "supportingModelController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface supportingModelController()
@property (readonly, strong, nonatomic) NSArray *pageData;
@end

@implementation supportingModelController

-(id)initWithArray:(NSArray*)pages
{
    self = [super init];
    if (self) {
        //_pages = pages;
        _pageData = [NSArray arrayWithArray:pages][0];
        NSLog(@"_pages %@",_pageData);
    }
    return self;
}

//- (id)init
//{
//    self = [super init];
//    if (self) {
//		// Create the data model.
//		//_pageData = [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"supporting_data" ofType:@"plist"]] copy];
//        _pageData = [NSArray arrayWithArray:_pages];
//        NSLog(@"_pageData %@",_pageData);
//    }
//    return self;
//}

- (supportingDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{
    
    NSLog(@"%ld [self.pageData count]",[self.pageData count]);

    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    
    
    // Create a new view controller and pass suitable data.
    supportingDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"supportingDataViewController"];
    dataViewController.dataObject = self.pageData[index];
    NSLog(@"self.pageData[index] %@",self.pageData[index]);

    dataViewController.vcIndex = index;
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(supportingDataViewController *)viewController
{   
     // Return the index of the given data view controller.
     // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pageData indexOfObject:viewController.dataObject];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(supportingDataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController

{
    NSUInteger index = [self indexOfViewController:(supportingDataViewController *)viewController];
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
