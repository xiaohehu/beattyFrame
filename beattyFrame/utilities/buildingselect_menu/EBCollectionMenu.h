//
//  EBCollectionMenu.h
//  tint
//
//  Created by Evan Buxton on 4/17/15.
//  Copyright (c) 2015 Evan Buxton. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EBCollectionMenuDelegate;

@interface EBCollectionMenu : UIView

- (id)initWithFrame:(CGRect)frame;
- (void)startingIndex:(NSInteger)startingIndex;
@property (weak) id<EBCollectionMenuDelegate> delegate;
@property (strong, nonatomic) NSArray *arr_colors;
@end

@protocol EBCollectionMenuDelegate <NSObject>


@required
// ask the delegate how many views he wants to present inside the horizontal scroller
- (NSInteger)numberOfCellsForCollectionMenu:(EBCollectionMenu*)collectionview;

// inform the delegate what the view at <index> has been clicked
- (void)horizontalCollectionMenu:(EBCollectionMenu*)collectionview clickedViewAtIndex:(int)index;
@end