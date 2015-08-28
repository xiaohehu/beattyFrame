//
//  SupplementaryView.m
//  CollectionViewDemo
//
//  Created by Tapasya on 15/10/12.
//  Copyright (c) 2012 Tapasya. All rights reserved.
//

#import "EMBSPSupplementaryView.h"

@implementation EMBSPSupplementaryView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 500, 25)];
        self.label.frame = CGRectMake(10, 0, 500, 25);
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.font = [UIFont boldSystemFontOfSize:20.0];
        self.label.textColor = [UIColor blackColor];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.numberOfLines = 1;
        [self addSubview:self.label];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
