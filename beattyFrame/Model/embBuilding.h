//
//  embEventObject.h
//  vacationTimer
//
//  Created by Evan Buxton on 4/2/15.
//
//

#import <Foundation/Foundation.h>

@interface embBuilding : NSObject <NSCoding>

@property (nonatomic, copy) NSString *buildingImage, *buildingTitle, *buildingSiteCaption, *buildingSite, *buildingGallery, *buildingWeb, *buildingData;

- (id)initWithImage:(NSString*)buildingImage title:(NSString*)buildingTitle state:(NSString*)buildingSiteCaption caption:(NSString*)buildingSite background:(NSString*)buildingGallery buildingWeb:(NSString*)buildingWeb buildingData:(NSString*)buildingData;

@end
