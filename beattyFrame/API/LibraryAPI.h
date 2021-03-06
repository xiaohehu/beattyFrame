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
- (void)setCurrentEvent:(embBuilding*)event;
-(embBuilding*)getCurrentEvent;

@end
