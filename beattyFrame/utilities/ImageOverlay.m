//
//  ButtonStack.m
//  beattyFrame
//
//  Created by Evan Buxton on 9/9/15.
//  Copyright © 2015 Xiaohe Hu. All rights reserved.
//

#import "ImageOverlay.h"
#import "UIColor+Extensions.h"

@implementation ImageOverlay

- (void)baseInit {

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

-(void)setKeyImage:(UIImage *)keyImage
{
    UIImageView *uiiv_bg = [[UIImageView alloc] initWithImage:keyImage];
    uiiv_bg.frame = self.bounds;
    [self addSubview: uiiv_bg];
}

@end