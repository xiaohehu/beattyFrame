//
//  embLoginViewController.m
//  rxrnorthhills
//
//  Created by Evan Buxton on 7/13/14.
//  Copyright (c) 2014 neoscape. All rights reserved.
//

#import "TipsViewController.h"
#import "ContainerViewController.h"

#define kPasscodeLength 4
#define kPasscode		2580

@interface TipsViewController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning,UIGestureRecognizerDelegate>
{
	NSMutableArray			* arr_passCodeDigits;
	UITextField				* uitf_passcode;
}

@property (strong, nonatomic)			UIView						*uiv_PasscodeContainer;
@property (weak, nonatomic) IBOutlet	UIView						*uiv_numPad;

@end

@implementation TipsViewController

#pragma mark - custom modal presentation
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
    return self;
}


#pragma mark - view init
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// array of digits tapped
	arr_passCodeDigits	= [[NSMutableArray alloc] init];

	// init keypad
	[self loadKeypad];
	
	// gesture which dismisses if bg touched
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
	gestureRecognizer.cancelsTouchesInView = NO;
	gestureRecognizer.delegate = self;
	[self.view addGestureRecognizer:gestureRecognizer];
}

#pragma mark - KEYPAD
-(void)loadKeypad
{
	if (_uiv_numPad) {
		[self unloadLogin];
	}
	
	// create uiview container
	CGRect VIEWRECT = CGRectMake(10, 10, 346, 524);
//	_uiv_PasscodeContainer = [[UIView alloc] initWithFrame:VIEWRECT];
//	[_uiv_PasscodeContainer setBackgroundColor:[UIColor colorWithRed:187.f/255.f green:187.f/255.f blue:187.f/255.f alpha:1.0]];
//    CGPoint center = [self.uiv_numPad convertPoint:self.uiv_numPad.center fromView: self.uiv_numPad.superview];
//	_uiv_PasscodeContainer.center = center;
//	[self.uiv_numPad addSubview:_uiv_PasscodeContainer];
//	
//	// add text field
//	CGRect PASSRECT = CGRectMake(0, 0, 366, 544);
//	uitf_passcode = [[UITextField alloc] initWithFrame:PASSRECT];
//	uitf_passcode.font = [UIFont fontWithName:@"Helvetica-Bold" size:60];
//	uitf_passcode.delegate = self;
//	[uitf_passcode setBackgroundColor:[UIColor darkGrayColor]];
//	[uitf_passcode setTextAlignment:NSTextAlignmentCenter];
//	[_uiv_PasscodeContainer addSubview:uitf_passcode];
	
	// add numberpad
	//CGRect NUMRECT = CGRectMake(0, 50, 244, 324);
    
   // CGRect VIEWRECT = CGRectMake(0, 0, 366, 544);
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"tutorial" bundle:nil];
    [sb instantiateInitialViewController];
    UINavigationController *vc = [sb instantiateViewControllerWithIdentifier:@"NavController"];
    
    vc.view.frame = VIEWRECT;
    vc.view.clipsToBounds=YES;
    [self.uiv_numPad addSubview:vc.view];
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];

    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"tutorial" bundle:nil];
//    [sb instantiateInitialViewController];
//    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"TutorialsListController"];
//    vc.view.frame = VIEWRECT;
//    [_uiv_PasscodeContainer addSubview:vc.view];
//    _uiv_PasscodeContainer.clipsToBounds = YES;
    
    //vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
   //[self presentViewController:vc animated:YES completion:NULL];
    
//    ContainerViewController *vc = [[ContainerViewController alloc] init];
//    vc.view.frame = NUMRECT;
//    [_uiv_PasscodeContainer addSubview:vc.view];
    
//	embNumPad *numPad =[[embNumPad alloc]initWithFrame:NUMRECT];
//	[numPad numberPadSetUp:12];
//	numPad.delegate = self;
//	[_uiv_PasscodeContainer addSubview:numPad];
	
	// add submit button
//	CGRect SUBRECT = CGRectMake(0, 445-70, 244, 70);
//	UIButton*submit = [UIButton buttonWithType:UIButtonTypeSystem];
//	submit.frame = SUBRECT;
//	[submit setTitle:@"SUBMIT" forState:UIControlStateNormal];
//	[submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//	[submit addTarget:self action:@selector(checkPasscode) forControlEvents:UIControlEventTouchUpInside];
//	[submit setBackgroundColor:[UIColor darkGrayColor]];
//	[_uiv_PasscodeContainer addSubview:submit];
}

#pragma mark embNumPad Delegate
- (void)numberButtonAction:(UIButton *)numberButton
{
	if ([arr_passCodeDigits count] == kPasscodeLength) {
		return;
	}
		
	//NSLog(@"The button title is %@",numberButton.titleLabel.text);
	NSString *errorTag = uitf_passcode.text;
	NSString *errorString = numberButton.titleLabel.text;
	[arr_passCodeDigits addObject:errorString];
	//NSLog(@"passCodeDigits %@",arr_passCodeDigits);
	
	for (int i= 0; i <[arr_passCodeDigits count]; i++) {
		uitf_passcode.text = [errorTag stringByAppendingString:@"•"];
	}
}

- (void)functionButtonAction:(UIButton *)functionButton
{
	if (functionButton.tag==10) { // CLEAR
		if (arr_passCodeDigits.count != 0) {
			[arr_passCodeDigits removeAllObjects];
			NSString *str = uitf_passcode.text;
			NSString *truncatedString = [str substringToIndex:[str length]-[str length]];
			uitf_passcode.text = truncatedString;
			NSLog(@"Clear");
		}
	} else { // BACKSPACE
		if (arr_passCodeDigits.count != 0) {
			[arr_passCodeDigits removeLastObject];
			NSString *str = uitf_passcode.text;
			NSString *truncatedString = [str substringToIndex:[str length]-1];
			uitf_passcode.text = truncatedString;
			NSLog(@"passCodeDigits %@",arr_passCodeDigits);
		}
	}
}

#pragma mark Passcode
-(void)checkPasscode
{
	if ([arr_passCodeDigits count]==4) {
		
		int myVal = [[NSString stringWithFormat:@"%@%@%@%@",arr_passCodeDigits[0], arr_passCodeDigits[1], arr_passCodeDigits[2],arr_passCodeDigits[3]] intValue];
		
		if (myVal == kPasscode) {
			NSLog(@"MATCH!");
			
			[UIView animateWithDuration:0.5 animations:^{
				self.uiv_numPad.center = CGPointMake(512, -500);
			}completion:^(BOOL completion){
				[self unloadLogin];
			}];
			
			[self doDismiss:nil];
			
		} else {
			NSLog(@"NO Match");
			
			uitf_passcode.text = @"";
			[arr_passCodeDigits removeAllObjects];
			
			[self shakeView];
		}
	} else {
		
		[self shakeView];

	}
}

-(void)shakeView
{
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	animation.duration = 0.6;
	animation.values = @[ @(-20), @(20), @(-20), @(20), @(-10), @(10), @(-5), @(5), @(0) ];
	[self.view.layer addAnimation:animation forKey:@"shake"];
}

#pragma mark - dismiss vc
// dismiss the modal view from bg tap
- (IBAction)doDismiss: (id) sender {
	[self.presentingViewController dismissViewControllerAnimated:NO completion:^{
		NSLog(@"Dismiss completed");
		//[self loginWasSuccessful:YES];
	}];
}

-(void)dismissView
{
	[self.presentingViewController dismissViewControllerAnimated:YES completion:^{
		NSLog(@"dismissView");
	}];
}

// gesture to dimiss is ignored when buttons are tapped
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint aPoint = touch.view.center;
    BOOL isPointInsideView = ![_uiv_numPad pointInside:aPoint withEvent:nil];
    return isPointInsideView;
}

#pragma mark - delegates
#pragma mark message of success
-(void)loginWasSuccessful:(BOOL)success
{
	if ([self.delegate respondsToSelector:@selector(embLoginSuccess:)])
		[self.delegate embLoginSuccess:success];
}

#pragma mark numpad text field
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

#pragma mark - cleanup
-(void)unloadLogin
{
	[_uiv_PasscodeContainer removeFromSuperview];
	_uiv_PasscodeContainer=nil;
	[arr_passCodeDigits removeAllObjects];
}

#pragma mark - boiler
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom modal presentation methods
// ==========

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

// ========

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* vc1 = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* vc2 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* con = [transitionContext containerView];
    UIView* v1 = vc1.view;
    UIView* v2 = vc2.view;
    
    if (vc2 == self) { // presenting
        [con addSubview:v2];
        v2.frame = v1.frame;
		
		// Set the parameters to be passed into the animation
		CGFloat duration = 0.8f;
		CGFloat damping = 0.75;
		CGFloat velocity = 0.5;
		
		// int to hold UIViewAnimationOption
		NSInteger option;
		option = UIViewAnimationCurveEaseInOut;
		
		self.uiv_numPad.center = CGPointMake(512, -500);
		
        v2.alpha = 0;
        v1.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
		
		[UIView animateWithDuration:duration delay:0 usingSpringWithDamping:damping initialSpringVelocity:velocity options:option animations:^{
			v2.alpha = 1;
			v1.alpha = 0.8;
			CGPoint center = [self.view convertPoint:self.view.center fromView: self.view.superview];
			self.uiv_numPad.center = center;
		}completion:^(BOOL finished) {
		 
		 [transitionContext completeTransition:YES];

		}];

    } else { // dismissing
        [UIView animateWithDuration:0.25 animations:^{
			self.uiv_numPad.center = CGPointMake(512, -500);
            v1.alpha = 0;
			v2.alpha=1.0;
        } completion:^(BOOL finished) {
            v2.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
