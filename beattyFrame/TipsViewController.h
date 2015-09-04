//
//  embLoginViewController.h
//  rxrnorthhills
//
//  Created by Evan Buxton on 7/13/14.
//  Copyright (c) 2014 neoscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TipsViewControllerDelegate <NSObject>

@optional
// alert delegate that the login was successful
-(void)embLoginSuccess:(BOOL)success;
@end

@interface TipsViewController : UIViewController
@property (weak)			id<TipsViewControllerDelegate>	delegate;
@end
