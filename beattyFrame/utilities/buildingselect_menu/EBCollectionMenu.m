//
//  EBCollectionMenu.m
//  tint
//
//  Created by Evan Buxton on 4/17/15.
//  Copyright (c) 2015 Evan Buxton. All rights reserved.
//

#import "EBCollectionMenu.h"
#import "CVCell.h"
#import "EMBSPSupplementaryView.h"

#define VIEW_PADDING 10
#define VIEW_DIMENSIONS 120
#define VIEWS_OFFSET 100

@interface EBCollectionMenu () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic)			NSIndexPath			*selectedIndexPath;
@end

@implementation EBCollectionMenu
{
    UICollectionView *collectionview;
}

-(void)startingIndex:(NSInteger)startingIndex
{
    self.selectedIndexPath = [NSIndexPath indexPathForRow:startingIndex inSection:0];
    [collectionview reloadData];
}

static NSString * const reuseIdentifier = @"Cell";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(120, 115)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.sectionInset = UIEdgeInsetsMake(80, 20, 30, 0);
        flowLayout.minimumLineSpacing = 40.0;
        
        collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:flowLayout];
        collectionview.backgroundColor = [UIColor clearColor];
        [collectionview setDataSource:self];
        [collectionview setDelegate:self];
        
        [collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
//        [collectionview registerClass:[EMBSPSupplementaryView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cvSectionHeader"];

        [self addSubview:collectionview];
        
        [collectionview reloadData];
        
        // LOAD UP THE NIB FILE FOR THE CELL
        UINib *nib = [UINib nibWithNibName:@"CVCell" bundle:nil];
        
        // REGISTER THE NIB FOR THE CELL WITH THE TABLE
        [collectionview registerNib:nib forCellWithReuseIdentifier:@"cvCell"];
        [self loadView];
    }
    return self;
}

-(void)loadView
{
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arr_colors.count;
}

//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
//
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(100, 28);
//}
//
//-(UICollectionReusableView *)collectionView:(UICollectionView *)ccollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    EMBSPSupplementaryView *supplementaryView = [[EMBSPSupplementaryView alloc] init];
//    
//    
//    
//    if(kind == UICollectionElementKindSectionHeader){
//        supplementaryView = [ccollectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"cvSectionHeader" forIndexPath:indexPath];
//        supplementaryView.backgroundColor = [UIColor redColor];
//        supplementaryView.label.text = @"Harbor Point Parcel List";
//        supplementaryView.label.textColor = [UIColor blackColor];
//        supplementaryView.label.backgroundColor = [UIColor blackColor];
//        //supplementaryView.label.autoresizesSubviews = NO;
//        //supplementaryView.label.transform = CGAffineTransformMakeTranslation(0 , 15);
//        //supplementaryView.label.font = [UIFont fontWithName:@"GoodPro-Book" size:18.0];
//    }
//    return supplementaryView;
//}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Setup cell identifier
    static NSString *cellIdentifier = @"cvCell";
    CVCell *cell = (CVCell *)[collectionview dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSDictionary *cellDict = _arr_colors[indexPath.row];
    
    cell.imageBG.image = [UIImage imageNamed:[cellDict objectForKey:@"buildingImage"]];
    cell.titleLabel.text = [cellDict objectForKey:@"buildingTitle"];
    
    if ([self.selectedIndexPath isEqual:indexPath]) {
        // set highlight color
        cell.imageBG.layer.borderWidth = 3.0;
        cell.imageBG.layer.borderColor = [UIColor redColor].CGColor;
        cell.titleLabel.textColor = [UIColor redColor];
    } else {
        // set default color
        cell.imageBG.layer.borderWidth = 1.0;
        cell.imageBG.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.titleLabel.textColor = [UIColor darkGrayColor];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120, 115);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndexPath != nil) {
        // deselect previously selected cell
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:self.selectedIndexPath];
        if (cell != nil) {
            // set default color for cell
        }
    }

    // Select newly selected cell:
     CVCell *cell = (CVCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell != nil) {
        // set highlight color for cell
        cell.imageBG.layer.borderWidth = 3.0;
        cell.imageBG.layer.borderColor = [UIColor redColor].CGColor;
        cell.titleLabel.textColor = [UIColor redColor];
    }
    // Remember selection:
    self.selectedIndexPath = indexPath;
    
    [self.delegate horizontalCollectionMenu:self clickedViewAtIndex:(int)indexPath.row];
    
    //[collectionView reloadData];
}

#pragma Detail view
- (void)infoClicked:(id)sender
{
    NSLog(@"button cclicked");
    // Posting Notification
    
    NSLog(@"%li", (long)[sender tag]);
    
    NSDictionary* userInfo = @{@"tag": @((long)[sender tag])};
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"embColorDetail" object:self userInfo:userInfo];
}

@end
