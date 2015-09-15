//
//  LibraryAPI.m
//  daysaway
//
//  Created by Evan Buxton on 4/11/15.
//
//

#import "LibraryAPI.h"
#import "PersistencyManager.h"

@interface LibraryAPI () {
    PersistencyManager *persistencyManager;
}

@end

@implementation LibraryAPI

+(LibraryAPI*)sharedInstance
{
    static LibraryAPI *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LibraryAPI alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        persistencyManager = [[PersistencyManager alloc] init];
    }
    return self;
}

- (NSArray*)getEvents
{
    return [persistencyManager getEvents];
}

- (NSArray*)getCurrentEvents
{
    return [persistencyManager getCurrentEvents];
}

-(embBuilding*)getCurrentEvent
{
    return [persistencyManager currentEvent];
}

- (void)setCurrentEvent:(embBuilding*)event
{
    [persistencyManager setCurrentEvent:event];
}

@end
