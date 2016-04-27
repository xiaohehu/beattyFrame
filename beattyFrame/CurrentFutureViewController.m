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

@interface CurrentFutureViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    int                 tenantTypeIndex;
    NSArray             *tenantData;
    IBOutlet UICollectionView    *collectionview;
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
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    [self createSummaryContent];
    
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
    
    NSString *textPath = [[NSBundle mainBundle] pathForResource:@"tenants" ofType:@"json"];
    
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:textPath encoding:NSUTF8StringEncoding error:&error];  //error checking omitted
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *maps = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString*tenantType;
    if (tenantTypeIndex == 0) {
        tenantType = @"office";
    } else {
        tenantType = @"retail";
    }
    tenantData = maps[tenantType];
}

- (void)createSummaryContent {
    UIImageView *uiiv_Summary = [UIImageView new];
    UIImage *summary = [UIImage imageNamed:@"grfx-partners-tenants.png"];
    [uiiv_Summary setImage: summary];
    uiiv_Summary.frame = self.view.bounds;
    [self.view insertSubview: uiiv_Summary atIndex:0];
}

- (IBAction)tapCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^(void){
    }];
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
    cell.desc.text = tempDic[@"desc"];
    cell.logo.image = [UIImage imageNamed:tempDic[@"logo"]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(310, 220);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
