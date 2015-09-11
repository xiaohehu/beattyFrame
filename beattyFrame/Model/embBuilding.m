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
    [aCoder encodeObject:self.eventDate forKey:@"eventDate"];
    [aCoder encodeObject:self.eventCity forKey:@"eventCity"];
    [aCoder encodeObject:self.eventState forKey:@"eventState"];
    [aCoder encodeObject:self.eventBG forKey:@"eventBG"];
    [aCoder encodeObject:self.eventCaption forKey:@"eventCaption"];
    [aCoder encodeObject:self.eventBGAlpha forKey:@"eventBGAlpha"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _eventDate = [aDecoder decodeObjectForKey:@"eventDate"];
        _eventCity = [aDecoder decodeObjectForKey:@"eventCity"];
        _eventState = [aDecoder decodeObjectForKey:@"eventState"];
        _eventBG = [aDecoder decodeObjectForKey:@"eventBG"];
        _eventCaption = [aDecoder decodeObjectForKey:@"eventCaption"];
        _eventBGAlpha = [aDecoder decodeObjectForKey:@"eventBGAlpha"];
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

- (id)initWithCity:(NSString*)eventCity state:(NSString*)eventState caption:(NSString*)eventCaption background:(NSString*)eventBG eventBGAlpha:(NSString*)eventBGAlpha departureDate:(NSDate*)eventDate archived:(BOOL)isArchived
{
    self = [super init];
    if (self)
    {
        _eventBG = eventBG;
        _eventCity = eventCity;
        _eventState = eventState;
        _eventDate = eventDate;
        _eventCaption = eventCaption;
        _eventBGAlpha = eventBGAlpha;
    }
    return self;
}

-(void)setEventBG:(NSString *)eventBG
{
    _eventBG = eventBG;
}

-(void)setEventBGAlpha:(NSString *)eventBGAlpha
{
    _eventBGAlpha = eventBGAlpha;
}

-(void)setEventCaption:(NSString *)eventCaption
{
    _eventCaption = eventCaption;
}

-(void)setEventCity:(NSString *)eventCity
{
    _eventCity = eventCity;
}

-(void)setEventDate:(NSDate *)eventDate
{
    _eventDate = eventDate;
}

-(void)setEventState:(NSString *)eventState
{
    _eventState = eventState;
}

@end
