//
//  embDataViewController.m
//  Example
//
//  Created by Evan Buxton on 11/23/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import "supportingDataViewController.h"
#import "ebUIViewWithInteractiveScrollView.h"
#import "xhWebViewController.h"

@interface supportingDataViewController ()

@property (nonatomic, strong) ebUIViewWithInteractiveScrollView			*zoomingScroll;
@property (nonatomic, strong) NSDictionary                              *dict;

@end

@implementation supportingDataViewController
@synthesize vcIndex;
- (void)viewDidLoad
{
    [super viewDidLoad];
    _dict = self.dataObject;
    [self loadDataAndView];
}

#pragma mark - LAYOUT FLOOR PLAN DATA
-(void)loadDataAndView
{
    if (!_zoomingScroll) {
        CGRect theFrame = self.view.bounds;
        _zoomingScroll = [[ebUIViewWithInteractiveScrollView alloc] initWithFrame:theFrame image:[UIImage imageNamed:_dict[@"image"]] overlay:_dict[@"source"] overlayTwo:nil shouldZoom:YES];
        [self.view addSubview:_zoomingScroll];
        _zoomingScroll.backgroundColor = [UIColor clearColor];
        _zoomingScroll.delegate=self;
    }
    
    if ([_dict objectForKey:@"buildingWeb"]) {
        [self createWebButton];
    }
}

-(void)loadInImge:(NSString *)imageName
{
    [UIView animateWithDuration:0.0 animations:^{
        _zoomingScroll.blurView.alpha = 0.0;
    } completion:^(BOOL finished){
        _zoomingScroll.blurView.image = [UIImage imageNamed:imageName];
        [UIView animateWithDuration:0.3 animations:^{
            _zoomingScroll.blurView.alpha = 1.0;
        }];
    }];
}

-(void)createWebButton
{
    NSArray*arr = [_dict objectForKey:@"buildingWeb"];
    
    for (int i = 0; i < arr.count; i++)
    {
        UIButton *webButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *text = arr[i];
        
        webButton.frame = CGRectMake(485 , 500 + (i * 30) , 180 , 40);
        
        [webButton addTarget:self action:@selector(createWebButtonWithAddress:) forControlEvents:UIControlEventTouchUpInside];
        
        [webButton setTitle:text forState:UIControlStateNormal];
        [webButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];

        webButton.showsTouchWhenHighlighted = YES;
        webButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_zoomingScroll.blurView addSubview:webButton];
    }
}

-(void)createWebButtonWithAddress:(UIButton*)address
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    xhWebViewController *vc = (xhWebViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"xhWebViewController"];
    [vc socialButton:address.titleLabel.text];
    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - BOILERPLATE
- (void)viewWillAppear:(BOOL)animated
{   [super viewWillAppear:animated];   }

- (void)didReceiveMemoryWarning
{   [super didReceiveMemoryWarning];   }

@end
