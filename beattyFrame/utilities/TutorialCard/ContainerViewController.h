//
//  ViewController.h
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tutorial.h"

@interface ContainerViewController : UIViewController <UIPageViewControllerDelegate>
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSArray *data;
-(void)loadPage:(int)page;
@end
