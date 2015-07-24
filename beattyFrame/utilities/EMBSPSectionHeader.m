//
//  CVSectionHeader.m
//  quadrangle
//
//  Created by Evan Buxton on 6/29/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import "EMBSPSectionHeader.h"

@implementation EMBSPSectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)setCategoryText:(NSString *)text {
    self.sectionLabel.text = text;
}


@end
