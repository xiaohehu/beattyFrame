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
    UIButton*currentButton;
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

-(void)setupfromArray:(NSArray *)btnArray maxWidth:(CGRect)maxW
{
    //Make(15, 100, 150, keyPadImage.count*35
    
    NSMutableArray *overlayTitles = [[NSMutableArray alloc] init];
    NSMutableArray *overlaySubtitles = [[NSMutableArray alloc] init];
    for ( NSDictionary *menuAsset in btnArray )
    {
        [overlayTitles addObject:menuAsset[@"name"]];
        
        if (menuAsset[@"subtitle"]) {
            [overlaySubtitles addObject:menuAsset[@"subtitle"]];
        } else {
            [overlaySubtitles addObject:@""];
        }
    }
    
    NSLog(@"_imageViews %@", overlaySubtitles);

    
    CGFloat padding = 2.f;
    
    CGRect viewframe = CGRectMake(maxW.origin.x,maxW.origin.y,maxW.size.width, (btnArray.count*35)+(btnArray.count*padding+2));
    self.frame = viewframe;
    
    if(btnArray.count >0){
        NSInteger i;
        UIButton *button;
        _notSelectedImage = [UIImage imageNamed:@"grfx-master-plan-nav-bttn-nrm.png"];
        _fullSelectedImage = [UIImage imageNamed:@"grfx-master-plan-nav-bttn-selected.png"];

        int heightt = _notSelectedImage.size.height + padding;

        CGRect frame = CGRectMake(0,2,self.bounds.size.width, _notSelectedImage.size.height);
        
        for(i=0; i<btnArray.count; i++)
        {
            if(i!=0) {
                frame.origin.y = (heightt)*i+padding;
            }

            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = frame;
            
            [button setTitle:[overlayTitles objectAtIndex:i] forState:UIControlStateNormal];
            button.tag = i;

            [button addTarget:self action:@selector(selectOverlay:) forControlEvents:UIControlEventTouchUpInside];
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setImage:_notSelectedImage forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setImage:_fullSelectedImage forState:UIControlStateSelected];
            
            //button.titleLabel.text = overlayTitles[i];
            button.showsTouchWhenHighlighted = YES;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

            [button setBackgroundColor:[UIColor whiteColor]];
            
            [button.titleLabel setFont:[UIFont fontWithName:@"GoodPro-Book" size:14.0]];
            
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
            
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
            [self addSubview:button];
            [btns addObject:button];
            
            if(i!=0) {
                UIView *rule = [[UIView alloc] initWithFrame:CGRectMake(2, frame.origin.y-1, maxW.size.width-20, 0.5)];
                [rule setBackgroundColor:[UIColor lightGrayColor]];
                [self addSubview:rule];
            }
            
            for ( NSDictionary *menuAsset in btnArray )
            {
                [overlayTitles addObject:menuAsset[@"name"]];
                
                if (menuAsset[@"subtitle"]) {
                    [overlaySubtitles addObject:menuAsset[@"subtitle"]];
                }
            }

            // create label
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(50, 5, 125, 25);
            label.textAlignment = NSTextAlignmentRight;
            //label.font = [UIFont boldSystemFontOfSize:20.0];
            label.textColor = [UIColor darkGrayColor];
            label.backgroundColor = [UIColor clearColor];
            label.numberOfLines = 1;
            label.text = overlaySubtitles[i];
            label.font = [UIFont fontWithName:@"GoodPro-Book" size:14.0];
            [button addSubview:label];
        }
    }


}

-(void)setSelectedButton:(int)index
{
    NSLog(@"setSelectedButton %i",index);
    UIButton *btn = btns[index];
    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)setCenter
{
    [self setCenter:CGPointMake(self.center.x, 768/2)];
}

-(void)selectOverlay:(id)sender
{
    currentButton = (UIButton*)sender;
    [self.delegate buttonStack:self selectedIndex: (int)[currentButton tag] ];
}

-(void)setSelectedButtonColor:(UIColor*)bgColor
{
    if (currentButton.selected == YES) {
        [currentButton setBackgroundColor:[UIColor whiteColor]];
        [currentButton setSelected:NO];
        
        for (UILabel *button in [currentButton subviews]) {
            if ([button isKindOfClass:[UILabel class]]) {
                [button setTextColor:[UIColor blackColor]];
            }
        }
        
        return;
    }
    
    for (UIButton *button in btns) {
        [(UIButton *)button setBackgroundColor:[UIColor whiteColor]];
        [button setSelected:NO];
        
        for (UILabel *bbutton in [button subviews]) {
            if ([bbutton isKindOfClass:[UILabel class]]) {
                [bbutton setTextColor:[UIColor blackColor]];
            }
        }
    }
    
    currentButton.selected = !currentButton.selected;
    
    if (currentButton.selected == YES) {
        [currentButton setBackgroundColor:bgColor];
        for (UILabel *button in [currentButton subviews]) {
            if ([button isKindOfClass:[UILabel class]]) {
                [button setTextColor:[UIColor whiteColor]];
            }
        }
        
    } else {
        [currentButton setBackgroundColor:[UIColor whiteColor]];
        for (UILabel *button in [currentButton subviews]) {
            if ([button isKindOfClass:[UILabel class]]) {
                [button setTextColor:[UIColor blackColor]];
            }
        }
    }
}

@end