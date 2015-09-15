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
    }
    return self;
}

- (NSDictionary *)dictionary {
    unsigned int count = 0;
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];
        
        if (value == nil) {
            // nothing todo
        }
        else if ([value isKindOfClass:[NSNumber class]]
                 || [value isKindOfClass:[NSString class]]
                 || [value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSMutableArray class]] || [value isKindOfClass:[NSDate class]]) {
            // TODO: extend to other types
            [dictionary setObject:value forKey:key];
        }
        else if ([value isKindOfClass:[NSObject class]]) {
            [dictionary setObject:[value dictionary] forKey:key];
        }
        else {
            NSLog(@"Invalid type for %@ (%@)", NSStringFromClass([self class]), key);
        }
    }
    free(properties);
    return dictionary;
}

- (id)initWithImage:(NSString*)buildingImage title:(NSString*)buildingTitle state:(NSString*)buildingSiteCaption caption:(NSString*)buildingSite background:(NSString*)buildingGallery
{
    self = [super init];
    if (self)
    {
        _buildingImage = buildingImage;
        _buildingTitle = buildingTitle;
        _buildingSite = buildingSite;
        _buildingSiteCaption = buildingSiteCaption;
        _buildingGallery = buildingGallery;

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
