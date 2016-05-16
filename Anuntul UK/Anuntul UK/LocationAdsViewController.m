//
//  LocationAdsViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 17/02/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "LocationAdsViewController.h"
#import "MBProgressHUD.h"
#import "WebServiceManager.h"
#import "AdsDetailsViewController.h"
#import "HexColors.h"
#import "CategoryTableViewCell.h"
#import "MBProgressHUD.h"
#import "AnnouncementTypesViewController.h"

@interface LocationAdsViewController()<AdsDelegate, UIActionSheetDelegate> {
    NSInteger _pageNumber;
    NSIndexPath *_indexpath;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end

@implementation LocationAdsViewController

- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNumber = 2;
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 15) ];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem1 = [[UIBarButtonItem alloc]
                                           initWithCustomView:backButton];
    [leftBarButtonItem1 setTintColor:[UIColor blackColor]];
    
    //set the action for button
    
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem1;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRoot:) name:@"PopToRoot" object:nil];
    NSString *string = self.locationTitle;
    self.navigationItem.title = string;
    self.tabBarController.navigationItem.title = string;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    if (self.isMyProfile) {
        self.backgroundImage.image = nil;
        self.backgroundImage.backgroundColor = [UIColor whiteColor];
        self.segmentedControlHeight.constant = 50;
        self.segmentedControl.hidden = NO;
//        self.segmentedControl.tintColor = [UIColor brownColor];
        self.segmentedControl.layer.cornerRadius = 0.0;
        self.segmentedControl.layer.borderColor = [UIColor hx_colorWithHexString:@"2299C3"].CGColor;
//        self.segmentedControl.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75].CGColor;
        self.segmentedControl.layer.borderWidth = 1.5f;
        self.segmentedControl.layer.masksToBounds = YES;
    } else {
        self.segmentedControl.hidden = YES;
        self.segmentedControlHeight.constant = 0;
        self.tableViewTopConstraint.constant = -10;
    }
    [self.view layoutIfNeeded];

}

- (void)popToRoot:(NSNotification *)notification {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *ad = self.locationAds[indexPath.row];
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    [[WebServiceManager sharedInstance] getAdsDetailsForAdId:[ad objectForKey:@"id_anunt"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!error) {
            AdsDetailsViewController *adsDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdsDetailsViewControllerIdentifier"];
            adsDetailsViewController.adDetails = dictionary;
            adsDetailsViewController.toPublish = NO;
            [self.navigationController pushViewController:adsDetailsViewController animated:YES];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
    }];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 30;
//}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
//    /* Create custom view to display section header... */
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 5, tableView.frame.size.width, 25)];
//    //    [label setFont:[UIFont boldSystemFontOfSize:12]];
//    NSString *string = self.locationTitle;
//    /* Section header is in 0th index... */
//    [label setText:string];
//    //    [label setTextColor:[UIColor colorFromHexString:@"c1c1c1"]];
//    [label setTextColor:[HXColor hx_colorWithHexString:@"c1c1c1"]];
//    [view addSubview:label];
//    //    [view setBackgroundColor:[UIColor colorFromHexString:@"f1eef1"]];
//    [view setBackgroundColor:[HXColor hx_colorWithHexString:@"f1eef1"]];
//    return view;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locationAds.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryTableViewCellIdentifier"];
    if (!cell) {
        cell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CategoryTableViewCellIdentifier"];
    }
    cell.delegate = self;
    NSDictionary *ad = self.locationAds[indexPath.row];
    [cell updateCellWithInfo:ad withMyProfile:self.isMyProfile andIndexpath:indexPath];
    return cell;
}

- (void)optionsButtonTapped:(UITapGestureRecognizer *)tapGesture andIndexpath:(NSIndexPath *)indexpath {
    _indexpath = indexpath;
//    [self.tableView setEditing:YES animated:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Renunță" destructiveButtonTitle:@"Publică din nou" otherButtonTitles:@"Șterge anunțul", nil];
    actionSheet.destructiveButtonIndex = 1;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSDictionary *cellInfo = self.locationAds[_indexpath.row];
    if (buttonIndex == 1) {
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        [[WebServiceManager sharedInstance] destroyAnnouncementForAnnouncementId:cellInfo[@"id_anunt"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            if ([dictionary[@"success"] boolValue]) {
                [self.locationAds removeObjectAtIndex:_indexpath.row];
                [self.tableView reloadData];
            }
        }];
    } else if (buttonIndex == 0) {
        AnnouncementTypesViewController *announcementTypes = [self.storyboard instantiateViewControllerWithIdentifier:@"AnnouncementTypesViewControllerIdentifier"];
        [self.navigationController pushViewController:announcementTypes animated:YES];
//        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
//        [[WebServiceManager sharedInstance] republishAnnouncementForAnnouncementId:cellInfo[@"id_anunt"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
//            [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
//            if ([dictionary[@"success"] boolValue]) {
//                [self.tableView reloadData];
//            }
//        }];
        
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.locationAds.count - 3) {
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (self.isLocations) {
            [[WebServiceManager sharedInstance] getAllAdsFromLocation:self.locationId withPageNumber:[NSNumber numberWithInteger:_pageNumber] withCompletionBlock:^(NSArray *array, NSError *error) {
//            [[WebServiceManager sharedInstance] getSearchResultsWithKeyWord:@"" andLocation:[NSString stringWithFormat:@"%@",self.locationId] andCategory:@"" andPageNumber:[NSNumber numberWithInteger:_pageNumber] withCompletionBlock:^(NSArray *array, NSError *error) {

            
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                if (!error) {
                    if (array && [array count]) {
                        [self.locationAds addObjectsFromArray:array];
                        _pageNumber++;
                        [self.tableView reloadData];
                    }
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            }];
        } else {
            [[WebServiceManager sharedInstance] getAdsForUser:self.locationId withPageNumber:[NSNumber numberWithInteger:_pageNumber]
                                          withCompletionBlock:^(NSArray *array, NSError *error) {
                                              [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                                              if (!error) {
                                                  if (array && [array count]) {
                                                      [self.locationAds addObjectsFromArray:array];
                                                      _pageNumber++;
                                                      [self.tableView reloadData];
                                                  }
                                              } else {
                                                  [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                              }
                                          }];
        }
    }
}

- (IBAction)segmentedControlTapped:(id)sender {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];

        [[WebServiceManager sharedInstance] getAdsForUser:self.locationId withPageNumber:[NSNumber numberWithInteger:1] withCompletionBlock:^(NSArray *array, NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            _pageNumber = 2;
            self.locationAds = [NSMutableArray arrayWithArray:array];
            [self.tableView reloadData];
        }];

    } else if (self.segmentedControl.selectedSegmentIndex == 1) {
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        
        [[WebServiceManager sharedInstance] getWaitingAnnouncementsForUser:self.locationId andPageNumber:[NSNumber numberWithInteger:1] withCompletionBlock:^(NSArray *array, NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            _pageNumber = 2;
            self.locationAds = [NSMutableArray arrayWithArray:array];
            [self.tableView reloadData];
        }];
    } else if (self.segmentedControl.selectedSegmentIndex == 2) {
        
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        
        [[WebServiceManager sharedInstance] showExpiredAnnouncements:self.locationId andPageNumber:[NSNumber numberWithInteger:1] withCompletionBlock:^(NSArray *array, NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            _pageNumber = 2;
            self.locationAds = [NSMutableArray arrayWithArray:array];
            [self.tableView reloadData];
        }];
    }
}

@end
