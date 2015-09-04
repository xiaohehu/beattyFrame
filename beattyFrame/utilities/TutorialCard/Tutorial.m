//
//  embEventObject.m
//  vacationTimer
//
//  Created by Evan Buxton on 4/2/15.
//
//

#import "Tutorial.h"
#import <objc/runtime.h>

@implementation Tutorial

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.tutTitle forKey:@"tutTitle"];
    [aCoder encodeObject:self.tutSubtitle forKey:@"tutSubtitle"];
    [aCoder encodeObject:self.tutGIF forKey:@"tutGIF"];
    [aCoder encodeObject:self.tutDescription forKey:@"tutDescription"];
    [aCoder encodeObject:self.tutTip forKey:@"tutTip"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _tutTitle = [aDecoder decodeObjectForKey:@"tutTitle"];
        _tutSubtitle = [aDecoder decodeObjectForKey:@"tutSubtitle"];
        _tutGIF = [aDecoder decodeObjectForKey:@"tutGIF"];
        _tutDescription = [aDecoder decodeObjectForKey:@"tutDescription"];
        _tutTip = [aDecoder decodeObjectForKey:@"tutTip"];
    }
    return self;
}

-(void)setTutTitle:(NSString *)tutTitle
{
    _tutTitle = tutTitle;
}

-(void)setTutSubtitle:(NSString *)tutSubtitle
{
    _tutSubtitle = tutSubtitle;
}

-(void)setTutGIF:(NSString *)tutGIF
{
    _tutGIF = tutGIF;
}

-(void)setTutDescription:(NSString *)tutDescription
{
    _tutDescription = tutDescription;
}

-(void)setTutTip:(NSString *)tutTip
{
    _tutTip = tutTip;
}

@end
