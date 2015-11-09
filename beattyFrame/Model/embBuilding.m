//
//  embEventObject.m
//  vacationTimer
//
//  Created by Evan Buxton on 4/2/15.
//
//

#import "embBuilding.h"
#import <objc/runtime.h>

@implementation embBuilding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.buildingImage forKey:@"buildingImage"];
    [aCoder encodeObject:self.buildingTitle forKey:@"buildingTitle"];
    [aCoder encodeObject:self.buildingSite forKey:@"buildingSite"];
    [aCoder encodeObject:self.buildingSiteCaption forKey:@"buildingSiteCaption"];
    [aCoder encodeObject:self.buildingGallery forKey:@"buildingGallery"];
    [aCoder encodeObject:self.buildingWeb forKey:@"buildingWeb"];
    [aCoder encodeObject:self.buildingData forKey:@"buildingStats"];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _buildingImage = [aDecoder decodeObjectForKey:@"buildingImage"];
        _buildingTitle = [aDecoder decodeObjectForKey:@"buildingTitle"];
        _buildingSite = [aDecoder decodeObjectForKey:@"buildingSite"];
        _buildingSiteCaption = [aDecoder decodeObjectForKey:@"buildingSiteCaption"];
        _buildingGallery = [aDecoder decodeObjectForKey:@"buildingGallery"];
        _buildingWeb = [aDecoder decodeObjectForKey:@"buildingWeb"];
        _buildingData = [aDecoder decodeObjectForKey:@"buildingStats"];
    }
    return self;
}
- (id)initWithImage:(NSString*)buildingImage title:(NSString*)buildingTitle state:(NSString*)buildingSiteCaption caption:(NSString*)buildingSite background:(NSString*)buildingGallery buildingWeb:(NSString*)buildingWeb buildingData:(NSString*)buildingData
{
    self = [super init];
    if (self)
    {
        _buildingImage = buildingImage;
        _buildingTitle = buildingTitle;
        _buildingSite = buildingSite;
        _buildingSiteCaption = buildingSiteCaption;
        _buildingGallery = buildingGallery;
        _buildingData = buildingData;
        _buildingWeb = buildingWeb;
    }
    return self;
}

-(void)setBuildingTitle:(NSString *)buildingTitle
{
    _buildingTitle = buildingTitle;
}

-(void)setBuildingSite:(NSString *)buildingSite
{
    _buildingSite = buildingSite;
}

-(void)setBuildingSiteCaption:(NSString *)buildingSiteCaption
{
    _buildingSiteCaption = buildingSiteCaption;
}

-(void)setBuildingGallery:(NSString *)buildingGallery
{
    _buildingGallery = buildingGallery;
}

@end
