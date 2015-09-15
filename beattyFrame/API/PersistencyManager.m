//
//  PersistencyManager.m
//  daysaway
//
//  Created by Evan Buxton on 4/11/15.
//
//

#import "PersistencyManager.h"
#import "embBuilding.h"

@interface PersistencyManager () {
    // an array of all events
    NSMutableArray *buildings;
    NSMutableArray *currentEvents;
}

@property (strong, nonatomic) NSMutableArray *savedArray;

@end

@implementation PersistencyManager

- (id)init
{
    self = [super init];
    if (self) {
        
        currentEvents = [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"building_data" ofType:@"plist"]] copy];

        buildings = [[NSMutableArray alloc] init];
            
        for (int i=0;i<currentEvents.count;i++) {
            
           NSDictionary *dict = currentEvents[i];
            
            embBuilding *building = [[embBuilding alloc] init];
            building.buildingImage = dict[@"buildingImage"];
            building.buildingTitle = dict[@"buildingTitle"];
            building.buildingSite = dict[@"buildingSite"];
            building.buildingSiteCaption = dict[@"buildingSiteCaption"];
            building.buildingGallery = dict[@"buildingGallery"];
            [buildings addObject:building];
        }

    }
    return self;
}

- (NSArray*)getEvents
{
    return buildings;
}

- (NSArray*)getCurrentEvents
{
    return currentEvents;
}

- (void)setCurrentEvent:(embBuilding*)event
{
    _currentEvent = event;
    _index = [buildings indexOfObjectIdenticalTo:event];
}
@end
