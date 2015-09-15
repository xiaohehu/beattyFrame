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
    //embBuilding *crntBuilding;

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
            NSLog(@"event loaded");
        }
        
        NSLog(@"events are loaded");
        NSLog(@"event loaded %@", [buildings description]);
        //NSLog(@"current loaded %@", [currentEvents description]);
    
    }
    return self;
}

//-(embBuilding*)firstEvent
//{
//    NSDate *todaysDate = [[NSDate alloc] init];
//    
//    NSDateComponents* comps = [[NSDateComponents alloc]init];
//    comps.day = 7;
//    
//    NSCalendar* calendar = [NSCalendar currentCalendar];
//    
//    NSDate* weekLater = [calendar dateByAddingComponents:comps toDate:todaysDate options:nil];
//    
//    return [[embBuilding alloc] initWithCity:@"Your Destination" state:@"" caption:@"" background:@"default_bg_photo03.png" eventBGAlpha:@"0.5" departureDate:todaysDate archived:NO];
//}

- (NSArray*)getEvents
{
    return buildings;
}

- (NSArray*)getCurrentEvents
{
    return currentEvents;
}

//- (void)addEvent:(embBuilding*)event
//{
//
//    NSLog(@"PM addEvent %@", event);
//    
//    if (buildings == nil) {
//        buildings = [[NSMutableArray alloc] init];
//    }
//    
//    if (currentEvents == nil) {
//        currentEvents = [[NSMutableArray alloc] init];
//    }
//    
//    [buildings addObject:event];
//    [currentEvents addObject:event];
//    
//    NSLog(@"PM currentEvents %@", [currentEvents description]);
//    if (currentEvents == nil) {
//        NSLog(@"why empty");
//    }
//    
//    [self saveEvents];
//}
//
//- (void)deleteEvent:(embBuilding*)event atIndex:(int)index
//{
//    NSLog(@"ddeleteEvent %@", [event description]);
//    [buildings removeObjectIdenticalTo:event];
//    [currentEvents removeObjectIdenticalTo:event];
//    
//    [self saveEvents];
//    [self checkIfEmpty];
//
//    
////    if ([events indexOfObjectIdenticalTo: event] == NSNotFound)
////    {
////        NSLog(@"FUCK %i", index); // 0x7aa87f60
////        //[events replaceObjectAtIndex:index withObject:event];
////    }
//    
//    //_index = [events indexOfObjectIdenticalTo:event];
//    //[events removeObjectAtIndex:[events indexOfObjectIdenticalTo:event]];
//}
//
//- (void)archiveEvent:(embBuilding*)event atIndex:(NSInteger)index
//{
//    NSLog(@"archiveEvent");
//    
//    //NSLog(@"archiveEvent %hhd", event.isArchived);
//    
//    
//    [currentEvents removeObjectIdenticalTo:event];
//    [buildings removeObjectIdenticalTo:event];
//    //[events removeObjectAtIndex:index];
//    [buildings insertObject:event atIndex:index];
//
//    [self checkIfEmpty];
//    
//    //[events removeObjectIdenticalTo:event];
//    //[events replaceObjectAtIndex:index withObject:event];
//    
//    //[event setIsArchived:YES];
//    
//    //_index = [events indexOfObjectIdenticalTo:event];
//    
////    if ([events indexOfObjectIdenticalTo: event] != NSNotFound)
////    {
////        NSLog(@"indexxx %i", _index);
////        [events replaceObjectAtIndex:index withObject:event];
////    }
//
//    //[events removeObjectAtIndex:index];
//    //[events insertObject:event atIndex:index];
//    
//    //NSLog(@"archiveEvent %hhd", event.isArchived);
//
//    [self saveEvents];
//}

- (void)setCurrentEvent:(embBuilding*)event
{
    _currentEvent = event;
    _index = [buildings indexOfObjectIdenticalTo:event];
    //NSLog(@"index %i",_index);
}

//-(void)checkIfEmpty
//{
//    if (currentEvents.count == 0) {
//        [currentEvents removeAllObjects];
//    }
//    
//    if (buildings.count == 0) {
//        [buildings removeAllObjects];
//    }
//}

//-(void)replaceEvent:(embBuilding*)event atIndex:(NSInteger)index
//{
//    //[events removeObjectAtIndex:index];
//    //[events insertObject:event atIndex:index];
//    NSLog(@"replaceEvent %@", [event dictionary]);
//    
//    
//    
//    int g =[buildings indexOfObjectIdenticalTo:event];
//    [buildings removeObjectIdenticalTo:event];
//    [buildings insertObject:event atIndex:g];
//
//    [self saveEvents];
//}
//
//- (void)saveEvents
//{
//    NSLog(@"SAVE");
//
//    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.neoscape.daysaway"];
//    
//    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:buildings];
//    [userDefaults setObject:encodedObject forKey:@"daysaway"];
//    [userDefaults synchronize];
//
//    NSLog(@"\n\n\n SAVEE %@", [userDefaults dictionaryRepresentation]);
//}

@end
