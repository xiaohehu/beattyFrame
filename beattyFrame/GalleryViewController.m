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
#import "embEmailData.h"
#import "EMBSPCell.h"
#import "EMBSPSupplementaryView.h"
#import "UIImage+ScaleToFit.h"
//#import "TLSpringFlowLayout.h"
#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"

//#import "UIColor+Extensions.h"

@interface GalleryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, XHGalleryDelegate,UIDocumentInteractionControllerDelegate>
{
    UIButton            *uib_sectionTitle;
   
    NSArray             *arr_rawData;
    
    UICollectionView	*_collectionView;
    NSString			*secTitle;
    NSString			*assetName;
    NSDictionary		*albumDict;
    NSArray				*albumSections;
    NSMutableArray		*arr_AlbumData;
    NSMutableArray		*selectedIndexPaths;
    NSMutableArray		*selectedArray;
    NSMutableArray		*captionArray;
    NSMutableString		*captionString;
    NSMutableString		*totalBytesString;
    NSMutableArray		*filesInPDF;
    NSMutableArray		*bytesInPDF;
    CGFloat             totalBhytes;
    
    __weak IBOutlet UIView *uiv_sharePanel;
    __weak IBOutlet UIButton *uib_shareSwitch;
    IBOutlet UIButton	*uib_Email;
    IBOutlet UIButton	*uib_PDF;
    __weak IBOutlet UITextView *uitv_sharedList;
    CGSize				_pageSize;
    NSString			*greetingName;
    NSString			*sendEmail;
    __weak IBOutlet UIImageView *uiiv_bg;
    __weak IBOutlet UILabel *uil_help;
    __weak IBOutlet UILabel *uil_totalSize;
    
    UIView *upperRect;
    UIView *lowerRect;
    
    __weak IBOutlet UIView *uiv_preparedFor;
    
    BOOL                isShare;
   UIDocumentInteractionController *doccontroller;

}
@property (weak, nonatomic) IBOutlet UICollectionView *uic_collectionView;
@property (strong, nonatomic)   XHGalleryViewController *gallery;
@property (weak, nonatomic) IBOutlet UITextField *uitf_name;
@property (weak, nonatomic) IBOutlet UIView *uiv_helpContainer;
@property (weak, nonatomic) IBOutlet UIButton *uib_Instructions;
@end

@implementation GalleryViewController

- (BOOL)prefersStatusBarHidden {
   
   return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _uic_collectionView.delegate = self;
    _uic_collectionView.dataSource = self;
    [self prepareGalleryData];
    
    uib_Email.enabled = NO;
    uib_PDF.enabled = NO;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(137, 103)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 0, 40, 0);
    
    _collectionView=[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    _collectionView.frame = CGRectMake(20, 60, 990, 630);
//    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView registerClass:[EMBSPCell class] forCellWithReuseIdentifier:@"EMBSPCell"];
    [_collectionView registerClass:[EMBSPSupplementaryView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cvSectionHeader"];
    [_collectionView reloadData];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [self.view insertSubview:_collectionView belowSubview:uitv_sharedList];
    
    // grab plist of data & Build the array
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"shareableData" ofType:@"plist"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    arr_AlbumData = array;
    albumSections = arr_AlbumData;
    
    // init arrays
    selectedIndexPaths = [[NSMutableArray alloc] init];
    captionString = [[NSMutableString alloc] init];
    totalBytesString = [[NSMutableString alloc] init];
    
    filesInPDF = [[NSMutableArray alloc] init];
    bytesInPDF = [[NSMutableArray alloc] init];
    
    upperRect = [[UIView alloc] init];
    lowerRect = [[UIView alloc] init];
    
    [self setShareSwitchButton];
    uiv_sharePanel.transform = CGAffineTransformMakeTranslation(0, uiv_sharePanel.frame.size.height);
    
    [self createTitleLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareGalleryData
{
    NSString *url = [[NSBundle mainBundle] pathForResource:@"photoData" ofType:@"plist"];
    arr_rawData = [[NSArray alloc] initWithContentsOfFile:url];
//    NSLog(@"%@", arr_rawData);
}

- (void)setShareSwitchButton {
    [uib_shareSwitch setTitle:@"Share" forState:UIControlStateNormal];
    [uib_shareSwitch setTitle:@"Cancel" forState:UIControlStateSelected];
    [uib_shareSwitch addTarget:self action:@selector(shareSwitch:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)shareSwitch:(id)sender {
    uib_shareSwitch.selected = !uib_shareSwitch.selected;
    isShare = uib_shareSwitch.selected;
    [self updateTitleLabel];
    if (isShare) {
        [_uic_collectionView reloadData];
        self.view.layer.borderWidth = 2.0;
        self.view.layer.borderColor = [UIColor themeRed].CGColor;
        [UIView animateWithDuration:0.33 animations:^(void){
            uiv_sharePanel.transform = CGAffineTransformIdentity;
        }];
        
    } else {
        [_uic_collectionView reloadData];
        self.view.layer.borderWidth = 0.0;
        [UIView animateWithDuration:0.33 animations:^(void){
            uiv_sharePanel.transform = CGAffineTransformMakeTranslation(0, uiv_sharePanel.frame.size.height);
        }];
    }
}
- (IBAction)tapCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^(void){
    
    }];
}

- (void)createTitleLabel {
    
    uib_sectionTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_sectionTitle.backgroundColor = [UIColor themeRed];
    [uib_sectionTitle setTitle:@"Gallery" forState:UIControlStateNormal];
    [uib_sectionTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uib_sectionTitle.titleLabel setFont:[UIFont fontWithName:@"GoodPro-Book" size:25.0]];
    [uib_sectionTitle sizeToFit];
    uib_sectionTitle.userInteractionEnabled = NO;
    CGRect frame = uib_sectionTitle.frame;
    frame.size.width += 38;
    uib_sectionTitle.frame = frame;
    [self.view addSubview:uib_sectionTitle];
//    NSLog(@"%@", uib_sectionTitle);
}

- (void)updateTitleLabel {
    if (isShare) {
        [uib_sectionTitle setTitle:@"Share" forState:UIControlStateNormal];
    } else {
        [uib_sectionTitle setTitle:@"Gallery" forState:UIControlStateNormal];
    }
    [uib_sectionTitle sizeToFit];
    CGRect frame = uib_sectionTitle.frame;
    frame.size.width += 38;
    uib_sectionTitle.frame = frame;
}

- (void)scrollToIndex:(int)sectionIndex {
    NSLog(@"haha %i", sectionIndex);
    NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:sectionIndex];
    [_uic_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

#pragma mark - Collection View
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSUInteger numGallSections = [albumSections count];
    NSLog(@"%i", numGallSections);
    return numGallSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDictionary *tempDic = [[NSDictionary alloc] initWithDictionary:[arr_AlbumData objectAtIndex:section]];
    NSMutableArray *secInfo = [[NSMutableArray alloc] initWithArray:[tempDic objectForKey:@"sectioninfo"]];
    int sumOfImg = 0;
    NSString *typeOfFile = [[NSString alloc] init];
    
    for (int i = 0; i < [secInfo count]; i++) {
        NSDictionary *itemDic = [[NSDictionary alloc] initWithDictionary:secInfo[i]];
        typeOfFile = [itemDic objectForKey:@"albumtype"];
        NSMutableArray *imgArray = [[NSMutableArray alloc] initWithArray:[itemDic objectForKey:@"assets"]];
        
        NSEnumerator *enumerator = [imgArray objectEnumerator];
        id imagePath;

        if ( ! [typeOfFile isEqualToString:@"pdf"] ) {
            while (imagePath = [enumerator nextObject]) {
                if ([[imagePath pathExtension] isEqualToString:@"pdf"]) {
                    [imgArray removeObject:imagePath];
                }
            }
        }
        
        sumOfImg = sumOfImg + (int)[imgArray count];
    }
    return sumOfImg;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    if (section >= 1) {
//        return UIEdgeInsetsMake(0, 0, 0, 0);
//    }
//    else {
//        return UIEdgeInsetsMake(10, 0, 0, 0);
//    }
//}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    if (section >= 1) {
        return CGSizeMake(500, 60);
//    }
//    else {
//        return CGSizeMake(500, 20);
//    }
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)ccollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    EMBSPSupplementaryView *supplementaryView = [[EMBSPSupplementaryView alloc] init];
    
    if(kind == UICollectionElementKindSectionHeader){
        supplementaryView = [ccollectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"cvSectionHeader" forIndexPath:indexPath];
        supplementaryView.backgroundColor = [UIColor clearColor];
        NSDictionary *gallDictionary = arr_AlbumData[indexPath.section]; // grab dict
        secTitle = [[gallDictionary objectForKey:@"SectionName"] uppercaseString];
        supplementaryView.label.text = secTitle;
        supplementaryView.label.autoresizesSubviews = YES;
        supplementaryView.label.transform = CGAffineTransformMakeTranslation(0 , 15);
        supplementaryView.label.font = [UIFont fontWithName:@"GoodPro-Book" size:18.0];
    }
    
    
    return supplementaryView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"EMBSPCell";
    EMBSPCell *cell = (EMBSPCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSDictionary *tempDic = [[NSDictionary alloc] initWithDictionary:[arr_AlbumData objectAtIndex:indexPath.section]];
    NSMutableArray *secInfo = [[NSMutableArray alloc] initWithArray:[tempDic objectForKey:@"sectioninfo"]];
    
    NSMutableArray *totalImg = [[NSMutableArray alloc] init];
    NSMutableArray *totalCap = [[NSMutableArray alloc] init];
    NSString *typeOfCell = [[NSString alloc] init];
    
    for (int i = 0; i < [secInfo count]; i++) {
        NSDictionary *itemDic = [[NSDictionary alloc] initWithDictionary:[secInfo objectAtIndex:i]];
        typeOfCell = [itemDic objectForKey:@"albumtype"];
        
        NSMutableArray *imgArray = [[NSMutableArray alloc] initWithArray:[itemDic objectForKey:@"assets"]];
        NSMutableArray *capArray = [[NSMutableArray alloc] initWithArray:[itemDic objectForKey:@"captions"]];
        
        NSEnumerator *enumerator = [imgArray objectEnumerator];
        id imagePath;
        
        if ( ! [typeOfCell isEqualToString:@"pdf"] ) {
            while (imagePath = [enumerator nextObject]) {
                if ([[imagePath pathExtension] isEqualToString:@"pdf"]) {
                    [imgArray removeObject:imagePath];
                }
            }
        }

        [totalImg addObjectsFromArray:imgArray];
        [totalCap addObjectsFromArray:capArray];
    }

    cell.backgroundColor = [UIColor clearColor];
    [cell.titleLabel setText:[totalCap objectAtIndex:indexPath.row]];
   NSLog(@"cap: %@",[totalCap objectAtIndex:indexPath.row]);
    cell.titleLabel.font = [UIFont fontWithName:@"GoodPro-Book" size:11];

    
    
    
    //cell.cellThumb.image = [UIImage imageNamed:[totalImg objectAtIndex:indexPath.row]];
    //cell.cellThumb.image = [UIImage imageNamed:@"thumb_generic.png"];
    //[cell.cellThumb setContentMode:UIViewContentModeScaleAspectFill];
    
    //cell.cellThumb.image = [UIImage imageNamed:@"thumb_generic.png"];
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //NSLog(@"image looking for: %@",typeOfCell);

    
    if ([typeOfCell isEqualToString:@"pdf"] ) {
        
        cell.cellThumb.image = [UIImage imageNamed:@"thumb_generic.png"];

    } else {
        
        //NSLog(@"indexPath.row %ld", (long)indexPath.row);
                
        UIImage * thumb = [UIImage imageNamed:[totalImg objectAtIndex:indexPath.row]];
        //        cell.cellThumb.image = thumb;
        // });
        //dispatch_async(dispatch_get_main_queue(), ^{
        cell.cellThumb.image = [self resizeImage:thumb withMaxDimension:120];
        //[collectionView reloadData];
        //});
    }
    
    
    if (isShare) {
        NSNumber *selSection = [NSNumber numberWithInt:(int)indexPath.section];
        NSNumber *selRow = [NSNumber numberWithInt:(int)indexPath.row];
        
        NSString *selKeyName = [NSString stringWithFormat:@"%@-%@",[selSection stringValue], [selRow stringValue]];
        NSString *selValue = [NSString stringWithFormat:@"%@,%@",[selSection stringValue], [selRow stringValue]];
        
        NSDictionary *myDict = [self findDictionaryWithValue:selKeyName forKey:selValue];
        
        //cell.cellThumb.layer.cornerRadius = cell.frame.size.width / 2.0;
        
        if (myDict!=nil) {
            NSLog(@"should hilight");
            //cell.cellThumb.layer.borderColor = [[UIColor darkGrayColor] CGColor];
            //cell.cellThumb.layer.borderWidth = 4.0;
            
            cell.imgFrame.hidden = NO;
            cell.imgFrame.image = [UIImage imageNamed:@"grfx_selectedFrame.png"];
            
        } else {
            //cell.cellThumb.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            //cell.cellThumb.layer.borderWidth = 2.0;
            
            cell.imgFrame.hidden = NO;
            cell.imgFrame.image = [UIImage imageNamed:@"grfx_unselectedFrame.png"];
            
        }
    } else {
        cell.imgFrame.hidden = YES;
    }
    
    return cell;
}

- (UIImage *)resizeImage:(UIImage *)image
        withMaxDimension:(CGFloat)maxDimension
{
    if (fmax(image.size.width, image.size.height) <= maxDimension) {
        return image;
    }
    
    CGFloat aspect = image.size.width / image.size.height;
    CGSize newSize;
    
    if (image.size.width > image.size.height) {
        newSize = CGSizeMake(maxDimension, maxDimension / aspect);
    } else {
        newSize = CGSizeMake(maxDimension * aspect, maxDimension);
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    CGRect newImageRect = CGRectMake(0.0, 0.0, newSize.width, newSize.height);
    [image drawInRect:newImageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(137, 130);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isShare) {
        NSNumber *selSection = [NSNumber numberWithInt:(int)indexPath.section];
        NSNumber *selRow = [NSNumber numberWithInt:(int)indexPath.row];
        
        NSString *selKeyName = [NSString stringWithFormat:@"%@-%@",[selSection stringValue], [selRow stringValue]];
        NSString *selValue = [NSString stringWithFormat:@"%@,%@",[selSection stringValue], [selRow stringValue]];
        
        // item caption for text view
        NSString *itemCaption;
        
        // check for previously selected cell dictionaries
        NSDictionary *selectedCellsDict = [self findDictionaryWithValue:selKeyName forKey:selValue];
        
        // cells dictionary is not in selectedIndexPaths
        // so add it now
        if (selectedCellsDict==nil) {
            
            NSDictionary *ggallDict = [arr_AlbumData objectAtIndex:indexPath.section];
            NSArray *ggalleryArray = [ggallDict objectForKey:@"sectioninfo"];
            
            for (int i = 0; i < [ggalleryArray count]; i++) {
                NSDictionary *itemDic = [[NSDictionary alloc] initWithDictionary:ggalleryArray[i]];
                
                //Add all items' names into this array
                NSArray *t = [itemDic objectForKey:@"assets"];
                assetName = [t objectAtIndex:indexPath.row];
                
                NSArray *g = [itemDic objectForKey:@"captions"];
                itemCaption = [g objectAtIndex:indexPath.row];
            }
            
            // get bytes and add to the array
            //CGFloat totBytes = [self byteSizeOfFile];
            
            NSNumber *byt = [NSNumber numberWithFloat:[self byteSizeOfFile]];
            
            NSDictionary *dictSelIndexPaths = [[NSDictionary alloc] initWithObjectsAndKeys:
                                               selKeyName, [NSString stringWithFormat:@"%@,%@",[selSection stringValue], [selRow stringValue]],
                                               assetName, @"fileName",
                                               itemCaption, @"caption",
                                               byt, @"bytes",
                                               nil];
            
            [selectedIndexPaths addObject:dictSelIndexPaths];
            
            [_uic_collectionView reloadData];
            
        } else {
            
            [selectedIndexPaths removeObject:selectedCellsDict];
        }
        
        [self updateSelectedText];
        [self updateTotalBytes];
        
        // and now reload only the cells that need updating
        [collectionView reloadData];
        
    } else {
        NSMutableArray *images = [NSMutableArray new];
        NSMutableArray *captions = [NSMutableArray new];
        NSDictionary *sectionOuterDict = [[arr_AlbumData objectAtIndex:indexPath.section] objectForKey:@"sectioninfo"] [0];
        //NSArray *assetArray = [sectionOuterDict objectForKey:@"sectioninfo"];
       NSArray *assetArray = [sectionOuterDict objectForKey:@"assets"];

       NSLog(@"sectionOuterDict %@ ",sectionOuterDict);
       
       if ([[sectionOuterDict objectForKey:@"albumtype"] isEqualToString:@"pdf"]) {
          
          [self viewPDF:assetArray[indexPath.row]];
          
       } else {
          
          for (int i = 0; i < [assetArray count]; i++) {
             NSDictionary *itemDic = [[NSDictionary alloc] initWithDictionary:sectionOuterDict];
             
             //Add all items' names into this array
             images = [itemDic objectForKey:@"assets"];
             captions = [itemDic objectForKey:@"captions"];
          }

          
//          for (int i = 0; i < [assetArray count]; i++) {
//             NSDictionary *itemDic = [[NSDictionary alloc] initWithDictionary:assetArray[i]];
//             //Add all items' names into this array
//             images = [itemDic objectForKey:@"assets"];
//             captions = [itemDic objectForKey:@"captions"];
//          }
          
          NSMutableArray *galleryData = [NSMutableArray new];
          
          for (int i = 0; i < images.count; i++) {
             NSDictionary *gallery_item = @{
                                            @"caption" : captions[i],
                                            @"file" : images[i],
                                            @"type" : @"image"
                                            };
             [galleryData addObject: gallery_item];
          }
          
          _gallery = [[XHGalleryViewController alloc] init];
          _gallery.delegate = self;
          _gallery.startIndex = indexPath.row; 		// Change this value to start with different page
          _gallery.view.frame = self.view.bounds; 	// Change to load different frame
          _gallery.arr_rawData = galleryData;//arr_rawData[0];
          [self addChildViewController: _gallery];
          [self.view addSubview: _gallery.view];
       }
   }
}

-(CGFloat)byteSizeOfFile
{
    NSString		*linkText = assetName;
//    NSData			*imgData;
    //UIImage			*pngImage;
    long long fileSize;
    
    // if cell == existing documents, calculate that size
    //	if ([linkText containsString:@".pdf"]) {
//    if ([linkText rangeOfString:@".pdf"].length > 0) {
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:linkText ofType:nil];
//        imgData = [NSData dataWithContentsOfFile:imagePath];
//    } else {
    
        
        
        NSString *justFileName = [[linkText lastPathComponent] stringByDeletingPathExtension];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:justFileName ofType:[linkText pathExtension]];
        NSLog(@"imagePath\n\n%@\n\n", imagePath);
        
        fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:imagePath error:nil][NSFileSize] longLongValue];
    
        //pngImage = [UIImage imageByScalingAndCroppingForSize:CGSizeMake(1100, 850) image:[UIImage imageWithContentsOfFile:imagePath]];
        //pngImage = [UIImage scaleImage:[UIImage imageWithContentsOfFile:imagePath] toSize:CGSizeMake(1100, 850)];
        //pngImage = [UIImage imageWithImage:[UIImage imageWithContentsOfFile:imagePath] scaledToWidth:1100];
        //UIImage *t = pngImage;
        //UIImage *t = [UIImage imageWithContentsOfFile:imagePath];
        //imgData = UIImageJPEGRepresentation(t, 9);
        
//        NSString *justFileName = [[linkText lastPathComponent] stringByDeletingPathExtension];
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:justFileName ofType:@"jpg"];
//        pngImage = [UIImage imageWithImage:[UIImage imageWithContentsOfFile:imagePath] scaledToWidth:1100];
//        UIImage *t = [UIImage imageWithContentsOfFile:imagePath];
//        imgData = UIImagePNGRepresentation(t);
//    }
    
    long bytesString = fileSize;
    
    return bytesString;
}

-(void)updateTotalBytes
{
    if (bytesInPDF) {
        [bytesInPDF removeAllObjects];
        totalBhytes=0;
    }
    
    bytesInPDF = [[selectedIndexPaths valueForKey:@"bytes"] mutableCopy];
    
    for (NSNumber *t in bytesInPDF) {
        totalBhytes = totalBhytes+[t intValue];
    }
    
    [self updateProgress];
    NSLog(@"totalBhytes %f",totalBhytes/1000);
}

//----------------------------------------------------
#pragma mark - scrollview delegate methods
//----------------------------------------------------
/*
 collection inherits from scroll and we need to know if
 the cv scrolls to hide the help
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _uiv_helpContainer.hidden = YES;
    _uib_Instructions.selected = NO;
}

-(IBAction)toggleInstructions:(id)sender
{
    _uib_Instructions.selected = !_uib_Instructions.selected;
    
    if ([_uib_Instructions isSelected]) {
        _uiv_helpContainer.hidden = NO;
    } else {
        _uiv_helpContainer.hidden = YES;
    }
}

#pragma mark - Bytes

-(void)updateProgress
{
   UIColor *spaceleft = [UIColor redColor];
   double percentDone = ((double)totalBhytes / 10000)*.001;
   if ((percentDone > 0.9) && (percentDone < 1.0))  {
      spaceleft = [UIColor redColor];
      [upperRect setBackgroundColor:[UIColor orangeColor]];
   } else if (percentDone > 1.0) {
      percentDone = 1;
      [upperRect setBackgroundColor:[UIColor redColor]];
   } else {
      [upperRect setBackgroundColor:[UIColor selectedBlue]];
      spaceleft = [UIColor selectedBlue];
   }
    
    CGRect rect = CGRectMake(20, 50, 430, 5);
    upperRect.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width * percentDone, rect.size.height );
    lowerRect.frame = CGRectMake(rect.origin.x + (rect.size.width * percentDone), rect.origin.y, rect.size.width*(1-percentDone), rect.size.height );
    lowerRect.alpha = 1.0;
    upperRect.alpha = 1.0      ;
    [lowerRect setBackgroundColor:[UIColor whiteColor]];
    [uiv_sharePanel addSubview: lowerRect];
    [uiv_sharePanel addSubview: upperRect];
    
    NSString *sttring = [NSByteCountFormatter stringFromByteCount:totalBhytes countStyle:NSByteCountFormatterCountStyleFile];
    uil_totalSize.text = [NSString stringWithFormat:@"Size: %@",sttring];
}

#pragma mark - Create list of shared assets
-(void)updateSelectedText
{
    if (captionArray) {
        [captionArray removeAllObjects];
        [captionString setString:@""];
    }
    
    captionArray = [[selectedIndexPaths valueForKey:@"caption"] mutableCopy];
    
    for (NSString *linkText in captionArray) {
        [captionString appendString:[NSString stringWithFormat:@"%@,  ",linkText]];
    }
    
    uitv_sharedList.textColor = [UIColor colorWithWhite:1.0 alpha:0.75];
    
    if (captionArray.count == 0) {
        uitv_sharedList.text = @"";
        [self toggleUIButton:uib_Email enabled:NO];
        [self toggleUIButton:uib_PDF enabled:NO];
        uil_help.hidden=NO;
    } else {
        uitv_sharedList.text = [NSString stringWithFormat:@"Sharing : %@",captionString];
        [self toggleUIButton:uib_Email enabled:YES];
        [self toggleUIButton:uib_PDF enabled:YES];
        uil_help.hidden=YES;
    }
    
    [uitv_sharedList scrollRangeToVisible:NSMakeRange([uitv_sharedList.text length], 0)];
    [uitv_sharedList setScrollEnabled:NO];
    [uitv_sharedList setScrollEnabled:YES];
}

-(void)toggleUIButton:(UIButton*)btn enabled:(BOOL)enabled
{
    if (enabled == NO) {
        btn.enabled = enabled;
        btn.layer.borderColor = [UIColor clearColor].CGColor;
        btn.layer.borderWidth = 0.0;
    } else {
        btn.enabled = enabled;
//        btn.layer.borderColor = [UIColor whiteColor].CGColor;
//        btn.layer.borderWidth = 1.0;
    }
}

#pragma mark - Convenience DIctionary Function
- (NSDictionary *)findDictionaryWithValue:(NSString*)name forKey:(NSString *)key {
    __block BOOL found = NO;
    __block NSDictionary *dict = nil;
    
    [selectedIndexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        dict = (NSDictionary *)obj;
        NSString *title = [dict valueForKey:key];
        if ([title isEqualToString:name]) {
            found = YES;
            *stop = YES;
        }
    }];
    
    if (found) {
        return dict;
    } else {
        return nil;
    }
}

#pragma mark - Email
#pragma Blank
-(IBAction)sendBlankEmail
{
    embEmailData *emailData = [[embEmailData alloc] init];
    emailData.optionsAlert=NO;
}

#pragma mark Email Selected Array after formatting
-(IBAction)finishedSelectingItemsForEmail:(id)sender
{
    UIButton*selectedBtn = (UIButton*)sender;
    BOOL isPDF;
    
    if (selectedBtn.tag == 110) {
        isPDF = YES;
    } else{
        isPDF = NO;
    }
    
    NSLog(@"Finished Selecting");
    
    selectedArray = [[selectedIndexPaths valueForKey:@"fileName"] mutableCopy];
    
    NSString	*justFileName;
    NSString	*webLinkBody;
    NSArray		*attachmentData;
    
    // web text, if any
    //	NSMutableString *formattedWeb = [self formatWebLinks];
    
    /*
     if ([_uitf_name.text length] == 0) {
     greetingName = [NSString stringWithFormat:@"."];
     } else {
     greetingName = [NSString stringWithFormat:@", %@", _uitf_name.text];
     }
     
     webLinkBody = [NSString stringWithFormat:@"Thank you for visiting The Ritz-Carlton Residences, Long Island, North Hills%@<br /><br />%@", greetingName,formattedWeb];
     */
    
    webLinkBody = [NSString stringWithFormat:@"Thank you for your interest in Harbor Point."];
    
    if (isPDF) {
        // inserted cover page to array
        justFileName = @"Brochure_Cover_Page_01";
        [selectedArray insertObject:justFileName atIndex:0];
        
        // pdf creation
        [self setupPDFDocumentNamed:@"Demo" Width:850 Height:1100];
        
        // remove any other pdfs temporarily
        NSMutableArray *tempRemovePDFS = [NSMutableArray array];
        for (id file in selectedArray) {
            if ([[file pathExtension] isEqualToString:@"pdf"]) {
                [tempRemovePDFS addObject:file];
                NSLog(@"removed existing pdf: %@", file);
            }
        }
        [selectedArray removeObjectsInArray:tempRemovePDFS];
        
        // pdf data
        [self addDataToPDF:selectedArray];
        
        // close & save pdf
        [self finishAndSavePDF];
        
        // get newly saved pdf from documents directory and send
        NSData *pdfData = [self getPDFAsNSDataNamed:@"Demo.pdf"];
        NSMutableArray*attachData = [[NSMutableArray alloc] initWithObjects:pdfData, nil];
        
        // remove anything already added to the created pdf
        // remove cover image
        [selectedArray removeObjectAtIndex:0];
        
        // remove any other images from array
        NSMutableArray *tooDelete = [NSMutableArray array];
        for (id file in selectedArray) {
            if ([[file pathExtension] isEqualToString:@"jpg"]) {
                [tooDelete addObject:file];
                NSLog(@"removed: %@", file);
            }
        }
        
        [selectedArray removeObjectsInArray:tooDelete];
        
        // add BACK in any added pdfs
        [attachData addObjectsFromArray:tempRemovePDFS];
        
        // prepare final array to send to email,
        [attachData addObjectsFromArray:selectedArray];
        attachmentData = [NSArray arrayWithArray:attachData];
        
    } else {
        attachmentData = selectedArray;
        NSLog(@"\n\n\n %@", attachmentData);
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        embEmailData *emailData = [[embEmailData alloc] init];
        //emailData.to = @[@"evan.buxton@neoscape.com"];
        //		if (self.user.email) {
        //			emailData.to = @[sendEmail];
        //		}
        emailData.subject = @"Greetings from Harbor Point";
        emailData.body = webLinkBody;
        emailData.attachment = attachmentData;
        emailData.optionsAlert=NO;
    }];
    
}

-(NSMutableString*)formatWebLinks
{
    NSMutableArray *temp = [selectedArray copy];
    
    NSString	*justFileName;
    
    NSMutableArray *weblinks = [[NSMutableArray alloc] init];
    
    // remove all .com's and add to sep. array
    for (id file in temp)
    {
        justFileName = [[file lastPathComponent] stringByDeletingPathExtension];
        NSPredicate *endsNumerically = [NSPredicate predicateWithFormat:@"SELF matches %@", @"\\d+$"];
        [endsNumerically evaluateWithObject:justFileName];
        NSLog(@"justFileName %@",justFileName);
        
        if ([[file pathExtension] isEqualToString:@"com"]) {
            [weblinks addObject:file];
            [selectedArray removeObject:file];
        } else if ([[file pathExtension] isEqualToString:@"pdf"]) {
            [weblinks addObject:file];
            NSLog(@"add pdf");
            [selectedArray removeObject:file];
        } else if ([justFileName isEqualToString:@"71362850"]) {
            [weblinks addObject:file];
            [selectedArray removeObject:file];
            NSLog(@"= 71362850");
        }
    }
    
    NSMutableArray *bodyLinks = [[NSMutableArray alloc] init];
    
    for (NSString *weblink in weblinks) {
        NSString *textWithLink;
        
        NSLog(@"embAssetPickerViewController: %@",weblink);
        
        NSString *theString = weblink;   // The one we want to switch on
        if ([theString isEqualToString:@"http://neoscapelabs.com"]) {
            textWithLink = [NSString stringWithFormat:@"Visit the <a href = '%@'>Website</a><br />",theString];
        } else if ([theString isEqualToString:@"http://www.neoscape.com/wp-content/uploads/2014/07/SrProjectManager_Neoscape_July2014R.pdf"]) {
            textWithLink = [NSString stringWithFormat:@"Read the <a href = '%@'>Facts</a><br />",theString];
        } else if ([theString isEqualToString:@"http://vimeo.com/71362850"]) {
            textWithLink = [NSString stringWithFormat:@"View the <a href = '%@'>Film</a><br />",theString];
        } else if ([theString isEqualToString:@"http://www.neoscape.com/wp-content/uploads/2014/06/InteractiveDeveloperM1_Neoscape_June2014.pdf"]) {
            textWithLink = [NSString stringWithFormat:@"View the <a href = '%@'>Floor Plans</a><br />",theString];
        }
        [bodyLinks addObject:textWithLink];
    }
    
    NSString *concatLinks;
    NSMutableString *s = [[NSMutableString alloc] init];
    
    for (NSString *linkText in bodyLinks) {
        concatLinks = [NSString stringWithFormat:@"%@",linkText];
        [s appendString:linkText];
    }
    
    return s;
}

-(NSData*)getPDFAsNSDataNamed:(NSString*)name
{
    // find new pdf and add to mydata for emailing
    NSString *searchFilename = name; // name of the PDF you are searching for
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager] enumeratorAtPath:documentsDirectory];
    NSString *documentsSubpath;
    NSData *myPdfData;
    while (documentsSubpath = [direnum nextObject])
    {
        if (![documentsSubpath.lastPathComponent isEqual:searchFilename]) {
            continue;
        }
        NSLog(@"found %@", documentsSubpath);
        NSString *pdfFileName = [documentsDirectory stringByAppendingPathComponent:searchFilename];
        NSLog(@"t %@", pdfFileName);
        myPdfData = [NSData dataWithContentsOfFile:pdfFileName];
    }
    
    return myPdfData;
}


#pragma mark - pdf creation
- (void)setupPDFDocumentNamed:(NSString*)name Width:(float)width Height:(float)height
{
    _pageSize = CGSizeMake(width, height);
    NSString *pdfName = @"Demo.pdf";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFileName = [documentsDirectory stringByAppendingPathComponent:pdfName];
    
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
    
    _pageSize = CGSizeMake(width, height);
    
}

- (void)beginPDFPage {
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, _pageSize.width, _pageSize.height), nil);
}

-(void)addDataToPDF:(NSMutableArray*)data
{
    
    NSString	*justFileName;
    UIImage		*pngImage;
    NSInteger	currentPage = 0;
    CGFloat		yPad=0;
    
    for (id file in data)
    {
        // Mark the beginning of a new page.
        
        [self beginPDFPage];
        
        if (currentPage==0) {
            
            justFileName = [[file lastPathComponent] stringByDeletingPathExtension];
            
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:justFileName ofType:@"jpg"];
            
            UIImage *pngImage = [UIImage imageWithContentsOfFile:imagePath];
            [pngImage drawInRect:CGRectMake(0, 0, _pageSize.width, _pageSize.height)];
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGAffineTransform ctm = CGContextGetCTM(context);
            
            // Translate the origin to the bottom left.
            // Notice that 842 is the size of the PDF page.
            CGAffineTransformTranslate(ctm, 0.0, 1100);
            
            // Flip the handedness of the coordinate system back to right handed.
            CGAffineTransformScale(ctm, 1.0, -1.0);
            
            // add name
            // Convert the update rectangle to the new coordiante system.
            // CGRect xformRect = CGRectApplyAffineTransform(CGRectMake(50, 750, 300, 100), ctm);
            
            //			NSLog(@"_username %@",self.user.fullName);
            
            // add custom name to pdf
            //			if ([_uitf_name.text length] == 0) {
            //				greetingName = self.user.fullName;
            //			} else {
            //				greetingName = _uitf_name.text;
            //			}
            
            /*
             if (self.user.fullName) {
             NSString *url = [NSString stringWithFormat:@"Prepared for %@", _uitf_name.text];
             UIGraphicsSetPDFContextDestinationForRect(url, xformRect );
             
             CGContextSaveGState(context);
             NSDictionary *attributesDict;
             NSMutableAttributedString *attString;
             
             NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
             [style setAlignment:NSTextAlignmentCenter];
             
             attributesDict = @{NSForegroundColorAttributeName : [UIColor whiteColor],
             NSParagraphStyleAttributeName : style,
             NSFontAttributeName :[UIFont systemFontOfSize:20.0]};
             
             attString = [[NSMutableAttributedString alloc] initWithString:url attributes:attributesDict];
             
             [attString drawInRect:CGRectMake(270, 950, 300, 100)];
             
             CGContextRestoreGState(context);
             
             }
             */
        } else {
            
            justFileName = [[file lastPathComponent] stringByDeletingPathExtension];
            
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:justFileName ofType:@"jpg"];
            
            pngImage = [UIImage imageWithImage:[UIImage imageWithContentsOfFile:imagePath] scaledToWidth:_pageSize.width];
            
            // center image in page
            CGFloat centerY = (_pageSize.height - pngImage.size.height) / 2;
            
            [pngImage drawInRect:CGRectMake(0, centerY, pngImage.size.width, pngImage.size.height)];
        }
        
        yPad = pngImage.size.height;
        
        NSData *imgData = UIImageJPEGRepresentation(pngImage, 0);
        //NSLog(@"Size of Image(bytes):%lu",(unsigned long)[imgData length]);
        
        //NSLog(@"%@",[NSByteCountFormatter stringFromByteCount:imgData.length countStyle:NSByteCountFormatterCountStyleFile]);
        
        NSString *string = [NSByteCountFormatter stringFromByteCount:[imgData length] countStyle:NSByteCountFormatterCountStyleFile];
        
        [filesInPDF addObject:[NSNumber numberWithFloat:[string floatValue]]];
        
        //[totalBytesString appendString:string];
        //		NSLog(@"totalBytesString = %@", totalBytesString);
        
        currentPage++;
        //[self drawPDFPageNumber:currentPage];
    }
    
    CGFloat i = 0;
    for (int g = 0; g< [filesInPDF count]; g++) {
        i += [filesInPDF[g] floatValue];
    }
    
    [totalBytesString appendString:[NSByteCountFormatter stringFromByteCount:i countStyle:NSByteCountFormatterCountStyleFile]];
    //	NSLog(@"totalBytesString = %@", totalBytesString);
    
    /*
     // link added to end pdf
     CGContextRef context = UIGraphicsGetCurrentContext();
     CGAffineTransform ctm = CGContextGetCTM(context);
     
     // Translate the origin to the bottom left.
     // Notice that 850 is the size of the PDF page.
     CGAffineTransformTranslate(ctm, 0.0, 850);
     
     // Flip the handedness of the coordinate system back to right handed.
     CGAffineTransformScale(ctm, 1.0, -1.0);
     
     // Convert the update rectangle to the new coordiante system.
     CGRect xformRect = CGRectApplyAffineTransform(CGRectMake(50, 750, 300, 100), ctm);
     
     // add clickable link to pdf
     NSURL *url = [NSURL URLWithString:@"http://www.neoscape.com"];
     UIGraphicsSetPDFContextURLForRect( url, xformRect );
     
     CGContextSaveGState(context);
     NSDictionary *attributesDict;
     NSMutableAttributedString *attString;
     
     NSNumber *underline = [NSNumber numberWithInt:NSUnderlineStyleSingle];
     attributesDict = @{NSUnderlineStyleAttributeName : underline, NSForegroundColorAttributeName : [UIColor blueColor]};
     attString = [[NSMutableAttributedString alloc] initWithString:url.absoluteString attributes:attributesDict];
     
     [attString drawInRect:CGRectMake(50, 750, 300, 100)];
     
     CGContextRestoreGState(context);
     */
}

- (void)drawPDFPageNumber:(NSInteger)pageNum
{
    NSString *pageString = [NSString stringWithFormat:@"Page %li", (long)pageNum];
    UIFont *theFont = [UIFont systemFontOfSize:12];
    CGSize maxSize = CGSizeMake(612, 72);
    CGRect textRect = [pageString boundingRectWithSize:maxSize
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:theFont}
                                               context:nil];
    
    CGSize pageStringSize = textRect.size;
    
    CGRect stringRect = CGRectMake(40.0,
                                   790 + ((72.0 - pageStringSize.height) / 2.0),
                                   pageStringSize.width,
                                   pageStringSize.height);
    
    NSDictionary *attributesDict;
    NSMutableAttributedString *attString;
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    
    attributesDict = @{NSForegroundColorAttributeName : [UIColor whiteColor],NSParagraphStyleAttributeName : style};
    attString = [[NSMutableAttributedString alloc] initWithString:pageString attributes:attributesDict];
    
    [attString drawInRect:stringRect];
}

- (void)finishAndSavePDF {
    UIGraphicsEndPDFContext();
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfDirectoryString = [NSString stringWithFormat:@"%@/Demo.pdf", documentsDirectory];
    
    NSData *pdfData = [NSData dataWithContentsOfFile:pdfDirectoryString];
    NSError *error = nil;
    if ([pdfData writeToFile:pdfDirectoryString options:NSDataWritingAtomic error:&error]) {
        // file saved
    } else {
        // error writing file
        NSLog(@"Unable to write PDF to %@. Error: %@", pdfDirectoryString,[error localizedDescription]);
    }
}

#pragma mark
#pragma mark PDF Viewer

-(void)viewPDF:(NSString*)thisPDF
{
   NSString *fileToOpen = [[NSBundle mainBundle] pathForResource:[thisPDF stringByDeletingPathExtension]  ofType:@"pdf"];
   NSURL *url = [NSURL fileURLWithPath:fileToOpen];
   doccontroller = [UIDocumentInteractionController interactionControllerWithURL:url];
   [self previewDocumentWithURL:url];
}

- (void)previewDocumentWithURL:(NSURL*)url
{
   UIDocumentInteractionController* preview = [UIDocumentInteractionController interactionControllerWithURL:url];
   preview.delegate = self;
   [preview presentPreviewAnimated:YES];
}

//======================================================================
- (void)documentInteractionControllerDidDismissOptionsMenu:(UIDocumentInteractionController *)controller{
   [[UIApplication sharedApplication] setStatusBarHidden:YES ];
}

//===================================================================
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
   [[UIApplication sharedApplication] setStatusBarHidden:YES];
   return self;
}

- (void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller
{
   [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller
{
   [[UIApplication sharedApplication] setStatusBarHidden:YES];
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
