//
//  SummaryViewController.m
//  beattyFrame
//
//  Created by Xiaohe Hu on 7/21/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

#import "CurrentFutureViewController.h"
#import "UIColor+Extensions.h"
#import "CardCollectionCell.h"

static CGFloat  bottomMenuHeight = 37;

@interface CurrentFutureViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    int                 tenantTypeIndex;
    NSArray             *tenantData;
    IBOutlet UICollectionView    *collectionview;
    NSDictionary *tenantDict;
    UIView *uiv_bottomMenu;
    UIView *uiv_bottomHighlightView;
    NSMutableArray *arr_menuButton;
}

@end

@implementation CurrentFutureViewController

#pragma mark - View controller life-cycle
-(void)viewWillAppear:(BOOL)animated
{
    [collectionview registerNib:[UINib nibWithNibName:@"CardCollectionCell" bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:@"CardCollectionCell"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *uib_sectionTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_sectionTitle.backgroundColor = [UIColor themeRed];
    [uib_sectionTitle setTitle:@"Current & Future Tenants" forState:UIControlStateNormal];
    [uib_sectionTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uib_sectionTitle.titleLabel setFont:[UIFont fontWithName:@"GoodPro-Book" size:25.0]];
    [uib_sectionTitle sizeToFit];
    uib_sectionTitle.userInteractionEnabled = NO;
    CGRect frame = uib_sectionTitle.frame;
    frame.size.width += 38;
    uib_sectionTitle.frame = frame;
    [self.view addSubview:uib_sectionTitle];
    
    // data
    NSString *textPath = [[NSBundle mainBundle] pathForResource:@"tenants" ofType:@"json"];
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:textPath encoding:NSUTF8StringEncoding error:&error];  //error checking omitted
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    tenantDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    [self setTenantTypeData:@"office"];
    
    [self createBottomMenu];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];

}

-(void)setTenantTypeData:(NSString*)keyname
{
    tenantData = nil;
    tenantData = tenantDict[keyname];
    [collectionview reloadData];
}

- (IBAction)tapCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^(void){
    }];
}

- (IBAction)tapDisplayType:(id)sender {
    
    NSString*tenantType;
    if ([sender tag] == 0) {
        tenantType = @"office";
    } else {
        tenantType = @"retail";
    }
    
    [self setTenantTypeData:tenantType];
}

#pragma mark - Collection View
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return tenantData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CardCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CardCollectionCell" forIndexPath:indexPath];
    NSDictionary *tempDic = [[NSDictionary alloc] initWithDictionary:[tenantData objectAtIndex:indexPath.row]];
    cell.name.text = tempDic[@"name"];
    cell.logo.image = [UIImage imageNamed:tempDic[@"logo"]];
    cell.desc.text = tempDic[@"desc"];
    [cell.desc setFont:[UIFont systemFontOfSize:13]];
    cell.desc.textColor = [UIColor themeTextGray];
    cell.desc.textContainerInset = UIEdgeInsetsMake(0, 0, 5, 0);
    cell.desc.textContainer.lineFragmentPadding = 0;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(310, 220);
}

-(void)createBottomMenu
{
    arr_menuButton = [NSMutableArray new];

    uiv_bottomMenu = [[UIView alloc] initWithFrame:CGRectZero];
    uiv_bottomMenu.clipsToBounds = YES;
    uiv_bottomMenu.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: uiv_bottomMenu];
    
    uiv_bottomHighlightView = [[UIView alloc] initWithFrame:CGRectZero];
    uiv_bottomHighlightView.backgroundColor = [UIColor themeRed];
    [uiv_bottomMenu addSubview: uiv_bottomHighlightView];
    
    CGFloat totalWidth = 0;
    
    NSArray *arr_menuTitles = @[
                                @"Office",
                                @"Retail",
                                ];
    
    for (int i = 0 ; i < arr_menuTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:arr_menuTitles[i] forState:UIControlStateNormal];
        [button sizeToFit];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont fontWithName:@"GoodPro-Book" size:15.0]];
        button.backgroundColor = [UIColor whiteColor];
        CGRect frame = button.frame;
        frame.size.width += 19;
        totalWidth = totalWidth + frame.size.width;
        
        frame.size.height = bottomMenuHeight;
        button.frame = frame;
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
        button.tag = i;
        [button addTarget:self action:@selector(tapBottomButton:) forControlEvents:UIControlEventTouchUpInside];
        [arr_menuButton addObject: button];
    }
    
    for (int i = 0; i < arr_menuButton.count; i++) {
        UIButton *uib_cur = arr_menuButton[i];
        if (i > 0) {
            UIButton *uib_pre = arr_menuButton[i-1];
            CGRect frame = uib_cur.frame;
            frame.origin.x = uib_pre.frame.origin.x + uib_pre.frame.size.width;
            uib_cur.frame = frame;
        }
        [uiv_bottomMenu addSubview: uib_cur];
        
    }
    uiv_bottomMenu.frame = CGRectMake((self.view.bounds.size.width - totalWidth)/2, 22 + bottomMenuHeight, totalWidth, bottomMenuHeight);
    
    [self highlightButton:arr_menuButton[0]];
}

- (void)highlightButton:(id)sender {
    UIButton *tappedButton = sender;
    for (UIButton *btn in arr_menuButton) {
        btn.selected = NO;
        btn.backgroundColor = [UIColor clearColor];
    }
    tappedButton.selected = YES;
    uiv_bottomHighlightView.backgroundColor = [UIColor themeRed];
    [UIView animateWithDuration:0.33 animations:^(void){
        uiv_bottomHighlightView.frame = tappedButton.frame;
    }];
}

-(void)tapBottomButton:(id)sender
{
    [self highlightButton:sender];
    [self tapDisplayType:sender];
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self setTenantTypeData:@"office"];
        [self highlightButton:arr_menuButton[0]];
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self setTenantTypeData:@"retail"];
        [self highlightButton:arr_menuButton[1]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
