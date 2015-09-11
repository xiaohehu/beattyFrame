//
//  embEventObject.h
//  vacationTimer
//
//  Created by Evan Buxton on 4/2/15.
//
//

#import <Foundation/Foundation.h>

@interface embBuilding : NSObject <NSCoding>

@property (nonatomic, copy) NSString *eventCity, *eventState, *eventBG, *eventCaption;
@property (nonatomic, copy) NSDate *eventDate;
@property (nonatomic, readwrite) NSString *eventBGAlpha;

-(NSDictionary *)dictionary;

- (id)initWithCity:(NSString*)eventCity state:(NSString*)eventState caption:(NSString*)eventCaption background:(NSString*)eventBG eventBGAlpha:(NSString*)eventBGAlpha departureDate:(NSDate*)eventDate archived:(BOOL)isArchived;

@end
