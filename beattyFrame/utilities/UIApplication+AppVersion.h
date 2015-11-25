//
//  UIApplication+AppVersion.h
//  rxrnorthhills
//
//  Created by Evan Buxton on 11/24/14.
//  Copyright (c) 2014 neoscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (AppVersion)

+ (NSString *) appVersion;

+ (NSString *) build;

+ (NSString *) versionBuild;

@end
