//
//  MenuTableViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 29/01/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "MenuTableViewController.h"
#import "ECSlidingViewController.h"
#import <ECSlidingViewController/UIViewController+ECSlidingViewController.h>
#import "CustomTabBarViewController.h"
#import "WebServiceManager.h"
#import "UIColor+CustomColor.h"
#import "MBProgressHUD.h"
#import "MenuTableViewCell.h"
#import "LocationsViewController.h"
#import "HexColors.h"
#import "HomeViewController.h"

@interface MenuTableViewController () {
    NSArray *parametersArray;
    
}

@end

@implementation MenuTableViewController

- (void)unwindToMenuViewController:(UIStoryboardSegue *)segue {
    
    //    CATransition* transition = [CATransition animation];
    //    transition.duration = 0.3f;
    //    transition.type = kCATransitionMoveIn;
    //    transition.subtype = kCATransitionFromTop;
    //    [self.navigationController.view.layer addAnimation:transition
    //                                                forKey:kCATransition];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 25) ];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    [logoutButton setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"Anulează" forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButtonItem1 = [[UIBarButtonItem alloc]
                                           initWithCustomView:cancelButton];
    [leftBarButtonItem1 setTintColor:[UIColor blackColor]];
    
    //set the action for button
    self.navigationItem.leftBarButtonItem = leftBarButtonItem1;
    
    //    parametersArray = [[NSArray alloc] initWithObjects:@"",@"Anunturi promovate", @"Toate anunturile", @"Locuri de munca", @"Cereri de munca", @"Chirii", @"Servicii", @"Bazar", @"Matrimoniale", @"Autostop", @"Anunturile Mele", @"", @"Blog", nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)cancelButtonTapped:(id)sender {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    //    MenuTableViewController *menuTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewControllerIdentifier"];
    //    [self.navigationController pushViewController:menuTableViewController animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"Meniu";
    self.tabBarController.navigationItem.title = @"Meniu";
    //    self.navigationController.navigationBarHidden = YES;
}

- (void)showMainMenu:(id)sender {
    [self.slidingViewController anchorTopViewToLeftAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[WebServiceManager sharedInstance] listOfCategories] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCellIdentifier"];
    if (!cell) {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuTableViewCellIdentifier"];
    }
    NSDictionary *cellInfo = [[[WebServiceManager sharedInstance] listOfCategories] objectAtIndex:indexPath.row];
    cell.titleLabel.text = [cellInfo objectForKey:@"titlu"];
    cell.arrowImageView.hidden = NO;
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 30;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
//    /* Create custom view to display section header... */
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 5, tableView.frame.size.width, 25)];
//    //    [label setFont:[UIFont boldSystemFontOfSize:12]];
//    NSString *string = @"Meniu";
//    /* Section header is in 0th index... */
//    [label setText:string];
//    //    [label setTextColor:[UIColor colorFromHexString:@"c1c1c1"]];
//    [label setTextColor:[HXColor hx_colorWithHexString:@"c1c1c1"]];
//    [view addSubview:label];
//    //    [view setBackgroundColor:[UIColor colorFromHexString:@"f1eef1"]];
//    [view setBackgroundColor:[HXColor hx_colorWithHexString:@"f1eef1"]];
//    return view;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    CustomTabBarViewController *tabBar = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomTabBarViewControllerIdentifier"];
    NSLog(@"%ld", (long)indexPath.row);
    if (indexPath.row == 0) {
        NSDictionary *cellInfo = [[[WebServiceManager sharedInstance] listOfCategories] objectAtIndex:indexPath.row];
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        [[WebServiceManager sharedInstance] getSearchResultsWithKeyWord:@"" andLocation:@"" andCategory:@""  andPageNumber:[NSNumber numberWithInt:1] withCompletionBlock:^(NSArray *array, NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            if (!error) {
                [[WebServiceManager sharedInstance] setCategoryName:cellInfo[@"titlu"]];
                [[WebServiceManager sharedInstance] setBottomConstraint:-50];
                HomeViewController *locationsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewControllerIdentifier"];
                CATransition* transition = [CATransition animation];
                transition.duration = 0.5;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
                transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
                //            tabBar.selectedIndex = 0;
                [self.navigationController.view.layer addAnimation:transition forKey:nil];
                
                [self.navigationController pushViewController:locationsViewController animated:YES];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];

    } else if (indexPath.row < [[[WebServiceManager sharedInstance] listOfCategories] count] - 1
               ) {
        NSDictionary *cellInfo = [[[WebServiceManager sharedInstance] listOfCategories] objectAtIndex:indexPath.row];
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        [[WebServiceManager sharedInstance] getAdsFromCategory:[cellInfo objectForKey:@"id_categ"] andPage:[NSNumber numberWithInt:1] withCompletionBlock:^(NSArray *array, NSError *error) {
//        [[WebServiceManager sharedInstance] getSearchResultsWithKeyWord:@"" andLocation:@"" andCategory:[NSString stringWithFormat:@"%@",cellInfo[@"id_categ"]] andPageNumber:[NSNumber numberWithInt:1] withCompletionBlock:^(NSArray *array, NSError *error) {

            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            if (!error) {
                [[WebServiceManager sharedInstance] setCategoryName:[cellInfo objectForKey:@"titlu"]];
                [[WebServiceManager sharedInstance] setBottomConstraint:-50];
                HomeViewController *locationsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewControllerIdentifier"];
                CATransition* transition = [CATransition animation];
                transition.duration = 0.5;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
                transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
                //            tabBar.selectedIndex = 0;
                [self.navigationController.view.layer addAnimation:transition forKey:nil];
                
                [self.navigationController pushViewController:locationsViewController animated:YES];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];

    } else if (indexPath.row == [[[WebServiceManager sharedInstance] listOfCategories] count] - 1) {
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        [[WebServiceManager sharedInstance] getAllLocationWithCompletionBlock:^(NSArray *array, NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            if (!error) {
                LocationsViewController *locationsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationsViewControllerIdentifier"];
                CATransition* transition = [CATransition animation];
                transition.duration = 0.5;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
                transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
                //            tabBar.selectedIndex = 0;
                [self.navigationController.view.layer addAnimation:transition forKey:nil];
                
                [self.navigationController pushViewController:locationsViewController animated:YES];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];

    }
//    if (indexPath.row >= 0 && indexPath.row <= [[[WebServiceManager sharedInstance] listOfCategories] count] - 3) {
//        NSDictionary *cellInfo = [[[WebServiceManager sharedInstance] listOfCategories] objectAtIndex:indexPath.row];
//        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
//        [[WebServiceManager sharedInstance] getAdsFromCategory:[cellInfo objectForKey:@"id_categ"] andPage:[NSNumber numberWithInt:1] withCompletionBlock:^(NSArray *array, NSError *error) {
//            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
//            if (!error) {
//                [[WebServiceManager sharedInstance] setCategoryName:[cellInfo objectForKey:@"titlu"]];
//                [[WebServiceManager sharedInstance] setBottomConstraint:-50];
//                HomeViewController *locationsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewControllerIdentifier"];
//                CATransition* transition = [CATransition animation];
//                transition.duration = 0.5;
//                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//                transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
//                transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
//                //            tabBar.selectedIndex = 0;
//                [self.navigationController.view.layer addAnimation:transition forKey:nil];
//                
//                [self.navigationController pushViewController:locationsViewController animated:YES];
//            } else {
//                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//            }
//        }];
//    } else if (indexPath.row == [[[WebServiceManager sharedInstance] listOfCategories] count] - 2) {
//        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
//        [[WebServiceManager sharedInstance] getAllLocationWithCompletionBlock:^(NSArray *array, NSError *error) {
//            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
//            if (!error) {
//                LocationsViewController *locationsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationsViewControllerIdentifier"];
//                CATransition* transition = [CATransition animation];
//                transition.duration = 0.5;
//                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//                transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
//                transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
//                //            tabBar.selectedIndex = 0;
//                [self.navigationController.view.layer addAnimation:transition forKey:nil];
//                
//                [self.navigationController pushViewController:locationsViewController animated:YES];
//            } else {
//                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//            }
//        }];
//    } else if (indexPath.row == [[[WebServiceManager sharedInstance] listOfCategories] count] - 1) {CATransition* transition = [CATransition animation];
//        transition.duration = 0.5;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
//        transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
//        tabBar.selectedIndex = 3;
//        [[WebServiceManager sharedInstance] setTopConstraint:0];
//        [self.navigationController.view.layer addAnimation:transition forKey:nil];
//        [self.navigationController pushViewController:tabBar animated:YES];
//        
//    } else if (indexPath.row == 11) {
//        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
//        [[WebServiceManager sharedInstance] getBlogArticlesWithPageNumber:[NSNumber numberWithInteger:1] WithCompletionBlock:^(NSArray *array, NSError *error) {
//            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
//            if (!error) {
//                CATransition* transition = [CATransition animation];
//                transition.duration = 0.5;
//                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//                transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
//                transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
//                tabBar.selectedIndex = 1;
//                [self.navigationController.view.layer addAnimation:transition forKey:nil];
//                [self.navigationController pushViewController:tabBar animated:YES];
//            } else {
//                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//            }
//        }];
//    }
}

@end
