//
//  CustomTabBarViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 07/02/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "MenuTableViewController.h"
#import "HexColors.h"
#import "WebServiceManager.h"

@interface CustomTabBarViewController ()<UITabBarControllerDelegate, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@end

@implementation CustomTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
//    [[UITabBar appearance] setBarTintColor:[UIColor redColor]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor hx_colorWithHexString:@"2299c3"]];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchButtonTapped:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchButtonTapped" object:nil];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex == 0) {
        [self.searchButton setEnabled:YES];
        [[WebServiceManager sharedInstance] setBottomConstraint:0];
        [self.searchButton setTintColor:[UIColor hx_colorWithHexString:@"FFF"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetPremiumAnnouncements" object:nil];
    } else if (tabBarController.selectedIndex == 1) {
        [self.searchButton setEnabled:NO];
        [self.searchButton setTintColor:[UIColor clearColor]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Get Blog Articles" object:nil];
    } else if (tabBarController.selectedIndex == 2) {
        [self.searchButton setEnabled:NO];
        [self.searchButton setTintColor:[UIColor clearColor]];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if (([userDefaults objectForKey:@"email"] && [userDefaults objectForKey:@"password"]) || [userDefaults objectForKey:@"facebookEmail"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Get Announcement Types" object:nil];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Pentru a adauga un anunt, trebuie sa va logati" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            tabBarController.selectedIndex = 1;
        }
    } else if (tabBarController.selectedIndex == 3) {
        [[WebServiceManager sharedInstance] setTopConstraint:44];
        [self.searchButton setEnabled:NO];
        [self.searchButton setTintColor:[UIColor clearColor]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopToRoot" object:nil];
}

- (IBAction)goToMainMenu:(id)sender {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    MenuTableViewController *menuTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewControllerIdentifier"];
    [self.navigationController pushViewController:menuTableViewController animated:NO];
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
