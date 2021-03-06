//
//  ebZoomingScrollView.m
//  quadrangle
//
//  Created by Evan Buxton on 6/27/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import "ebZoomingScrollView.h"
#import "KeyOverlay.h"
#import "ImageOverlay.h"
#import "tappableview.h"

@interface ebZoomingScrollView () <UIScrollViewDelegate>

//@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *uiv_windowComparisonContainer;
@end

@implementation ebZoomingScrollView
@synthesize scrollView = _scrollView;
@synthesize uiv_windowComparisonContainer = _uiv_windowComparisonContainer;
@synthesize canZoom;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame image:(UIImage*)thisImage shouldZoom:(BOOL)zoomable;
{
	self = [super initWithFrame:frame];
	if (self) {
		if (nil == _scrollView) {
			self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			self.autoresizesSubviews =YES;
			
			//[self setBackgroundColor:[UIColor blueColor]];
			
			_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
			_scrollView.delegate = self;
            _scrollView.clipsToBounds = NO;
			//[_scrollView setBackgroundColor:[UIColor redColor]];
			[self addSubview:_scrollView];
			
			_blurView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
			//_blurView.frame = CGRectInset(self.frame, 5*self.frame.size.width/100, 5*self.frame.size.height/100);
            
			[_blurView setUserInteractionEnabled:YES];

			_blurView.image = thisImage;
			[self zoomableScrollview:self withImage:_blurView];
//            [_blurView setContentMode:UIViewContentModeTop];
            _blurView.contentMode = UIViewContentModeScaleAspectFit;
            
			if (zoomable==1) {
				[self unlockZoom];
			} else {
				[self lockZoom];
			}
		}
	}
	return self;
}

-(void)lockZoom
{
    maximumZoomScale = self.scrollView.maximumZoomScale;
    minimumZoomScale = self.scrollView.minimumZoomScale;
	
    self.scrollView.maximumZoomScale = 1.0;
    self.scrollView.minimumZoomScale = 1.0;
}

-(void)unlockZoom
{
	
    self.scrollView.maximumZoomScale = 4;
    self.scrollView.minimumZoomScale = 1;
	
}

-(void)resetScroll {
	_scrollView.zoomScale=1.0;
}

-(void)setCloseBtn:(BOOL)closeBtn
{
    if (closeBtn != NO) {
        UIButton *h = [UIButton buttonWithType:UIButtonTypeCustom];
		//h.frame = CGRectMake([self superview].frame.size.width-20-33, 20, 33, 33);
		h.frame = CGRectMake(_uiv_windowComparisonContainer.frame.size.width-50, 8, 46, 30);
		[h setImage:[UIImage imageNamed:@"grfx_closeBtn.png"] forState:UIControlStateNormal];
		//[h setTitle:@"CLOSE" forState:UIControlStateNormal];
		[h setTitleColor:[UIColor colorWithRed:210.0/255.0 green:70.0/255.0 blue:39.0/255.0 alpha:1.0] forState:UIControlStateNormal];
		[h.titleLabel setFont:[UIFont fontWithName:@"DINPro-CondBlack" size:18]];		//set their selector using add selector
		[h addTarget:self action:@selector(removeRenderScroll:) forControlEvents:UIControlEventTouchUpInside];
		[_uiv_windowComparisonContainer insertSubview:h aboveSubview:self];
        h.alpha = 0.0;
        [UIView animateWithDuration:0.33 delay:0.75 options:0 animations:^{
            h.alpha = 1.0;
        } completion:^(BOOL finished){ }];
    }
}

-(void)zoomableScrollview:(id)sender withImage:(UIImageView*)thisImage
{
	_uiv_windowComparisonContainer = [[UIView alloc] initWithFrame:[self bounds]];
	// setup scrollview
	self.scrollView.tag = 11000;
	//Pinch Zoom Stuff
	_scrollView.maximumZoomScale = 4.0;
	_scrollView.minimumZoomScale = 1.0;
	_scrollView.clipsToBounds = YES;
	_scrollView.delegate = self;
	_scrollView.scrollEnabled = YES;
	
	[_uiv_windowComparisonContainer addSubview:_scrollView];
	
	UITapGestureRecognizer *tap2Recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomMyPlan:)];
	[tap2Recognizer setNumberOfTapsRequired:2];
	[tap2Recognizer setDelegate:self];
	[_scrollView addGestureRecognizer:tap2Recognizer];
	
	//NSLog(@"%@ render",renderImageView);
	
	[self.scrollView setContentMode:UIViewContentModeScaleAspectFit];
	self.scrollView.frame = self.bounds;
	[_scrollView addSubview:thisImage];
	
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
	
//	_uiv_windowComparisonContainer.transform = CGAffineTransformMakeScale(1.5, 1.5);
	_uiv_windowComparisonContainer.alpha=1.0;
	[self addSubview:_uiv_windowComparisonContainer];
	
//	UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
	
//	[UIView animateWithDuration:0.3 delay:0.0 options:options
//					 animations:^{
//						 _uiv_windowComparisonContainer.alpha=1.0;
//						 _uiv_windowComparisonContainer.transform = CGAffineTransformIdentity;
//					 }
//					 completion:^(BOOL  completed){
//					 }];
	
}

-(void)zoomMyPlan:(UITapGestureRecognizer *)sender {
	
	// 1 determine which to zoom
	UIScrollView *tmp;
	
	tmp = _scrollView;
	
	UIImageView *imgTmp;
	imgTmp = _blurView;
	
	CGPoint pointInView = [sender locationInView:imgTmp];
	
	// 2
	CGFloat newZoomScale = tmp.zoomScale * 2.0f;
	newZoomScale = MIN(newZoomScale, tmp.maximumZoomScale);
	
	// 3
	CGSize scrollViewSize = tmp.bounds.size;
	
	CGFloat w = scrollViewSize.width / newZoomScale;
	CGFloat h = scrollViewSize.height / newZoomScale;
	CGFloat x = pointInView.x - (w / 2.0f);
	CGFloat y = pointInView.y - (h / 2.0f);
	CGRect rectToZoomTo = CGRectMake(x, y, w, h);
	// 4
	
    if (tmp.zoomScale > 1.9) {
        [tmp setZoomScale: 1.0 animated:YES];
		
    } else if (tmp.zoomScale < 2) {
		[tmp zoomToRect:rectToZoomTo animated:YES];
		
    }
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _blurView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *subView = [scrollView.subviews objectAtIndex:0];
	
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
	
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
	
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}


-(void)removeRenderScroll:(id)sender {
	UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
	
	[UIView animateWithDuration:0.3 delay:0.0 options:options
					 animations:^{
						 _uiv_windowComparisonContainer.alpha=0.0;
						 _uiv_windowComparisonContainer.transform = CGAffineTransformScale(_uiv_windowComparisonContainer.transform, 0.5, 0.5);
					 }
					 completion:^(BOOL  completed){
						 [_uiv_windowComparisonContainer removeFromSuperview];
						 _uiv_windowComparisonContainer = nil;
						 [_scrollView removeFromSuperview];
						 [self didRemove];
					 }];
}

#pragma mark - Delegate methods
-(void)didRemove {
    [delegate didRemove:self];
    [self removeFromSuperview];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (UIView *dropPinView in _blurView.subviews) {
        if ( [dropPinView isKindOfClass:[KeyOverlay class]] || [dropPinView isKindOfClass:[ImageOverlay class]]  || [dropPinView isKindOfClass:[tappableview class]]) {
                CGRect oldFrame = dropPinView.frame;
                dropPinView.frame = oldFrame;
                dropPinView.transform = CGAffineTransformMakeScale(1.0/_scrollView.zoomScale, 1.0/_scrollView.zoomScale);
            }
    }
}

@end