//
//  CALayer+Additions.m
//  beattyFrame
//
//  Created by Evan Buxton on 11/19/15.
//  Copyright © 2015 Xiaohe Hu. All rights reserved.
//

#import "CALayer+Additions.h"

@implementation CALayer (Additions)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end
