//
//  ParkingTableViewController.m
//  beattyFrame
//
//  Created by Evan Buxton on 5/12/16.
//  Copyright © 2016 Xiaohe Hu. All rights reserved.
//

#import "ParkingTableViewController.h"
#import "xhWebViewController.h"
#import "AppDelegate.h"
#import "UIColor+Extensions.h"

@interface ParkingTableViewController ()
@property (nonatomic, retain) AppDelegate                   *appDelegate;
@end

@implementation ParkingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView headerViewForSection:0].textLabel.text = @"NOT ONLINE";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(0, 0, 320, 30);
    [label1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor whiteColor];
    label1.backgroundColor = [UIColor clearColor];
    
    if ([_appDelegate.isWirelessAvailable isEqualToString:@"NO"]) {
        label1.text =@"You appear to be offline";
        self.tableView.userInteractionEnabled = NO;
    } else {
        label1.text =@"Live Data from premiumparking.com";
    }

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [view addSubview:label1];
    view.backgroundColor = [UIColor themeRed];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *web = @[@"https://www.premiumparking.com/P2305",
                     @"https://www.premiumparking.com/P2306",
                     @"https://www.premiumparking.com/P2307",
                     ];
    switch (indexPath.row) {
        case 3:
            [self openWeb:web[0]];
            break;
        case 4:
            [self openWeb:web[1]];
            break;
        case 5:
            [self openWeb:web[2]];
            break;

        default:
            break;
    }
}

-(void)openWeb:(NSString*)webaddress
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    xhWebViewController *vc = (xhWebViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"xhWebViewController"];
    [vc socialButton:webaddress];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}



@end
