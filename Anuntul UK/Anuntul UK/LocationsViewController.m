//
//  LocationsViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 16/02/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "LocationsViewController.h"
#import "MenuTableViewController.h"
#import "WebServiceManager.h"
#import "MenuTableViewCell.h"
#import "UIColor+CustomColor.h"
#import "HexColors.h"
#import "WebServiceManager.h"
#import "MBProgressHUD.h"
#import "HomeViewController.h"
#import "LocationAdsViewController.h"

@interface LocationsViewController()<UITableViewDataSource, UITableViewDelegate> {
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *allLocations;

@end

@implementation LocationsViewController

- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 15) ];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem1 = [[UIBarButtonItem alloc]
                                           initWithCustomView:backButton];
    [leftBarButtonItem1 setTintColor:[UIColor blackColor]];
    
    //set the action for button
    
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem1;
    self.navigationController.navigationBarHidden = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.allLocations = [NSMutableArray arrayWithArray:[[WebServiceManager sharedInstance] listOfLocations]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //    CATransition* transition = [CATransition animation];
    //    transition.duration = 0.5;
    //    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    //    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    //    MenuTableViewController *menuTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewControllerIdentifier"];
    //    [self.navigationController pushViewController:menuTableViewController animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, tableView.frame.size.width, 25)];
    //    [label setFont:[UIFont boldSystemFontOfSize:12]];
    NSDictionary *countryLocation = [self.allLocations objectAtIndex:section];
    NSString *string = [countryLocation objectForKey:@"titlu"];
    /* Section header is in 0th index... */
    [label setText:string];
    //    [label setTextColor:[UIColor colorFromHexString:@"c1c1c1"]];
    [label setTextColor:[HXColor hx_colorWithHexString:@"c1c1c1"]];
    [view addSubview:label];
    //    [view setBackgroundColor:[UIColor colorFromHexString:@"f1eef1"]];
    [view setBackgroundColor:[HXColor hx_colorWithHexString:@"f1eef1"]];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allLocations.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.allLocations objectAtIndex:section] objectForKey:@"locations"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCellIdentifier"];
    if (!cell) {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuTableViewCellIdentifier"];
    }
    NSDictionary *countryLocation = [self.allLocations objectAtIndex:indexPath.section];
    NSArray *locations = [countryLocation objectForKey:@"locations"];
    NSDictionary *location = [locations objectAtIndex:indexPath.row];
    cell.titleLabel.text = location[@"titlu"];
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *countryLocation = [self.allLocations objectAtIndex:indexPath.section];
    NSArray *locations = [countryLocation objectForKey:@"locations"];
    NSDictionary *location = [locations objectAtIndex:indexPath.row];
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
//    [[WebServiceManager sharedInstance] getAllAdsFromLocation:location[@"id"] withPageNumber:[NSNumber numberWithInteger:1] withCompletionBlock:^(NSArray *array, NSError *error) {
    [[WebServiceManager sharedInstance] getSearchResultsWithKeyWord:@"" andLocation:[NSString stringWithFormat:@"%@",location[@"id"]] andCategory:@"" andPageNumber:[NSNumber numberWithInteger:1] withCompletionBlock:^(NSArray *array, NSError *error) {

        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!error) {
            LocationAdsViewController *locationAdsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationAdsViewControllerIdentifier"];
            locationAdsViewController.locationAds = [NSMutableArray arrayWithArray:array];
            locationAdsViewController.locationId = location[@"id"];
            locationAdsViewController.locationTitle = location[@"titlu"];
            locationAdsViewController.isLocations = YES;
            locationAdsViewController.isMyProfile = NO;
            [self.navigationController pushViewController:locationAdsViewController animated:YES];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
    
}

@end
