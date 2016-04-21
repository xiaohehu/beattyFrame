//
//  UIColor+Extensions.m
//  650mad
//
//  Created by Evan Buxton on 9/27/12.
//
//

#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)

#pragma mark
#pragma mark description

+ (UIColor *)colorWithHueDegrees:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness {
    return [UIColor colorWithHue:(hue/360) saturation:saturation brightness:brightness alpha:1.0];
}

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha {
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

+ (UIColor *)themeRed {
    return [UIColor colorWithRed:216.0/255.0 green:35.0/255.0 blue:42.0/255.0 alpha:1.0];
}

+ (UIColor *)selectedBlue {
    return [UIColor colorWithRed:118.0/255.0 green:199.0/255.0 blue:253.0/255.0 alpha:1.0];
}

+ (UIColor *)helpBlue {
    return [UIColor colorWithRed:60.0/255.0 green:197.0/255.0 blue:233.0/255.0 alpha:1.0];
}

+ (UIColor *)helpSectionHeaderBlue {
    return [UIColor colorWithRed:150.0/255.0 green:180.0/255.0 blue:188.0/255.0 alpha:1.0];
}
+ (UIColor *)themeTextGray {
    return [UIColor colorWithRed:0.38 green:0.39 blue:0.38 alpha:1.00];
}

+ (UIColor *)randomColor {
    return [self colorWithRed:((float)rand() / RAND_MAX)
                        green:((float)rand() / RAND_MAX)
                         blue:((float)rand() / RAND_MAX)
                        alpha:1.0f];
}


@end
