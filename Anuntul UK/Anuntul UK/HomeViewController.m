//
//  HomeViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 29/01/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "HomeViewController.h"
#import "CategoryTableViewCell.h"
#import "UserAdsViewController.h"
#import "AdsDetailsViewController.h"
#import "MenuTableViewController.h"
#import "CustomToolbar.h"
#import "WebServiceManager.h"
#import "MBProgressHUD.h"
#import "UIColor+CustomColor.h"
#import "HexColors.h"
#import "SelectionViewController.h"
#import "SuccessViewController.h"

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate, AdsDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, SelectionDelegate> {
    NSInteger _pageNumber;
    BOOL _isSearch;
    BOOL _isPremium;
    UIPickerView *pickerView;
    UIToolbar *doneToolbar_;
    NSDictionary *selectedCategory;
    NSDictionary *selectedLocation;
    NSMutableArray *allCategories;
    NSMutableArray *allLocations;
    BOOL isCategorySelected;
}
@property (weak, nonatomic) IBOutlet UITableView *categoriesTableView;
@property (weak, nonatomic) IBOutlet CustomToolbar *customToolbar;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchTrailingConstraint;
@property (weak, nonatomic) IBOutlet UITextField *keyWordsTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *locationsButton;
@property (weak, nonatomic) IBOutlet UIButton *categoriesButton;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(closeSearchView:)];
    [self.searchView addGestureRecognizer:panGesture];
    _isSearch = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchButtonTapped:) name:@"SearchButtonTapped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPremiumAnnouncements:) name:@"GetPremiumAnnouncements" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRoot:) name:@"PopToRoot" object:nil];
    _pageNumber = 2;
    self.navigationController.navigationBarHidden = NO;
    self.categoriesTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([[WebServiceManager sharedInstance] categoryId]) {
        _isPremium = NO;
        self.listOfAds = [[NSMutableArray alloc] initWithArray:[[[WebServiceManager sharedInstance] adsValues] objectForKey:[[WebServiceManager sharedInstance] categoryId]]];
    } else {
        [[WebServiceManager sharedInstance] setCategoryName:@"Anunțul de UK"];
        _isPremium = YES;
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        [[WebServiceManager sharedInstance] getPremiumAnnouncementWithPageNumber:[NSNumber numberWithInteger:1] withCompletionBlock:^(NSArray *array, NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            if (!error) {
                self.listOfAds = [[NSMutableArray alloc] initWithArray:[[[WebServiceManager sharedInstance] adsValues] objectForKey:[[WebServiceManager sharedInstance] categoryId]]];
                [self.categoriesTableView reloadData];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
        //            self.listOfAds = [[NSMutableArray alloc] initWithArray:array];
        
        //        [[WebServiceManager sharedInstance] getAdsFromCategory:@"3" andPage:[NSNumber numberWithInteger:1] withCompletionBlock:^(NSArray *array, NSError *error) {
        //            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        //            self.listOfAds = [[NSMutableArray alloc] initWithArray:[[[WebServiceManager sharedInstance] adsValues] objectForKey:[[WebServiceManager sharedInstance] categoryId]]];
        //            self.navigationItem.title = @"Chirii";
        //            self.tabBarController.navigationItem.title = @"Chirii";
        
        //            [self.categoriesTableView reloadData];
        //        }];
    }
    
    
    //    self.navigationItem.title = [[WebServiceManager sharedInstance] categoryName];
    //    self.tabBarController.navigationItem.title = [[WebServiceManager sharedInstance] categoryName];
    
    // Do any additional setup after loading the view.
}

- (void)popToRoot:(NSNotification *)notification {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)closeSearchView:(UIPanGestureRecognizer *)gesture {
    CGPoint vel = [gesture velocityInView:self.view];
    if (vel.x > 0)
        if (self.searchTrailingConstraint.constant == 0) {
            NSString *string = [[WebServiceManager sharedInstance] categoryName];
            self.navigationItem.title = string;
            self.tabBarController.navigationItem.title = string;
            
            self.searchTrailingConstraint.constant = -CGRectGetWidth(self.view.frame);
            [UIView animateWithDuration:0.25 animations:^{
                [self.view layoutIfNeeded];
                [self.view endEditing:YES];
                _isSearch = !_isSearch;
            }];
        }
}

- (void)getPremiumAnnouncements:(NSNotification *)notification {
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [[WebServiceManager sharedInstance] setCategoryName:@"Anunțul de UK"];
    self.searchWidthConstraint.constant = CGRectGetWidth(self.view.frame);
    self.searchTrailingConstraint.constant = -CGRectGetWidth(self.view.frame);
    _isSearch = NO;
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
    //    self.searchTrailingConstraint.constant = 0;
    //    [self.view layoutIfNeeded];
    _isPremium = YES;
    _searchResultsRequired = NO;
    NSString *string = [[WebServiceManager sharedInstance] categoryName];
    self.navigationItem.title = string;
    self.tabBarController.navigationItem.title = string;
    
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    [[WebServiceManager sharedInstance] getPremiumAnnouncementWithPageNumber:[NSNumber numberWithInteger:1] withCompletionBlock:^(NSArray *array, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!error) {
            self.listOfAds = [[NSMutableArray alloc] initWithArray:[[[WebServiceManager sharedInstance] adsValues] objectForKey:[[WebServiceManager sharedInstance] categoryId]]];
            [self.categoriesTableView reloadData];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.navigationItem.hidesBackButton = YES;
    self.navigationItem.hidesBackButton = YES;
    self.tableViewBottomConstraint.constant = [[WebServiceManager sharedInstance] bottomConstraint];
    [self.view layoutIfNeeded];
    NSString *string = [[WebServiceManager sharedInstance] categoryName];
    self.navigationItem.title = string;
    self.tabBarController.navigationItem.title = string;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIColor *color = [UIColor hx_colorWithHexString:@"BFBFBF"];
    self.keyWordsTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Caută" attributes:@{NSForegroundColorAttributeName:color}];
    
    
    //    [self showTabBar:self.tabBarController];
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
    //    [self hideTabBar:self.tabBarController];
}

- (IBAction)searchButtonTapped:(id)notification {
    
    self.searchWidthConstraint.constant = CGRectGetWidth(self.view.frame);
    if (!_isSearch) {
        self.navigationItem.title = @"Căutare";
        self.tabBarController.navigationItem.title = @"Căutare";
        
        allCategories = [NSMutableArray arrayWithArray:[[WebServiceManager sharedInstance] listOfCategories]];
        //        [allCategories removeObjectAtIndex:0];
        [allCategories removeLastObject];
        //        [allCategories removeLastObject];
        //        [allCategories removeLastObject];
        
        allLocations = [[NSMutableArray alloc] init];
        NSArray *locations = [[WebServiceManager sharedInstance] listOfLocations];
        for (NSDictionary *location in locations) {
            [allLocations addObjectsFromArray:location[@"locations"]];
        }
        [allLocations insertObject:[NSDictionary dictionaryWithObject:@"Toate locatiile" forKey:@"titlu"] atIndex:0];
        selectedLocation = [allLocations firstObject];
        selectedCategory = [allCategories firstObject];
        //        self.locationsTextField.text = selectedLocation[@"titlu"];
        [self.locationsButton setTitle:selectedLocation[@"titlu"] forState:UIControlStateNormal];
        //        self.categoriesTextField.text = selectedCategory[@"titlu"];
        [self.categoriesButton setTitle:selectedCategory[@"titlu"] forState:UIControlStateNormal];
        
        _searchTrailingConstraint.constant = 0;
    } else {
        NSString *string = [[WebServiceManager sharedInstance] categoryName];
        self.navigationItem.title = string;
        self.tabBarController.navigationItem.title = string;
        _searchTrailingConstraint.constant = -CGRectGetWidth(self.view.frame);
    }
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
    [self.view endEditing:YES];
    _isSearch = !_isSearch;
}

// Method implementations
- (void)hideTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, CGRectGetHeight(self.view.frame) - 44, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, CGRectGetHeight(self.view.frame) - 44)];
        }
    }
    
    [UIView commitAnimations];
}

- (void)showTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        NSLog(@"%@", view);
        
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, CGRectGetHeight(self.view.frame) - 44, view.frame.size.width, view.frame.size.height)];
            
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, CGRectGetHeight(self.view.frame) - 44)];
        }
    }
    
    [UIView commitAnimations];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *ad = self.listOfAds[indexPath.row];
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    [[WebServiceManager sharedInstance] getAdsDetailsForAdId:[ad objectForKey:@"id_anunt"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!error) {
            AdsDetailsViewController *adsDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdsDetailsViewControllerIdentifier"];
            adsDetailsViewController.adDetails = dictionary;
            adsDetailsViewController.toPublish = NO;
            [self.navigationController pushViewController:adsDetailsViewController animated:YES];
        } else {
            if (error.code == 404 || error.code == 500) {
                //SHOW MISSING MESSAGE
                SuccessViewController *successController = [self.storyboard instantiateViewControllerWithIdentifier:@"SuccessViewControllerIdentifier"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    successController.isError = YES;
                    [self presentViewController:successController animated:YES completion:NULL];
                });
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
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
//    NSString *string = [[WebServiceManager sharedInstance] categoryName];
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
    return self.listOfAds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryTableViewCellIdentifier"];
    if (!cell) {
        cell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CategoryTableViewCellIdentifier"];
    }
    cell.delegate = self;
    cell.isHome = !_isCategory;
    NSDictionary *ad = self.listOfAds[indexPath.row];
    [cell updateCellWithInfo:ad withMyProfile:NO andIndexpath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.listOfAds.count - 3) {
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!_isPremium) {
            if (!_searchResultsRequired) {
                [[WebServiceManager sharedInstance] getAdsFromCategory:[[WebServiceManager sharedInstance] categoryId] andPage:[NSNumber numberWithInteger:_pageNumber] withCompletionBlock:^(NSArray *array, NSError *error) {
                    //                [[WebServiceManager sharedInstance] getSearchResultsWithKeyWord:@"" andLocation:@"" andCategory:[NSString stringWithFormat:@"%@",[[WebServiceManager sharedInstance] categoryId]] andPageNumber:[NSNumber numberWithInteger:_pageNumber] withCompletionBlock:^(NSArray *array, NSError *error) {
                    
                    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window]
                                         animated:YES];
                    if (!error) {
                        if (array && [array count]) {
                            [self.listOfAds addObjectsFromArray:array];
                            _pageNumber++;
                            [self.categoriesTableView reloadData];
                        }
                    } else {
                        [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    }
                }];
            } else {
                [[WebServiceManager sharedInstance] getSearchResultsWithKeyWord:self.keyWordsTextField.text andLocation:[NSString stringWithFormat:@"%@",selectedLocation[@"id"]] andCategory:[NSString stringWithFormat:@"%@",selectedCategory[@"id_categ"]] andPageNumber:[NSNumber numberWithInteger:_pageNumber] withCompletionBlock:^(NSArray *array, NSError *error) {
                    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                    if (!error) {
                        if (array && [array count]) {
                            [self.listOfAds addObjectsFromArray:array];
                            _pageNumber++;
                            [self.categoriesTableView reloadData];
                        }
                    } else {
                        [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    }
                }];
                
            }
        } else {
            if (!_searchResultsRequired) {
                [[WebServiceManager sharedInstance] getPremiumAnnouncementWithPageNumber:[NSNumber numberWithInteger:_pageNumber] withCompletionBlock:^(NSArray *array, NSError *error) {
                    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                    if (!error) {
                        if (array && [array count]) {
                            [self.listOfAds addObjectsFromArray:array];
                            _pageNumber++;
                            [self.categoriesTableView reloadData];
                        }
                    } else {
                        [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    }
                }];
            } else {
                [[WebServiceManager sharedInstance] getSearchResultsWithKeyWord:self.keyWordsTextField.text andLocation:[NSString stringWithFormat:@"%@",selectedLocation[@"id"]] andCategory:[NSString stringWithFormat:@"%@",selectedCategory[@"id_categ"]] andPageNumber:[NSNumber numberWithInteger:_pageNumber] withCompletionBlock:^(NSArray *array, NSError *error) {
                    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                    if (!error) {
                        if (array && [array count]) {
                            [self.listOfAds addObjectsFromArray:array];
                            _pageNumber++;
                            [self.categoriesTableView reloadData];
                        }
                    } else {
                        [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    }
                }];
                
            }
        }
    }
}

- (void)userTappedWithInfo:(NSDictionary *)userInfo {
    //    UserAdsViewController *userAdsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserAdsViewControllerIdentifier"];
    //    userAdsViewController.listOfAds = self.listOfAds;
    //    [self.navigationController pushViewController:userAdsViewController animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //    if (textField == self.categoriesTextField) {
    //        [self createToolbar];
    //        [self createPickerView];
    //        [textField setInputView:pickerView];
    //        [textField setInputAccessoryView:doneToolbar_];
    //        [pickerView reloadAllComponents];
    //    } else if (textField == self.locationsTextField) {
    //        [self createToolbar];
    //        [self createPickerView];
    //        [textField setInputView:pickerView];
    //        [textField setInputAccessoryView:doneToolbar_];
    //        [pickerView reloadAllComponents];
    //
    //    }
    
}

- (void)createToolbar {
    
    if (!doneToolbar_) {
        doneToolbar_ = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, CGRectGetWidth(self.view.frame), 44)];
        [doneToolbar_ insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar_40.png"]] atIndex:0];
        [doneToolbar_ setTintColor:[UIColor blackColor]];
        UIBarButtonItem *barButtonFlexibleGap = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                          target:self
                                          action:@selector(toolBarSelectedDone:)];
        doneToolbar_.items = [NSArray arrayWithObjects:barButtonFlexibleGap,barButtonDone, nil];
    }
}

- (void)createPickerView {
    if (!pickerView) {
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200)];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        [pickerView setShowsSelectionIndicator:YES];
    }
}

- (void)toolBarSelectedDone:(id)sender {
    if (sender) {
        //        if ([self.categoriesTextField isFirstResponder]) {
        //            if (selectedCategory) {
        //                self.categoriesTextField.text = [selectedCategory objectForKey:@"titlu"];
        //            } else {
        //                selectedCategory = [allCategories objectAtIndex:0];
        //                self.categoriesTextField.text = [[allCategories objectAtIndex:0] objectForKey:@"titlu"];
        //            }
        //        } else if ([self.locationsTextField isFirstResponder]) {
        //            if (selectedLocation) {
        //                self.locationsTextField.text = [selectedLocation objectForKey:@"titlu"];
        //            } else {
        //                selectedLocation = [allLocations objectAtIndex:0];
        //                self.locationsTextField.text = [[allLocations objectAtIndex:0] objectForKey:@"titlu"];
        //            }
        //        }
        [self.view endEditing:YES];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (IBAction)updateSearchButtonTapped:(id)sender {
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    [[WebServiceManager sharedInstance] getSearchResultsWithKeyWord:self.keyWordsTextField.text andLocation:[NSString stringWithFormat:@"%@",selectedLocation[@"id"]] andCategory:[NSString stringWithFormat:@"%@",selectedCategory[@"id_categ"]] andPageNumber:[NSNumber numberWithInt:1] withCompletionBlock:^(NSArray *array, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!error) {
            if (array && array.count < 1) {
                SuccessViewController *success = [self.storyboard instantiateViewControllerWithIdentifier:@"SuccessViewControllerIdentifier"];
                success.isEmpty = YES;
                [self presentViewController:success animated:YES completion:NULL];
                return;
            }
            _isPremium = NO;
            _searchResultsRequired = YES;
            self.listOfAds = [[NSMutableArray alloc] initWithArray:[[[WebServiceManager sharedInstance] adsValues] objectForKey:[[WebServiceManager sharedInstance] categoryId]]];
            [self searchButtonTapped:nil];
            NSString *headerTitle = @"";
            if (selectedLocation && selectedCategory) {
                //                headerTitle = [NSString stringWithFormat:@"%@, %@",selectedLocation[@"titlu"], selectedCategory[@"titlu"]];
                headerTitle = @"Rezultate";
            } else if (selectedLocation && !selectedCategory) {
                headerTitle = selectedLocation[@"titlu"];
            } else if (!selectedLocation && selectedCategory) {
                headerTitle = selectedCategory[@"titlu"];
            }
            [[WebServiceManager sharedInstance] setCategoryName:headerTitle];
            [self.categoriesTableView reloadData];
            if ([_listOfAds count] > 0) {
                
                
                [self.categoriesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            NSString *string = [[WebServiceManager sharedInstance] categoryName];
            self.navigationItem.title = string;
            self.tabBarController.navigationItem.title = string;
            //            self.searchButton.width = 0;
            self.tabBarController.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];
            self.navigationItem.rightBarButtonItem.enabled = NO;
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

#pragma mark UIPickerViewDelegate & DataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //    if ([self.categoriesTextField isFirstResponder]) {
    //        return allCategories.count;
    //    } else if ([self.locationsTextField isFirstResponder]) {
    //        return allLocations.count;
    //    }
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //    if ([self.categoriesTextField isFirstResponder]) {
    //        return [[allCategories objectAtIndex:row] objectForKey:@"titlu"];
    //    } else if ([self.locationsTextField isFirstResponder]) {
    //        return [[allLocations objectAtIndex:row] objectForKey:@"titlu"];
    //    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //    if ([self.categoriesTextField isFirstResponder]) {
    //        selectedCategory = nil;
    //        selectedCategory = [[NSDictionary alloc] initWithDictionary:[allCategories objectAtIndex:row]];
    //    } else if ([self.locationsTextField isFirstResponder]) {
    //        selectedLocation = nil;
    //        selectedLocation = [[NSDictionary alloc] initWithDictionary:[allLocations objectAtIndex:row]];
    //    }
}

- (IBAction)categoriesButtonTapped:(id)sender {
    [self.view endEditing:YES];
    SelectionViewController *selectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectionViewControllerIdentifier"];
    selectionViewController.allSelections = allCategories;
    selectionViewController.delegate = self;
    [self.navigationController pushViewController:selectionViewController animated:YES];
    isCategorySelected = YES;
}
- (IBAction)locationsButtonTapped:(id)sender {
    [self.view endEditing:YES];
    SelectionViewController *selectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectionViewControllerIdentifier"];
    selectionViewController.allSelections = allLocations;
    selectionViewController.delegate = self;
    [self.navigationController pushViewController:selectionViewController animated:YES];
    isCategorySelected = NO;
}

- (void)selectionDidSelect:(NSDictionary *)selection {
    if (isCategorySelected) {
        selectedCategory = selection;
        [self.categoriesButton setTitle:selection[@"titlu"] forState:UIControlStateNormal];
    } else {
        selectedLocation = selection;
        [self.locationsButton setTitle:selection[@"titlu"] forState:UIControlStateNormal];
    }
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
