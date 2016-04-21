//
//  sponsorDataViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 8/17/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "sponsorDataViewController.h"
#import "ebZoomingScrollView.h"
#import "UIColor+Extensions.h"
#import "xhWebViewController.h"

@interface sponsorDataViewController ()

@property (nonatomic, strong) ebZoomingScrollView			*zoomingScroll;
@property (nonatomic, strong) NSDictionary                  *dict;

@end

@implementation sponsorDataViewController
@synthesize vcIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dict = self.dataObject;
    [self loadDataAndView];
}


#pragma mark - LAYOUT FLOOR PLAN DATA
-(void)loadDataAndView
{
    if (!_zoomingScroll) {
        CGRect theFrame = self.view.bounds;
        _zoomingScroll = [[ebZoomingScrollView alloc] initWithFrame:theFrame image:nil shouldZoom:YES];
        [self.view addSubview:_zoomingScroll];
        _zoomingScroll.backgroundColor = [UIColor clearColor];
        _zoomingScroll.delegate=self;
    }
    [self loadInImge:_dict[@"image"]];
    
    if ([_dict objectForKey:@"webaddress"]) {
        NSLog(@"There's an object set for key @\"b\"!");
        [self createWebButton];
    } else {
        NSLog(@"No object set for key @\"b\"");
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
    NSArray*arr = [_dict objectForKey:@"webaddress"];
    
    for (int i = 0; i < arr.count; i++) {
        
        UIButton *webButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage* webButtonImage = [UIImage imageNamed:@"grfx_web_arrow.png"];
        int padding = 6;
        
        NSString *text = arr[i];
        CGSize frameSize = CGSizeMake(999, 30);
        UIFont *font = [UIFont fontWithName:@"GoodPro-Book" size:14.0];
        
        CGRect idealFrame = [text boundingRectWithSize:frameSize
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{ NSFontAttributeName:font }
                                               context:nil];
        NSLog(@"width: %0.1f", idealFrame.size.width);
        
        
        webButton.frame = CGRectMake(174 + (i * 200), 675 , idealFrame.size.width + webButtonImage.size.width + padding , idealFrame.size.height);
        
        [webButton addTarget:self action:@selector(createWebButtonWithAddress:) forControlEvents:UIControlEventTouchUpInside];
        
        [webButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [webButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [webButton setImage:webButtonImage forState:UIControlStateNormal];
        
        [webButton setTitle:text forState:UIControlStateNormal];
        
        webButton.showsTouchWhenHighlighted = YES;
        webButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [webButton setBackgroundColor:[UIColor clearColor]];
        
        [webButton.titleLabel setFont:font];
        
        webButton.imageEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        
        [webButton setTitleEdgeInsets:UIEdgeInsetsMake(0, padding, 0, 0)];
        
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
