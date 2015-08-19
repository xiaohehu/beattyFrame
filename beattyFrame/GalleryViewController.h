//
//  GalleryViewController.h
//  beattyFrame
//
//  Created by Xiaohe Hu on 7/23/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

@interface GalleryViewController : UIViewController
@property (nonatomic, copy) NSString *plistName;
@property (nonatomic) User *user;

- (void)scrollToIndex:(int)sectionIndex;

@end
