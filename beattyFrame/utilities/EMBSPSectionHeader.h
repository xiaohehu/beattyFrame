//
//  CVSectionHeader.h
//  quadrangle
//
//  Created by Evan Buxton on 6/29/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMBSPSectionHeader : UICollectionReusableView
@property(nonatomic, strong) IBOutlet UILabel *sectionLabel;
-(void)setCategoryText:(NSString *)text;
@end
