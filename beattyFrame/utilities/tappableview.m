//
//  tappableview.m
//  beattyFrame
//
//  Created by Evan Buxton on 4/20/16.
//  Copyright © 2016 Xiaohe Hu. All rights reserved.
//

#import "tappableview.h"
#import "Tappable.h"

#ifdef DEBUG

// Something to log your sensitive data here
#define kcanLabelsBeDragged NO

#else

//

#endif


@interface tappableview ()
@property BOOL isPressed;
@property BOOL isSelected;
@property (nonatomic, strong) NSString *title;
@end

@implementation tappableview

-(id)initWithFrame:(CGRect)frame title:(NSString*)title tag:(int)tag
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.isSelected = NO;
        self.tag = tag;
        self.title = title;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(labelDragged:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)labelDragged:(UIPanGestureRecognizer *)gesture
{
    if (kcanLabelsBeDragged) {
        UILabel *label = (UILabel *)gesture.view;
        CGPoint translation = [gesture translationInView:label];
        
        // move label
        label.center = CGPointMake(label.center.x + translation.x,
                                   label.center.y + translation.y);
        
        [gesture setTranslation:CGPointZero inView:label];
        
        if (gesture.state == UIGestureRecognizerStateEnded)
        {
            [self alertLabelCenter];
        }
    }
}

-(void)alertLabelCenter
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hotspot X,Y"
                                                    message:NSStringFromCGPoint(self.frame.origin)
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)viewTappedAtIndex
{
    if ([_delegate respondsToSelector:@selector(tappedView:)])
        [_delegate tappedView:self.tag];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [Tappable drawCanvas1WithTitle:self.title selected: self.isSelected];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [self viewTappedAtIndex];
    
    self.isPressed = !self.isPressed;
    self.isSelected = !self.isSelected;

    [self setNeedsDisplay];
}

-(void)setSelected:(BOOL)isSelected
{
    self.isPressed = NO;
    self.isSelected = NO;
    [self setNeedsDisplay];
}

@end
