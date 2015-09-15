//
//  PersistencyManager.h
//  daysaway
//
//  Created by Evan Buxton on 4/11/15.
//
//

#import <Foundation/Foundation.h>
#import "embBuilding.h"

@interface PersistencyManager : NSObject

@property (strong, nonatomic) embBuilding *currentEvent;
@property (assign, nonatomic) NSInteger *index;

- (NSArray*)getEvents;
- (NSArray*)getCurrentEvents;

//- (void)addEvent:(embBuilding*)event;
//- (void)deleteEvent:(embBuilding*)event atIndex:(int)index;
//- (void)saveEvents;
- (void)setCurrentEvent:(embBuilding*)event;
//- (void)replaceEvent:(embBuilding*)event atIndex:(NSInteger)index;

//- (void)archiveEvent:(embBuilding*)event atIndex:(NSInteger)index;
@end
