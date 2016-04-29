//
//  embTutorialsListController.m
//  embTutorialCard
//
//  Created by Evan Buxton on 9/1/15.
//  Copyright (c) 2015 Evan Buxton. All rights reserved.
//

#import "TutorialsListController.h"
#import "TutsTableCell.h"
#import "ContainerViewController.h"
#import "Tutorial.h"
#import "UIColor+Extensions.h"

@interface TutorialsListController ()
{
    NSIndexPath* row;
}

@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (strong, nonatomic) NSMutableArray *tutorials;
@property (strong, nonatomic) NSMutableArray *secData;

@end


@implementation TutorialsListController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)viewDidLoad
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor helpBlue]];
    
    self.tableView.frame = CGRectInset(self.view.frame, 100, 100);
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 40.0)];
    titleView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Tips";
    titleLabel.font = [UIFont fontWithName:@"GoodPro-Book" size:22.0];
    titleLabel.frame = CGRectMake(0, 7, 100, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [titleView addSubview:titleLabel];
    
    UIImageView *tileImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ui_tips_icon.png"]];
    tileImageView.frame = CGRectMake(10, 7, 17, 27);
    [titleView addSubview:tileImageView];
    
    self.navigationItem.titleView = titleView;
    
    NSString *textPath = [[NSBundle mainBundle] pathForResource:@"tutorials" ofType:@"json"];
    
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:textPath encoding:NSUTF8StringEncoding error:&error];  //error checking omitted
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];

    _tutorials = [[NSMutableArray alloc] init];
    
    NSArray *rawArray = [returnedDict objectForKey:@"helpsystem"];
    
    for (NSDictionary*dict in rawArray) {
        [_tutorials addObject:dict];
    }
}

#pragma mark - Table view
#pragma mark Delegates
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return _tutorials.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_tutorials[section] objectForKey:@"sectionTitle"];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 0, 304, 25);
    myLabel.font = [UIFont fontWithName:@"GoodPro-Book" size:14];
    myLabel.text = [[self tableView:tableView titleForHeaderInSection:section] uppercaseString];
    [myLabel setTextColor:[UIColor whiteColor]];
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor helpSectionHeaderBlue]];
    [headerView addSubview:myLabel];
    
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[_tutorials[section] objectForKey:@"tutorials"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TutsTableCell";
    
    TutsTableCell *cell = (TutsTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TutsTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.nameLabel.font = [UIFont fontWithName:@"GoodPro-Book" size:18];
    cell.nameLabel.text = [_tutorials[indexPath.section] objectForKey:@"tutorials"][indexPath.row][@"Title"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)ttableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //save indexPath
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger index = indexPath.section;
    [userDefaults setInteger:index forKey:@"saverows"];
    [userDefaults synchronize];
    
    TutsTableCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@", cell.nameLabel.text);
    [self performSegueWithIdentifier:@"DetailSegue" sender:cell];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DetailSegue"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        ContainerViewController *detailVC = [segue destinationViewController];
        detailVC.indexPath = indexPath;
        [detailVC loadPage:(int)indexPath.row];
        
        _secData = [[NSMutableArray alloc] init];
        [_secData addObject:[_tutorials[indexPath.section] objectForKey:@"tutorials"][indexPath.row]];
        detailVC.data = _secData;
        
        NSLog(@"_secData %@", _secData);

        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 150, 40.0)];
        titleView.backgroundColor = [UIColor clearColor];
        
        // Get the value of cell.textlabel.text
        //TutsTableCell *cell = (TutsTableCell *)sender;
        // NSString *text = cell.nameLabel.text;
        
        NSString *text = [_tutorials[indexPath.section] objectForKey:@"sectionTitle"];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = text;
        titleLabel.font = [UIFont fontWithName:@"GoodPro-Book" size:22.0];
        titleLabel.frame = CGRectMake(0, 7, 125, 30);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        [titleView addSubview:titleLabel];
        [titleLabel sizeToFit];
        [titleLabel setCenter:CGPointMake(titleView.frame.size.width / 2, titleView.frame.size.height / 2)];
        
        detailVC.navigationItem.titleView = titleView;
    }
}

@end
