//
//  SuccessViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 04/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "SuccessViewController.h"
#import "MBProgressHUD.h"
#import "WebServiceManager.h"
#import "LocationAdsViewController.h"
#import "AnnouncementTypesViewController.h"

@interface SuccessViewController() {
    
}
@property (weak, nonatomic) IBOutlet UIButton *addNewAnnouncementButton;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIImageView *successImageView;

@end

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [_backBtn setHidden:YES];
    if (_isError) {
        [_backBtn setHidden:NO];
        [_successImageView setHidden:YES];
        self.titleLabel.text = @"Eroare";
        self.messageLabel.text = @"Anunt inexistent sau expirat! Anuntul asteapta aprobarea unui administrator!";
        [self.myAnnouncements setHidden:YES];
        [self.addAnnouncementButton setHidden:YES];
    }
}
- (IBAction)addNewAnnouncement:(id)sender {
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    AnnouncementTypesViewController *announcementTypes = [self.storyboard instantiateViewControllerWithIdentifier:@"AnnouncementTypesViewControllerIdentifier"];
    announcementTypes.republishedAnnouncement = nil;
    [self.navigationController pushViewController:announcementTypes animated:YES];

}
- (IBAction)goToMyAnnouncements:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    [[WebServiceManager sharedInstance] getAdsForUser:[userDefaults objectForKey:@"id_user"] withPageNumber:[NSNumber numberWithInteger:1] withCompletionBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            LocationAdsViewController *locationAdsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationAdsViewControllerIdentifier"];
            locationAdsViewController.locationAds = [NSMutableArray arrayWithArray:array];
            locationAdsViewController.locationId = [userDefaults objectForKey:@"id_user"];
            locationAdsViewController.locationTitle = [userDefaults objectForKey:@"facebookName"];
            locationAdsViewController.isLocations = NO;
            locationAdsViewController.isMyProfile = YES;
            [self.navigationController pushViewController:locationAdsViewController animated:YES];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];

}
- (IBAction)backBtnTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
