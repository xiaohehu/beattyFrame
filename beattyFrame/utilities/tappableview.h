//
//  tappableview.h
//  beattyFrame
//
//  Created by Evan Buxton on 4/20/16.
//  Copyright © 2016 Xiaohe Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class tapviewDeleagte;

@protocol tapviewDeleagte <NSObject>

@optional
-(void)tappedView:(NSInteger)index;
@end

@interface tappableview : UIView
@property (nonatomic, strong) id <tapviewDeleagte> delegate;
-(id)initWithFrame:(CGRect)frame title:(NSString*)title tag:(int)tag;
-(void)setSelected:(BOOL)isSelected;
@end
