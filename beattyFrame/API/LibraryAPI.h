//
//  LibraryAPI.h
//  daysaway
//
//  Created by Evan Buxton on 4/11/15.
//
//

#import <Foundation/Foundation.h>
#import "embBuilding.h"

@interface LibraryAPI : NSObject

+(LibraryAPI*)sharedInstance;

- (NSArray*)getEvents;
- (NSArray*)getCurrentEvents;

- (void)addEvent:(embBuilding*)event;
- (void)archiveEvent:(embBuilding*)event atIndex:(NSInteger)index;
- (void)deleteEvent:(embBuilding*)event atIndex:(int)index;
- (void)saveEvents;
- (void)setCurrentEvent:(embBuilding*)event;
- (void)replaceEvent:(embBuilding*)event atIndex:(NSInteger)index;
-(embBuilding*)getCurrentEvent;

@end
