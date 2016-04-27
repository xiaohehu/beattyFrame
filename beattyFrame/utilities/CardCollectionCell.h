//
//  collectionCell.m
//  utc
//
//  Created by Evan Buxton on 9/18/15.
//  Copyright © 2015 Neoscape. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CardCollectionCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UITextView *desc;
@property (nonatomic, strong) IBOutlet UIImageView *logo;


@end