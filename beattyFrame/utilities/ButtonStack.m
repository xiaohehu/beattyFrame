//
//  ButtonStack.m
//  beattyFrame
//
//  Created by Evan Buxton on 9/9/15.
//  Copyright © 2015 Xiaohe Hu. All rights reserved.
//

#import "ButtonStack.h"
#import "UIColor+Extensions.h"

@implementation ButtonStack
{
    NSMutableArray *btns;
}

@synthesize notSelectedImage = _notSelectedImage;
@synthesize fullSelectedImage = _fullSelectedImage;
@synthesize imageViews = _imageViews;
@synthesize delegate = _delegate;

- (void)baseInit {
    _notSelectedImage = nil;
    _fullSelectedImage = nil;
    _imageViews = [[NSMutableArray alloc] init];
    btns = [[NSMutableArray alloc] init];

    _delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}

-(void)setupfromArray:(NSArray *)btnArray maxWidth:(CGFloat )maxW
{
    //Make(15, 100, 150, keyPadImage.count*35
    
    CGFloat padding = 2.f;
    
    CGRect viewframe = CGRectMake(15,100,150, (btnArray.count*35)+(btnArray.count*padding+2));
    self.frame = viewframe;
    
    if(btnArray.count >0){
        NSInteger i;
        UIButton *button;
        _notSelectedImage = [UIImage imageNamed:@"grfx_mapMenuBtnDef.png"];
        _fullSelectedImage = [UIImage imageNamed:@"grfx_mapMenuBtnSel.png"];

        int heightt = _notSelectedImage.size.height + padding;

        CGRect frame = CGRectMake(0,2,self.bounds.size.width, _notSelectedImage.size.height);
        
        for(i=0; i<btnArray.count; i++)
        {
            if(i!=0) {
                frame.origin.y = (heightt)*i+padding;
            }

            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = frame;
            
            [button setTitle:[btnArray objectAtIndex:i] forState:UIControlStateNormal];
            button.tag = i;

            [button addTarget:self action:@selector(selectOverlay:) forControlEvents:UIControlEventTouchUpInside];
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setImage:_notSelectedImage forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setImage:_fullSelectedImage forState:UIControlStateSelected];
            
            button.titleLabel.text = btnArray[i];
            button.showsTouchWhenHighlighted = YES;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

            [button setBackgroundColor:[UIColor whiteColor]];
            
            [button.titleLabel setFont:[UIFont fontWithName:@"GoodPro-Book" size:14.0]];
            
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
            
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
            [self addSubview:button];
            [btns addObject:button];
            
            if(i!=0) {
                UIView *rule = [[UIView alloc] initWithFrame:CGRectMake(2, frame.origin.y-1, 130, 0.5)];
                [rule setBackgroundColor:[UIColor lightGrayColor]];
                [self addSubview:rule];
            }

        }
    }
    
    NSLog(@"_imageViews %li", _imageViews.count);
    [self setCenter:CGPointMake(self.center.x, 768/2)];

}

-(void)selectOverlay:(id)sender
{
    UIButton*currentButton = (UIButton*)sender;
    [self.delegate buttonStack:self selectedIndex: (int)[currentButton tag] ];

    if (currentButton.selected == YES) {
        [currentButton setBackgroundColor:[UIColor whiteColor]];
        [currentButton setSelected:NO];
        return;
    }
    
    for (UIButton *button in btns) {
        [(UIButton *)button setBackgroundColor:[UIColor whiteColor]];
        [button setSelected:NO];
    }
    
    currentButton.selected = !currentButton.selected;
    
    if (currentButton.selected == YES) {
        [currentButton setBackgroundColor:[UIColor themeRed]];
    } else {
        [currentButton setBackgroundColor:[UIColor whiteColor]];
    }
}

@end