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
#import "TLSpringFlowLayout.h"
//#import "UIColor+Extensions.h"

@interface GalleryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, XHGalleryDelegate>
{
    NSArray                     *arr_rawData;
    
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
    CGFloat totalBhytes;
    
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
}
@property (weak, nonatomic) IBOutlet UICollectionView *uic_collectionView;
@property (strong, nonatomic)   XHGalleryViewController *gallery;
@property (weak, nonatomic) IBOutlet UITextField *uitf_name;
@property (weak, nonatomic) IBOutlet UIView *uiv_helpContainer;
@property (weak, nonatomic) IBOutlet UIButton *uib_Instructions;
@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _uic_collectionView.delegate = self;
    _uic_collectionView.dataSource = self;
    [self prepareGalleryData];
    
    uib_Email.enabled = NO;
    uib_PDF.enabled = NO;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(175, 175)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 0, 40, 0);
    
    _collectionView=[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    _collectionView.frame = CGRectMake(20, 60, 990, 630);
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView registerClass:[EMBSPCell class] forCellWithReuseIdentifier:@"EMBSPCell"];
    [_collectionView registerClass:[EMBSPSupplementaryView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"EMBSPSupplementaryView"];
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

- (void)setShareSwitchButton {
    [uib_shareSwitch setTitle:@"Share" forState:UIControlStateNormal];
    [uib_shareSwitch setTitle:@"Cancel" forState:UIControlStateSelected];
    [uib_shareSwitch addTarget:self action:@selector(shareSwitch:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)shareSwitch:(id)sender {
    uib_shareSwitch.selected = !uib_shareSwitch.selected;
    isShare = uib_shareSwitch.selected;
    if (isShare) {
        [UIView animateWithDuration:0.33 animations:^(void){
            uiv_sharePanel.transform = CGAffineTransformIdentity;
        }];
        
    } else {
        [UIView animateWithDuration:0.33 animations:^(void){
            uiv_sharePanel.transform = CGAffineTransformMakeTranslation(0, uiv_sharePanel.frame.size.height);
        }];
    }
}

#pragma mark - Collection View
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSUInteger numGallSections = [albumSections count];
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
        sumOfImg = sumOfImg + (int)[imgArray count];
    }
    return sumOfImg;
}

//-(UICollectionReusableView *)collectionView:(UICollectionView *)ccollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

//    EMBSPSupplementaryView *supplementaryView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"EMBSPSupplementaryView" forIndexPath:indexPath];
//    
//    if(kind == UICollectionElementKindSectionHeader){
//        supplementaryView.backgroundColor = [UIColor clearColor];
//        NSDictionary *gallDictionary = albumSections[indexPath.section]; // grab dict
//        secTitle = [[gallDictionary objectForKey:@"SectionName"] uppercaseString];
//        supplementaryView.label.text = secTitle;
//        supplementaryView.label.textColor = [UIColor darkGrayColor];
//        supplementaryView.label.font = [UIFont fontWithName:@"JosefinSans-SemiBold" size:20];
//    }
//    
//    return supplementaryView;
//}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(500, 25);
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
        
        NSMutableArray *imgArray = [[NSMutableArray alloc] initWithArray:[itemDic objectForKey:@"thumbs"]];
        NSMutableArray *capArray = [[NSMutableArray alloc] initWithArray:[itemDic objectForKey:@"captions"]];
        [totalImg addObjectsFromArray:imgArray];
        [totalCap addObjectsFromArray:capArray];
    }
    
    [cell.titleLabel setText:[totalCap objectAtIndex:indexPath.row]];
    cell.titleLabel.font = [UIFont fontWithName:@"JosefinSans-SemiBold" size:13];
    
    cell.cellThumb.image = [UIImage imageNamed:[totalImg objectAtIndex:indexPath.row]];
    [cell.cellThumb setContentMode:UIViewContentModeScaleAspectFit];
    
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
        
    } else {
        //cell.cellThumb.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        //cell.cellThumb.layer.borderWidth = 2.0;
        
        cell.imgFrame.hidden = YES;
        
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(105, 117);
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
            
        } else {
            
            [selectedIndexPaths removeObject:selectedCellsDict];
        }
        
        [self updateSelectedText];
        [self updateTotalBytes];
        
        // and now reload only the cells that need updating
        [collectionView reloadData];

    } else {
        _gallery = [[XHGalleryViewController alloc] init];
        _gallery.delegate = self;
        _gallery.startIndex = 0; 		// Change this value to start with different page
        _gallery.view.frame = self.view.bounds; 	// Change to load different frame
        _gallery.arr_rawData = arr_rawData[0];
        [self addChildViewController: _gallery];
        [self.view addSubview: _gallery.view];
    }
}

-(CGFloat)byteSizeOfFile
{
    NSString		*linkText = assetName;
    NSData			*imgData;
    UIImage			*pngImage;
    
    // if cell == existing documents, calculate that size
    //	if ([linkText containsString:@".pdf"]) {
    if ([linkText rangeOfString:@".pdf"].length > 0) {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:linkText ofType:nil];
        imgData = [NSData dataWithContentsOfFile:imagePath];
    } else {
        NSString *justFileName = [[linkText lastPathComponent] stringByDeletingPathExtension];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:justFileName ofType:@"jpg"];
        pngImage = [UIImage imageWithImage:[UIImage imageWithContentsOfFile:imagePath] scaledToWidth:1100];
        UIImage *t = [UIImage imageWithContentsOfFile:imagePath];
        imgData = UIImagePNGRepresentation(t);
    }
    
    CGFloat bytesString = [imgData length];
    
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
    float percentDone = 0;
    UIColor *spaceleft = [UIColor redColor];
    if ((totalBhytes/1000 > 500) && (totalBhytes/1000 < 2500)) {
        percentDone = .20;
    } else if ((totalBhytes/1000 > 2500) && (totalBhytes/1000 < 5000)) {
        percentDone = .40;
    } else if ((totalBhytes/1000 > 5000) && (totalBhytes/1000 < 7500)) {
        percentDone = .60;
    } else if ((totalBhytes/1000 > 7500) && (totalBhytes/1000 < 10000)) {
        percentDone = .80;
        spaceleft = [UIColor redColor];
    } else if ((totalBhytes/1000 > 10000)) {
        spaceleft = [UIColor redColor];
        percentDone = 1;
    }
    
    NSLog(@"percentDone: %f",percentDone);
    
    CGRect rect = CGRectMake(20, 733, uitv_sharedList.bounds.size.width, 5);
    
    upperRect.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width * percentDone, rect.size.height );
    
    lowerRect.frame = CGRectMake(rect.origin.x + (rect.size.width * percentDone), rect.origin.y, rect.size.width*(1-percentDone), rect.size.height );
    lowerRect.alpha = 0.7;
    upperRect.alpha = 0.7;
    
    [upperRect setBackgroundColor:spaceleft];
    [lowerRect setBackgroundColor:[UIColor whiteColor]];
    
    [self.view insertSubview:upperRect atIndex:1];
    [self.view insertSubview:lowerRect atIndex:1];
    
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
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 1.0;
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
    
    webLinkBody = [NSString stringWithFormat:@"Thank you for your interest in Ballston Quarter."];
    
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
        emailData.subject = @"Greetings from Ballston Quarter";
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
