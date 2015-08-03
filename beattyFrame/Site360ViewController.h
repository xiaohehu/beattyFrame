//
//  Site360ViewController.h
//  beattyFrame
//
//  Created by Xiaohe Hu on 7/23/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerImageView.h"

@interface Site360ViewController : UIViewController <UIGestureRecognizerDelegate, UIScrollViewDelegate, UIAlertViewDelegate>
{
    BOOL isColorPicked;
    BOOL isColorEligible;
    
    // image array ints
    NSUInteger  currentIndex;
    NSArray     *namesArray;
    NSUInteger  currentFrame;
    NSUInteger  numberOfFrames;
    NSUInteger  finalEndFrame;
    NSUInteger  phaseIndex;
    NSString    *incomingColor;
}

- (void) pickedColor:(UIColor*)color;

@property (weak, nonatomic) IBOutlet UIScrollView *uis_scrollView;
@property (weak, nonatomic) IBOutlet UIView *uiv_container;
@property (weak, nonatomic) IBOutlet UIImageView *uiiv_imageView;
@property (strong, nonatomic) IBOutlet ColorPickerImageView *colorWheel;
@end
