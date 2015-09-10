//
//  ButtonStack.h
//  beattyFrame
//
//  Created by Evan Buxton on 9/9/15.
//  Copyright © 2015 Xiaohe Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ButtonStack;

@protocol ButtonStackDelegate
- (void)buttonStack:(ButtonStack *)buttonStack selectedIndex:(int)index;
@end

@interface ButtonStack : UIView

@property (strong, nonatomic) UIImage *notSelectedImage;
@property (strong, nonatomic) UIImage *fullSelectedImage;
@property (assign, nonatomic) float rating;
@property (assign) BOOL editable;
@property (strong) NSMutableArray * imageViews;
@property (assign, nonatomic) int maxRating;
@property (assign) int midMargin;
@property (assign) int leftMargin;
@property (assign) CGSize minImageSize;
@property (assign) id <ButtonStackDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)setupfromArray:(NSArray *)btnArray maxWidth:(CGFloat )maxW;

@end
