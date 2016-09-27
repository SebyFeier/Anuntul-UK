//
//  CategoriesViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 29/01/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "CategoriesViewController.h"
#import "AdTableViewCell.h"
#import "ListOfAdsViewController.h"
#import "MenuTableViewController.h"

@interface CategoriesViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *categoriesTableView;

@end

@implementation CategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.categoriesTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.listOfCategories = [[NSMutableArray alloc] initWithObjects:
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
//    NSDictionary *ad = self.listOfCategories[indexPath.row];
    ListOfAdsViewController *listOfAdsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListOfAdsViewControllerIdentifier"];
    listOfAdsViewController.listOfAds = self.listOfCategories;
    listOfAdsViewController.isHome = NO;
    [self.navigationController pushViewController:listOfAdsViewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listOfCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdTableViewCellIdentifier"];
    if (!cell) {
        cell = [[AdTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Ad      TableViewCellIdentifier"];
    }
//    cell.delegate = self;
    NSDictionary *ad = self.listOfCategories[indexPath.row];
    [cell updateCellWithInfo:ad];
    return cell;
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
