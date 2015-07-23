//
//  GalleryViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 7/23/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "GalleryViewController.h"
#import "GalleryCollectionViewCell.h"
#import <XHGalleryUIControls/XHGalleryUIControls.h>

@interface GalleryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, XHGalleryDelegate>
{
    NSArray                     *arr_rawData;
}
@property (weak, nonatomic) IBOutlet UICollectionView *uic_collectionView;
@property (strong, nonatomic)   XHGalleryViewController *gallery;

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _uic_collectionView.delegate = self;
    _uic_collectionView.dataSource = self;
    [self prepareGalleryData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareGalleryData
{
    NSString *url = [[NSBundle mainBundle] pathForResource:@"photoData" ofType:@"plist"];
    arr_rawData = [[NSArray alloc] initWithContentsOfFile:url];
    NSLog(@"%@", arr_rawData);
}

#pragma mark - Gallery UICollection View
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  30;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GalleryCollectionViewCell *galleryCell = [collectionView
                                dequeueReusableCellWithReuseIdentifier:@"myCell"
                                forIndexPath:indexPath];
    galleryCell.cellThumb.backgroundColor = [UIColor redColor];
    return galleryCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _gallery = [[XHGalleryViewController alloc] init];
    _gallery.delegate = self;
    _gallery.startIndex = 0; 		// Change this value to start with different page
    _gallery.view.frame = self.view.bounds; 	// Change to load different frame
    _gallery.arr_rawData = [arr_rawData objectAtIndex:0];
    [self addChildViewController: _gallery];
    [self.view addSubview: _gallery.view];
}

- (void)didRemoveFromSuperView
{
    [_gallery.view removeFromSuperview];
    _gallery.view = nil;
    [_gallery removeFromParentViewController];
    _gallery = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
