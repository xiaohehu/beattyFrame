//
//  CVCell.m
//  CollectionViewExample
//
//  Created by Tim on 9/5/12.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "EMBSPCell.h"

@implementation EMBSPCell

@synthesize titleLabel = _titleLabel;
@synthesize cellThumb = _cellThumb;
@synthesize countLabel = _countLabel;
@synthesize imgFrame = _imgFrame;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
       _titleLabel.font = [UIFont fontWithName:@"JosefinSans-Light" size:2];
       // supplementaryView.label.font = [UIFont fontWithName:@"DINPro-CondBlack" size:25];

        
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"EMBSPCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
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
