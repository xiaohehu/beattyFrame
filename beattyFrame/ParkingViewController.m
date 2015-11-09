//
//  ParkingViewController.m
//  beattyFrame
//
//  Created by Evan Buxton on 11/9/15.
//  Copyright © 2015 Xiaohe Hu. All rights reserved.
//

#import "ParkingViewController.h"
#import "UIColor+Extensions.h"

@interface ParkingViewController ()
{
    IBOutlet UIView     *uiv_bottomContainer;
    UIView              *uiv_buttonIndicator;
    NSMutableArray      *arr_menuButton;
    NSMutableArray      *arr_highlightViews;
}

@end

@implementation ParkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    arr_highlightViews = [[NSMutableArray alloc] init];

    [self createBottomMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createBottomMenu {
    arr_menuButton = [[NSMutableArray alloc] init];
    CGRect buttonFrame = CGRectZero;
    for (int i = 0 ; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [NSString stringWithFormat:@"Phase %i",i+1];
        [button setTitle:title forState:UIControlStateNormal];
        [button sizeToFit];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"GoodPro-Book" size:15.0]];
        button.backgroundColor = [UIColor whiteColor];
        CGRect frame = button.frame;
        frame.size.width += 19;
        frame.size.height = uiv_bottomContainer.frame.size.height;
        button.frame = frame;
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
        button.tag = i;
        buttonFrame = button.frame;
        [button addTarget:self action:@selector(tapBottomButton:) forControlEvents:UIControlEventTouchUpInside];
        [arr_menuButton addObject: button];
    }
    CGFloat menuWidth = buttonFrame.size.width * 3;
    uiv_bottomContainer.frame = CGRectMake(self.view.bounds.size.width - 86 - menuWidth, self.view.bounds.size.height - 22 - 37, menuWidth, 37);
    uiv_bottomContainer.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < arr_menuButton.count; i++) {
        UIButton *button = arr_menuButton[i];
        button.frame = CGRectMake(buttonFrame.size.width*i, 0, buttonFrame.size.width, 37);
        [uiv_bottomContainer addSubview:button];
    }
    
    uiv_buttonIndicator = [[UIView alloc] initWithFrame:CGRectMake(0.0, 37 - 4.0, buttonFrame.size.width, 4.0)];
    uiv_buttonIndicator.backgroundColor = [UIColor themeRed];
    [uiv_bottomContainer addSubview: uiv_buttonIndicator];
}

- (void)tapBottomButton:(id)sender {
    UIButton *tappedButton = sender;
    
    CGRect indicatorFrame = uiv_buttonIndicator.frame;
    [UIView animateWithDuration:0.33 animations:^(void){
        uiv_buttonIndicator.frame = CGRectMake(tappedButton.frame.origin.x, indicatorFrame.origin.y, tappedButton.frame.size.width, indicatorFrame.size.height);
    }];
    
    switch (tappedButton.tag) {
        case 0: {
            break;
        }
        case 1: {
            break;
        }
        case 2: {
            break;
        }
        case 3: {
            break;
        }
        default:
            break;
    }
}


@end
