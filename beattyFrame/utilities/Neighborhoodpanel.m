//
//  Neighborhoodpanel.m
//  harborpoint
//
//  Created by Evan Buxton on 4/21/16.
//  Copyright (c) 2016 neoscape. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//

#import "Neighborhoodpanel.h"


@implementation Neighborhoodpanel

#pragma mark Initialization

+ (void)initialize
{
}

#pragma mark Drawing Methods

+ (void)drawMappanelWithPop: (NSString*)pop inc: (NSString*)inc age: (NSString*)age title: (NSString*)title
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();

    //// Color Declarations
    UIColor* textForeground2 = [UIColor colorWithRed: 0.403 green: 0.403 blue: 0.403 alpha: 1];
    UIColor* fillColor2 = [UIColor colorWithRed: 0.943 green: 0.127 blue: 0.198 alpha: 1];
    UIColor* strokeColor = [UIColor colorWithRed: 0.907 green: 0.907 blue: 0.907 alpha: 1];
    UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIColor* textForeground = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIColor* strokeColor3 = [UIColor colorWithRed: 0.521 green: 0.521 blue: 0.521 alpha: 0.756];
    UIColor* strokeColor2 = [UIColor colorWithRed: 0.774 green: 0.774 blue: 0.774 alpha: 1];
    UIColor* darkred = [UIColor colorWithRed: 0.847 green: 0.137 blue: 0.165 alpha: 1];

    //// path- Drawing
    UIBezierPath* pathPath = [UIBezierPath bezierPathWithRect: CGRectMake(1, 1, 306, 222)];
    [strokeColor2 setStroke];
    pathPath.lineWidth = 2;
    [pathPath stroke];


    //// path-1 Drawing
    UIBezierPath* path1Path = [UIBezierPath bezierPathWithRect: CGRectMake(4.5, 4.75, 299, 214.75)];
    [fillColor setFill];
    [path1Path fill];
    [strokeColor setStroke];
    path1Path.lineWidth = 5;
    [path1Path stroke];


    //// Label Drawing
    CGRect labelRect = CGRectMake(33, 14, 259, 19);
    UIFont* labelFont = [UIFont fontWithName: @"GoodPro" size: 19];
    [textForeground setFill];
    [title drawInRect: labelRect withFont: labelFont lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];


    //// Line-Copy-4 Drawing
    UIBezierPath* lineCopy4Path = [UIBezierPath bezierPath];
    [lineCopy4Path moveToPoint: CGPointMake(15, 46)];
    [lineCopy4Path addLineToPoint: CGPointMake(292, 46)];
    lineCopy4Path.miterLimit = 4;

    lineCopy4Path.lineCapStyle = kCGLineCapSquare;

    lineCopy4Path.usesEvenOddFillRule = YES;

    [strokeColor3 setStroke];
    lineCopy4Path.lineWidth = 1;
    [lineCopy4Path stroke];


    //// Label 18 Drawing
    CGRect label18Rect = CGRectMake(15, 53, 73, 18);
    UIFont* label18Font = [UIFont fontWithName: @"GoodPro" size: 15];
    [textForeground2 setFill];
    [@"Population:" drawInRect: label18Rect withFont: label18Font lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];


    //// Label 19 Drawing
    CGRect label19Rect = CGRectMake(15, 74, 108, 18);
    UIFont* label19Font = [UIFont fontWithName: @"GoodPro" size: 15];
    [textForeground2 setFill];
    [@"Avg HH Income:  	" drawInRect: label19Rect withFont: label19Font lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];


    //// Label 20 Drawing
    CGRect label20Rect = CGRectMake(15, 95, 82, 18);
    UIFont* label20Font = [UIFont fontWithName: @"GoodPro" size: 15];
    [textForeground2 setFill];
    [@"Median Age:" drawInRect: label20Rect withFont: label20Font lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];


    //// Text Drawing
    CGRect textRect = CGRectMake(132, 55, 103, 14);
    UIFont* textFont = [UIFont fontWithName: @"GoodPro-Black" size: 15];
    [textForeground2 setFill];
    CGFloat textTextHeight = [pop sizeWithFont: textFont constrainedToSize: CGSizeMake(CGRectGetWidth(textRect), INFINITY) lineBreakMode: UILineBreakModeWordWrap].height;
    CGContextSaveGState(context);
    CGContextClipToRect(context, textRect);
    [pop drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (CGRectGetHeight(textRect) - textTextHeight) / 2, CGRectGetWidth(textRect), textTextHeight) withFont: textFont lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];
    CGContextRestoreGState(context);


    //// Text 2 Drawing
    CGRect text2Rect = CGRectMake(132, 76, 102, 14);
    UIFont* text2Font = [UIFont fontWithName: @"GoodPro-Black" size: 15];
    [textForeground2 setFill];
    CGFloat text2TextHeight = [inc sizeWithFont: text2Font constrainedToSize: CGSizeMake(CGRectGetWidth(text2Rect), INFINITY) lineBreakMode: UILineBreakModeWordWrap].height;
    CGContextSaveGState(context);
    CGContextClipToRect(context, text2Rect);
    [inc drawInRect: CGRectMake(CGRectGetMinX(text2Rect), CGRectGetMinY(text2Rect) + (CGRectGetHeight(text2Rect) - text2TextHeight) / 2, CGRectGetWidth(text2Rect), text2TextHeight) withFont: text2Font lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];
    CGContextRestoreGState(context);


    //// Text 3 Drawing
    CGRect text3Rect = CGRectMake(132, 99, 101, 14);
    UIFont* text3Font = [UIFont fontWithName: @"GoodPro-Black" size: 15];
    [textForeground2 setFill];
    CGFloat text3TextHeight = [age sizeWithFont: text3Font constrainedToSize: CGSizeMake(CGRectGetWidth(text3Rect), INFINITY) lineBreakMode: UILineBreakModeWordWrap].height;
    CGContextSaveGState(context);
    CGContextClipToRect(context, text3Rect);
    [age drawInRect: CGRectMake(CGRectGetMinX(text3Rect), CGRectGetMinY(text3Rect) + (CGRectGetHeight(text3Rect) - text3TextHeight) / 2, CGRectGetWidth(text3Rect), text3TextHeight) withFont: text3Font lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];
    CGContextRestoreGState(context);


    //// bgcolor-normal Drawing
    UIBezierPath* bgcolornormalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(13, 18, 15, 15)];
    [darkred setFill];
    [bgcolornormalPath fill];


    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(27.85, 27)];
    [bezier2Path addCurveToPoint: CGPointMake(20.5, 33) controlPoint1: CGPointMake(27.15, 30.43) controlPoint2: CGPointMake(24.12, 33)];
    [bezier2Path addCurveToPoint: CGPointMake(13.15, 27) controlPoint1: CGPointMake(16.87, 33) controlPoint2: CGPointMake(13.84, 30.42)];
    [bezier2Path addLineToPoint: CGPointMake(27.85, 27)];
    [bezier2Path closePath];
    [fillColor2 setFill];
    [bezier2Path fill];
}

@end
