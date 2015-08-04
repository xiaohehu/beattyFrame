//
//  ViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 7/20/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "ViewController.h"
#import "SummaryViewController.h"
#import "Site360ViewController.h"
#import "GalleryViewController.h"
#import "SupportingViewController.h"
#import "embEmailData.h"
#import "UIColor+Extensions.h"
#import "LocationViewController.h"
#import "BuildingViewController.h"

static float    sideMenuWidth = 235.0;
static float    menuButtonSize = 50.0;

@import MessageUI;

@interface ViewController () <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>{

    SummaryViewController   *summary;
    BuildingViewController  *buildingVC;
    IBOutlet UIView         *uiv_vcBigContainer;
    IBOutlet UIView         *uiv_sideMenuContainer;
    IBOutlet UIView         *uiv_vcCover;
    UIButton                *uib_menuButton;
    UIViewController        *currentViewController;
    
    // Side menu content button
    __weak IBOutlet UIView *uiv_buutonHighlight;
    // Button containers
    __weak IBOutlet UIView *uiv_harbor;
    __weak IBOutlet UIView *uiv_location;
    __weak IBOutlet UIView *uiv_supporting;
    __weak IBOutlet UIView *uiv_sponsorship;
    
    // Harbor Point
    __weak IBOutlet UIButton *uib_site360;
    __weak IBOutlet UIButton *uib_summary;
    __weak IBOutlet UIButton *uib_masterPlan;
    __weak IBOutlet UIButton *uib_development;
    
    // Location & Access
    __weak IBOutlet UIButton *uib_location;
    
    // Supporting Stories
    __weak IBOutlet UIButton *uib_history;
    __weak IBOutlet UIButton *uib_trends;
    __weak IBOutlet UIButton *uib_lifestyle;
    __weak IBOutlet UIButton *uib_factsFigures;
    __weak IBOutlet UIButton *uib_ecoDistrict;
    
    // Sponsorship
    __weak IBOutlet UIButton *uib_developGroup;
    __weak IBOutlet UIButton *uib_financial;
    __weak IBOutlet UIButton *uib_currentFutureTrends;
    
    NSArray                  *arr_sideMenuBttuons;
}

@property (nonatomic, strong)       embEmailData            *receivedData;

@end

@implementation ViewController
#pragma mark - View Controller Life-cycle
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSummary:) name:@"RemoveSummeary" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setEmailDataObject:) name:@"emailData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHighlightedButton:) name:@"updatedSupportingSideMenu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBuildingVC:) name:@"loadBuilding" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeBuildingVC:) name:@"removeBuilding" object:nil];
    [self prepareViewContainer];
    [self groupSideMenuButtons];
    
    //Init with Site 360 View controller
    Site360ViewController *site360 = [self.storyboard instantiateViewControllerWithIdentifier:@"Site360ViewController"];
    [self fadeInNewViewController:site360];
}

- (void)viewDidAppear:(BOOL)animated {
    [self highlightTheButton:uib_site360 withAnimation:NO];
    
//    NSArray *fontFamilies = [UIFont familyNames];
//    
//    for (int i = 0; i < [fontFamilies count]; i++)
//    {
//        NSString *fontFamily = [fontFamilies objectAtIndex:i];
//        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
//        NSLog (@"%@: %@", fontFamily, fontNames);
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create/Style UI elements

- (void)prepareViewContainer {
    
    uiv_vcBigContainer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:uiv_vcBigContainer];
    
    // UiView used to tap close side menu
    uiv_vcCover.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapCover = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMenuButtonClose:)];
    uiv_vcCover.userInteractionEnabled = YES;
    [uiv_vcCover addGestureRecognizer: tapCover];
    [self.view addSubview:uiv_vcCover];
    uiv_vcCover.alpha = 0.0;
    
    uiv_sideMenuContainer.backgroundColor = [UIColor whiteColor];
    uiv_sideMenuContainer.alpha = 1.0;
    [self.view insertSubview:uiv_sideMenuContainer aboveSubview:uiv_vcCover];
    uiv_sideMenuContainer.transform = CGAffineTransformMakeTranslation(sideMenuWidth, 0);
    
    // UIButton control open/close side menu
    uib_menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_menuButton.frame = CGRectMake(self.view.bounds.size.width - 14 - menuButtonSize, (self.view.bounds.size.height - menuButtonSize)/2, menuButtonSize, menuButtonSize);
    [uib_menuButton setImage:[UIImage imageNamed:@"grfx_menuOpen.png"] forState:UIControlStateNormal];
    [uib_menuButton addTarget:self action:@selector(tapMenuButtonOpen:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: uib_menuButton];
    
}

- (void)groupSideMenuButtons {
    arr_sideMenuBttuons = @[
                            uib_site360,
                            uib_summary,
                            uib_masterPlan,
                            uib_development,
                            uib_location,
                            uib_history,
                            uib_trends,
                            uib_lifestyle,
                            uib_factsFigures,
                            uib_ecoDistrict,
                            uib_developGroup,
                            uib_financial,
                            uib_currentFutureTrends
                            ];
}

#pragma mark - UI element interaction
#pragma mark Side menu control
/*
 * Scale down the current view
 * Open side menu
 */
- (void)tapMenuButtonOpen:(id)sender {
    
    uiv_vcBigContainer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    uiv_vcBigContainer.layer.borderWidth = 5.0;
    uiv_vcCover.alpha = 1.0;
    
    [UIView animateWithDuration:0.33 animations:^(void){
        uib_menuButton.transform = CGAffineTransformTranslate(uib_menuButton.transform, -sideMenuWidth+14+menuButtonSize/2, 0.0);
        uib_menuButton.transform = CGAffineTransformRotate(uib_menuButton.transform, M_PI_4);
        uiv_sideMenuContainer.transform = CGAffineTransformIdentity;
        
        uiv_vcBigContainer.transform = CGAffineTransformScale(uiv_vcBigContainer.transform, 0.77, 0.77);
        uiv_vcBigContainer.transform = CGAffineTransformTranslate(uiv_vcBigContainer.transform, -1024*0.149, 0.0);
        
    } completion:^(BOOL finished){
        [uib_menuButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [uib_menuButton addTarget:self action:@selector(tapMenuButtonClose:) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:uiv_sideMenuContainer aboveSubview:uiv_vcCover];
    }];
}

/*
 * Close side menu
 * Make current view full screen
 */
- (void)tapMenuButtonClose:(id)sender {
    
    uiv_vcBigContainer.layer.borderWidth = 0.0;
    
    [UIView animateWithDuration:0.33 animations:^(void){
        uib_menuButton.transform = CGAffineTransformIdentity;
        uiv_vcBigContainer.transform = CGAffineTransformIdentity;
        uiv_sideMenuContainer.transform = CGAffineTransformMakeTranslation(sideMenuWidth, 0.0);
    } completion:^(BOOL finshied){
        [uib_menuButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [uib_menuButton addTarget:self action:@selector(tapMenuButtonOpen:) forControlEvents:UIControlEventTouchUpInside];
        uiv_vcCover.alpha = 0.0;
    }];
}

#pragma mark Highlight selected side menu buttons
/*
 * High light the button selected on side menu w/o animation
 * "Summary" & "Master Plan" no need to be highlighted
 */
- (void)highlightTheButton:(UIButton *)theButton withAnimation:(BOOL)animation{
    for (UIButton *btn in arr_sideMenuBttuons) {
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    /*
     * Get the selected button's frame to move the highlight view
     */
    CGRect frame = [theButton.superview convertRect:theButton.frame toView:uiv_sideMenuContainer];
    frame.origin.x -= 3;
    frame.size.width += 6;
    uiv_buutonHighlight.backgroundColor = [UIColor themeRed];
    if (animation) {
        [UIView animateWithDuration:0.33 animations:^(void){
            uiv_buutonHighlight.frame = frame;
        } completion:^(BOOL finished){
            [theButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }];
    } else {
        uiv_buutonHighlight.frame = frame;
        [theButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

/*
 * Highlight side menu's button by receiving notification from page view controller
 */
- (void)updateHighlightedButton:(NSNotification *)notification {
    int buttonTag = [[notification.userInfo objectForKey:@"index"] integerValue]+20;
    for (UIButton *button in arr_sideMenuBttuons) {
        if (button.tag == buttonTag) {
            [self highlightTheButton:button withAnimation:NO];
            return;
        }
    }
}

#pragma mark Load/Remove view controller

- (void)loadBuildingVC:(NSNotification *)notification {
    buildingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BuildingViewController"];
    buildingVC.view.frame = self.view.bounds;
    buildingVC.view.transform = CGAffineTransformMakeTranslation(0, buildingVC.view.frame.size.height);
    [self addChildViewController:buildingVC];
    [uiv_vcBigContainer insertSubview:buildingVC.view aboveSubview:currentViewController.view];
    [UIView animateWithDuration:0.33 animations:^(void){
        buildingVC.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        currentViewController = buildingVC;
    }];
}

- (void)removeBuildingVC:(NSNotification *)notification {
    [UIView animateWithDuration:0.33 animations:^(void){
        buildingVC.view.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
    } completion:^(BOOL finished){
        [buildingVC removeFromParentViewController];
        [buildingVC.view removeFromSuperview];
        buildingVC = nil;
        buildingVC.view = nil;
    }];
}

- (IBAction)tapSideMenuButton:(id)sender {
    UIButton *tappedButton = sender;
    [self highlightTheButton:tappedButton withAnimation:YES];
    [self performSelector:@selector(tapMenuButtonClose:) withObject:nil afterDelay:0.33];
}

- (IBAction)loadSite360:(id)sender {
    UIButton *tappedButton = sender;
    [self highlightTheButton:tappedButton withAnimation:YES];
    Site360ViewController *site360 = [self.storyboard instantiateViewControllerWithIdentifier:@"Site360ViewController"];
    [self fadeInNewViewController:site360];
    [self performSelector:@selector(tapMenuButtonClose:) withObject:nil afterDelay:0.33];
}
- (IBAction)loadOpportunities:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                      message:@"The content is coming soon"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];

}

/*
 * Load Supporting page view controller
 * Accroding to selected button's tag load correct page
 */
- (IBAction)loadSupporting:(id)sender {
    
    UIButton *tappedButton = sender;
    [self highlightTheButton:tappedButton withAnimation:YES];
    SupportingViewController *supporting = [self.storyboard instantiateViewControllerWithIdentifier:@"SupportingViewController"];
    supporting.pageIndex = tappedButton.tag%10;
    [self fadeInNewViewController:supporting];
    [self performSelector:@selector(tapMenuButtonClose:) withObject:nil afterDelay:0.33];
}

- (IBAction)loadLoaction:(id)sender {
    UIButton *tappedButton = sender;
    [self highlightTheButton:tappedButton withAnimation:YES];
    LocationViewController *location = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationViewController"];;
    [self fadeInNewViewController:location];
    [self performSelector:@selector(tapMenuButtonClose:) withObject:nil afterDelay:0.33];
}

- (void)fadeInNewViewController:(UIViewController *)viewController {
    viewController.view.frame = self.view.bounds;
    [self addChildViewController:viewController];
    viewController.view.alpha = 0.0;
    [uiv_vcBigContainer addSubview: viewController.view];
    /*
     * Check current view controller
     * Do the fade out/in animation
     */
    if (currentViewController != nil) {
        [UIView animateWithDuration:0.33 animations:^(void){
            currentViewController.view.alpha = 0.0;
            viewController.view.alpha = 1.0;
        } completion:^(BOOL finished){
            [currentViewController.view removeFromSuperview];
            [currentViewController removeFromParentViewController];
            currentViewController = nil;
            currentViewController = viewController;
        }];
    } else {
        [UIView animateWithDuration:0.33 animations:^(void){
            viewController.view.alpha = 1.0;
        } completion:^(BOOL finished){
            currentViewController = viewController;
        }];
    }
}

/*
 * Pop up Summary/Master_Plan view controller
 * Accroding to selected button's tag to set the initial loaded view
 */
- (IBAction)loadSummary:(id)sender {
    
    [self tapMenuButtonClose:nil];
    summary = [[SummaryViewController alloc] init];
    summary.view.frame = self.view.bounds;
    if ([sender tag]%2 != 0) {
        summary.preloadSitePlan = YES;
    }
    summary.loadWithAnimation = YES;
    [self addChildViewController: summary];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.33 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.view addSubview: summary.view];
    });
}

/*
 * Remove Summary/Master_Plan view controller by recveiving the NSNotification
 */
- (void)removeSummary:(NSNotification *)notification {
    [summary.view removeFromSuperview];
    summary.view = nil;
    [summary removeFromParentViewController];
    summary = nil;
}

#pragma mark - Mail Sending
-(void)setEmailDataObject:(NSNotification *)pNotification
{
    NSLog(@"#1 received message = %@",(embEmailData*)[pNotification object]);
    _receivedData = (embEmailData*)[pNotification object];
    //NSLog(@"_receivedData %@",_receivedData.attachment);
    
    [self emailData];
}

#pragma mark - Email Delegates
-(void)emailData
{
    if ([MFMailComposeViewController canSendMail] == YES) {
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self; // &lt;- very important step if you want feedbacks on what the user did with your email sheet
        
        if(_receivedData.to)
            [picker setToRecipients:_receivedData.to];
        
        if(_receivedData.cc)
            [picker setCcRecipients:_receivedData.cc];
        
        if(_receivedData.bcc)
            [picker setBccRecipients:_receivedData.bcc];
        
        if(_receivedData.subject)
            [picker setSubject:_receivedData.subject];
        
        if(_receivedData.body)
            [picker setMessageBody:_receivedData.body isHTML:YES]; // depends. Mostly YES, unless you want to send it as plain text (boring)
        
        // attachment code
        if(_receivedData.attachment) {
            
            NSString	*filePath;
            NSString	*justFileName;
            NSData		*myData;
            UIImage		*pngImage;
            NSString	*newname;
            
            for (id file in _receivedData.attachment)
            {
                // check if it is a uiimage and handle
                if ([file isKindOfClass:[UIImage class]]) {
                    
                    myData = UIImagePNGRepresentation(file);
                    [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"image.png"];
                    
                    // might be nsdata for pdf
                } else if ([file isKindOfClass:[NSData class]]) {
                    NSLog(@"pdf");
                    myData = [NSData dataWithData:file];
                    NSString *mimeType;
                    mimeType = @"application/pdf";
                    newname = @"Brochure.pdf";
                    [picker addAttachmentData:myData mimeType:mimeType fileName:newname];
                    
                    // it must be another file type?
                } else {
                    
                    justFileName = [[file lastPathComponent] stringByDeletingPathExtension];
                    
                    NSString *mimeType;
                    // Determine the MIME type
                    if ([[file pathExtension] isEqualToString:@"jpg"]) {
                        mimeType = @"image/jpeg";
                    } else if ([[file pathExtension] isEqualToString:@"png"]) {
                        mimeType = @"image/png";
                        pngImage = [UIImage imageNamed:file];
                    } else if ([[file pathExtension] isEqualToString:@"doc"]) {
                        mimeType = @"application/msword";
                    } else if ([[file pathExtension] isEqualToString:@"ppt"]) {
                        mimeType = @"application/vnd.ms-powerpoint";
                    } else if ([[file pathExtension] isEqualToString:@"html"]) {
                        mimeType = @"text/html";
                    } else if ([[file pathExtension] isEqualToString:@"pdf"]) {
                        mimeType = @"application/pdf";
                    } else if ([[file pathExtension] isEqualToString:@"com"]) {
                        mimeType = @"text/plain";
                    }
                    
                    filePath= [[NSBundle mainBundle] pathForResource:justFileName ofType:[file pathExtension]];
                    
                    if (![[file pathExtension] isEqualToString:@"png"]) {
                        myData = [NSData dataWithContentsOfFile:filePath];
                        myData = [NSData dataWithContentsOfFile:filePath];
                    } else {
                        myData = UIImagePNGRepresentation(pngImage);
                    }
                    
                    newname = file;
                    [picker addAttachmentData:myData mimeType:mimeType fileName:newname];
                }
            }
        }
        
        picker.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.
        [self presentViewController:picker animated:YES completion:nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status" message:[NSString stringWithFormat:@"Email needs to be configured before this device can send email. \n\n Use support@neoscape.com on a device capable of sending email."]
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank you!" message:@"Email Sent Successfully"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
            break;
        case MFMailComposeResultFailed:
            break;
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status" message:@"Sending Failed - Unknown Error"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSLog(@"FINISHED");
}



@end
