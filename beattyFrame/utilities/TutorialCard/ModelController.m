//
//  embModelController.m
//  tet
//
//  Created by Evan Buxton on 2/1/14.
//  Copyright (c) 2014 neoscape. All rights reserved.
//

#import "ModelController.h"
#import "TutorialPageViewController.h"
/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface ModelController()
@property (readonly, strong, nonatomic) NSMutableArray *pageData;
@property (readonly, strong, nonatomic) NSMutableArray *sectionData;

@end

@implementation ModelController

- (id)init
{
    self = [super init];
    if (self) {
		// Create the data model
        NSString *textPath = [[NSBundle mainBundle] pathForResource:@"tutorials" ofType:@"json"];
        
        NSError *error;
        NSString *content = [NSString stringWithContentsOfFile:textPath encoding:NSUTF8StringEncoding error:&error];  //error checking omitted
        NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        
        _sectionData = [[NSMutableArray alloc] init];
        _pageData = [[NSMutableArray alloc] init];
        
        NSArray *rawArray = [returnedDict objectForKey:@"helpsystem"];
        
        for (NSDictionary*dict in rawArray) {
            [_sectionData addObject:dict];
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSInteger loadrows = [userDefaults integerForKey:@"saverows"];
        
        for (int i=0; i < [[_sectionData[loadrows] objectForKey:@"tutorials"]count]; i++) {
            [_pageData addObject:[_sectionData[loadrows] objectForKey:@"tutorials"][i]];
        }
    }
    return self;
}

- (TutorialViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{   
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
     
    // Create a new view controller and pass suitable data.
    TutorialViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
    dataViewController.dataObject = self.pageData[index];
    dataViewController.pageIndex = [NSNumber numberWithInteger:index];
    NSLog(@"indexxx %lu",(unsigned long)index);
    dataViewController.indexNumber = index;
    dataViewController.pagetotal = _pageData.count;

    return dataViewController;
}

- (NSUInteger)indexOfViewController:(TutorialViewController *)viewController
{   
     // Return the index of the given data view controller.
     // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pageData indexOfObject:viewController.dataObject];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [(TutorialViewController *)viewController indexNumber];
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [(TutorialViewController *)viewController indexNumber];

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
