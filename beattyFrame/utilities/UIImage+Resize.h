//
//  UIImage+Resize.h
//  beattyFrame
//
//  Created by Evan Buxton on 11/24/15.
//  Copyright © 2015 Xiaohe Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)
+ (UIImage*)imageFromView:(UIView*)view;
+ (UIImage*)imageFromView:(UIView*)view scaledToSize:(CGSize)newSize;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
