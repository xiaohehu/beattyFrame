//
//  TutorialPageViewController.h
//  embTutorialCard
//
//  Created by Evan Buxton on 9/1/15.
//  Copyright (c) 2015 Evan Buxton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tutorial.h"
#import "FLAnimatedImage.h"

@interface TutorialViewController : UIViewController

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *uiiv_tutorial;
@property (weak, nonatomic) IBOutlet UIImageView *uiiv_icon;
@property (weak, nonatomic) IBOutlet UILabel *uil_Title;
@property (weak, nonatomic) IBOutlet UILabel *uil_Subtitle;
@property (weak, nonatomic) IBOutlet UITextView *uitv_description;
@property (weak, nonatomic) IBOutlet UILabel *uil_tip;
@property (weak, nonatomic) IBOutlet UILabel *uil_numbering;
@property (weak, nonatomic) IBOutlet UILabel *uil_note;

@property (strong, nonatomic) id dataObject;
@property NSNumber *pageIndex;
@property (assign, nonatomic) NSInteger indexNumber;
@property (nonatomic, strong) Tutorial *tutorial;
@property NSUInteger pagetotal;

@end
