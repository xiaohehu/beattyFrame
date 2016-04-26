//
//  ebUIViewWithInteractiveScrollView.h
//  quadrangle
//
//  Created by Evan Buxton on 6/27/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ebUIViewWithInteractiveScrollView;

@protocol ebUIViewWithInteractiveScrollViewDelegate 
-(void)didRemove:(ebUIViewWithInteractiveScrollView *)customClass;

@end

@interface ebUIViewWithInteractiveScrollView : UIView <UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
	CGFloat maximumZoomScale;
	CGFloat minimumZoomScale;
	CGRect incomingFrame;
	BOOL isFullScreen;
	int	tapCount;
}
 
- (id)initWithFrame:(CGRect)frame image:(UIImage*)thisImage overlay:(NSString*)secondImage overlayTwo:(NSString*)thirdImage shouldZoom:(BOOL)zoomable;
@property (assign) BOOL canZoom;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *blurView;
@property (nonatomic, strong) NSString *overlay;
@property (nonatomic, strong) NSString *overlayTwo;
@property (nonatomic, strong) UIImage *firstImg;

@property (assign) BOOL imageToggle;
// define delegate property
@property (nonatomic, assign) id  delegate;
@property (nonatomic, readwrite) BOOL  closeBtn;

// define public functions
-(void)didRemove;
-(void)resetScroll;

@end
