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
@property (assign, nonatomic) NSInteger index;

- (NSArray*)getEvents;
- (NSArray*)getCurrentEvents;
- (void)setCurrentEvent:(embBuilding*)event;
@end
