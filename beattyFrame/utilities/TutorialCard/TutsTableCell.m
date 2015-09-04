//
//  SimpleTableCell.m
//  vacationTimer
//
//  Created by Evan Buxton on 4/20/13.
//
//

#import "TutsTableCell.h"

@implementation TutsTableCell

@synthesize nameLabel = _nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
