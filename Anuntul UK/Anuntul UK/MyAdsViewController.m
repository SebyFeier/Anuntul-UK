//
//  MyAdsViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 29/01/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "MyAdsViewController.h"
#import "CategoryTableViewCell.h"
#import "AdsDetailsViewController.h"
#import "MenuTableViewController.h"



@interface MyAdsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listOfAdsViewController;

@end

@implementation MyAdsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(promote:)];
//    self.navigationItem.rightBarButtonItem = barButtonItem;
    self.listOfAdsViewController.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.listOfAds = [[NSMutableArray alloc] initWithObjects:
                      [NSDictionary dictionaryWithObjectsAndKeys:@"adName1",@"name",@"category1",@"categoryName",@"29-01-2016",@"date",@"London",@"location",@"username1",@"username", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"adName2",@"name",@"category2",@"categoryName",@"29-01-2016",@"date",@"Manchester",@"location",@"username2",@"username", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"adName3",@"name",@"category2",@"categoryName",@"29-01-2016",@"date",@"London",@"location",@"username2",@"username", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"adName4",@"name",@"category2",@"categoryName",@"29-01-2016",@"date",@"London",@"location",@"username3",@"username", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"adName5",@"name",@"category2",@"categoryName",@"29-01-2016",@"date",@"London",@"location",@"username1",@"username", nil],
                      nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
}

- (IBAction)goToMainMenu:(id)sender {
//    [self performSegueWithIdentifier:@"unwindToMainMenu" sender:self];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    MenuTableViewController *menuTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewControllerIdentifier"];
    [self.navigationController pushViewController:menuTableViewController animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *ad = self.listOfAds[indexPath.row];
    AdsDetailsViewController *adsDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdsDetailsViewControllerIdentifier"];
    adsDetailsViewController.adDetails = ad;
    adsDetailsViewController.toPublish = NO;
    [self.navigationController pushViewController:adsDetailsViewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listOfAds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryTableViewCellIdentifier"];
    if (!cell) {
        cell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CategoryTableViewCellIdentifier"];
    }
    NSDictionary *ad = self.listOfAds[indexPath.row];
    [cell updateCellWithInfo:ad withMyProfile:NO andIndexpath:indexPath];
    return cell;
}

//- (void)userTappedWithInfo:(NSDictionary *)userInfo {
//    UserAdsViewController *userAdsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserAdsViewControllerIdentifier"];
//    userAdsViewController.listOfAds = self.listOfAds;
//    [self.navigationController pushViewController:userAdsViewController animated:YES];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
