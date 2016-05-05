//
//  AdsDetailsViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 29/01/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "AdsDetailsViewController.h"
#import "MBProgressHUD.h"
#import "WebServiceManager.h"
#import "LocationAdsViewController.h"
#import "Haneke.h"
#import <MessageUI/MessageUI.h>
#import "HexColors.h"
#import "PhotoGalleryViewController.h"
#import "EmailViewController.h"
#import "NSString+RemovedCharacters.h"
#import "PayPalMobile.h"
#import "AnnouncementImageCollectionViewCell.h"
#import "PhotoGalleryCollectionViewCell.h"
#import "UIView+Borders.h"
#import "SuccessViewController.h"

#define kPayPalEnvironment PayPalEnvironmentProduction


@interface AdsDetailsViewController ()<MFMailComposeViewControllerDelegate,PayPalFuturePaymentDelegate, PayPalPaymentDelegate, UICollectionViewDelegate, UICollectionViewDataSource> {
    NSDictionary *newAnnouncement;
}
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *descriptionLabel;
@property (strong, nonatomic)  UIButton *emailButton;
@property (strong, nonatomic)  UIButton *phoneNumberButton;
@property (strong, nonatomic)  UILabel *viewsLabel;
@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic)  UIImageView *userImageView;
//@property (strong, nonatomic)  UIImageView *imageView1;
//@property (strong, nonatomic)  UIImageView *imageView2;
//@property (strong, nonatomic)  UIImageView *imageView3;
@property (strong, nonatomic)  UIImageView *separator1;
@property (strong, nonatomic)  UIImageView *separator2;
@property (strong, nonatomic)  UILabel *adIdLabel;
@property (strong, nonatomic)  UIButton *reportButton;
@property (strong, nonatomic)  UILabel *userLabel;
@property (strong, nonatomic)  UILabel *registeredLabel;
@property (strong, nonatomic)  UILabel *onlineLabel;
@property (strong, nonatomic)  UIButton *publishButton;
@property (strong, nonatomic)  UICollectionView *collectionView;
@property (strong, nonatomic)  UIView *buttonsView;
@property (strong, nonatomic)  UIPageControl *pageControl;
@property (strong, nonatomic)  UILabel *usernameLabel;
@property (strong, nonatomic)  UILabel *createdAtLabel;
@property (nonatomic, strong)  PayPalConfiguration *paypalConfig;



@end

@implementation AdsDetailsViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UICollectionViewFlowLayout *flowLayout = (id)self.collectionView.collectionViewLayout;

//    if (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)) {
//        flowLayout.itemSize = CGSizeMake(170.f, 170.f);
//    } else {
//        flowLayout.itemSize = CGSizeMake(192.f, 192.f);
//    }
    flowLayout.itemSize = self.collectionView.frame.size;
    [self.collectionView scrollsToTop];
    
    [flowLayout invalidateLayout];
//    [self.collectionView reloadData];
    self.scrollView.frame = self.view.bounds;
    self.titleLabel.frame = CGRectMake(10, 64, CGRectGetWidth(self.scrollView.frame) - 20, 0);
    
    [self updateTitle];
    
    self.viewsLabel.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) - 15, CGRectGetWidth(self.scrollView.frame) - 20, 44);
    NSInteger imageHeight = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.collectionView.frame = CGRectMake(10, CGRectGetMaxY(self.viewsLabel.frame) - 10,  CGRectGetWidth(self.scrollView.frame) - 20, 550);
    } else {
        self.collectionView.frame = CGRectMake(10, CGRectGetMaxY(self.viewsLabel.frame) - 10,  CGRectGetWidth(self.scrollView.frame) - 20, 200);
    }
    
    self.pageControl.frame = CGRectMake(10, CGRectGetMaxY(self.collectionView.frame) - 10, CGRectGetWidth(self.collectionView.frame), 10);
    
    if ([self.adDetails[@"images"] count]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            imageHeight = 550;
        } else {
            imageHeight = 200;
        }
    }
    if (self.collectionView) {
        self.descriptionLabel.frame = CGRectMake(10, CGRectGetMaxY(self.collectionView.frame) + 10, CGRectGetWidth(self.scrollView.frame) - 20, 0);
    } else {
        self.descriptionLabel.frame = CGRectMake(10, CGRectGetMaxY(self.viewsLabel.frame) + 5, CGRectGetWidth(self.scrollView.frame) - 20, 0);
    }
    
    [self updateDescription];
    
    if (!self.toPublish) {
        self.usernameLabel.frame = CGRectMake(10, CGRectGetMaxY(self.descriptionLabel.frame) + 5, CGRectGetWidth(self.scrollView.frame) - 20, 20);
        self.createdAtLabel.frame = CGRectMake(10, CGRectGetMaxY(self.usernameLabel.frame), CGRectGetWidth(self.scrollView.frame) - 20, 20);
    }
    if (!self.toPublish) {
        self.separator1.frame = CGRectMake(10, CGRectGetMaxY(self.createdAtLabel.frame) + 5, CGRectGetWidth(self.scrollView.frame) - 20, 1);
    } else {
        self.separator1.frame = CGRectMake(10, CGRectGetMaxY(self.descriptionLabel.frame) + 5, CGRectGetWidth(self.scrollView.frame) - 20, 1);
    }
    self.adIdLabel.frame = CGRectMake(10, CGRectGetMaxY(self.separator1.frame), CGRectGetWidth(self.scrollView.frame) / 2 - 20, 30);
    self.reportButton.frame = CGRectMake(CGRectGetWidth(self.scrollView.frame) / 2, CGRectGetMaxY(self.separator1.frame), CGRectGetWidth(self.scrollView.frame) / 2 - 20, 30);
    
    self.separator2.frame = CGRectMake(10, CGRectGetMaxY(self.adIdLabel.frame), CGRectGetWidth(self.scrollView.frame) - 20, 1);
    if (!self.toPublish) {
        self.buttonsView.frame = CGRectMake(10, CGRectGetMaxY(self.view.frame) - 54, CGRectGetWidth(self.scrollView.frame) - 20, 54);
    } else {
        self.buttonsView.frame = CGRectMake(10, CGRectGetMaxY(self.separator2.frame), CGRectGetWidth(self.scrollView.frame) - 20, 54);
    }

    UIColor *color = [UIColor hx_colorWithHexString:@"929292"];
    
        [self.buttonsView addTopBorderWithHeight:1 andColor:color];
//    [self.buttonsView addLeftBorderWithWidth:1 andColor:color];
//    [self.buttonsView addRightBorderWithWidth:1 andColor:color];
//    [self.buttonsView addBottomBorderWithHeight:1 andColor:color];
    
    if (self.emailButton) {
//        self.emailButton.frame = CGRectMake(20,  CGRectGetMaxY(self.separator2.frame) + 10, CGRectGetWidth(self.scrollView.frame) / 2 - 40, 44);
        self.phoneNumberButton.frame = CGRectMake(0, 5, CGRectGetWidth(self.buttonsView.frame) / 2 - 5, 42);
    } else {
        self.phoneNumberButton.frame = CGRectMake(0, 5, CGRectGetWidth(self.buttonsView.frame), 42);
    }
    [self.emailButton setBackgroundColor:[HXColor hx_colorWithHexString:@"2299c3"]];
    self.emailButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    if (self.phoneNumberButton) {
        self.emailButton.frame = CGRectMake(CGRectGetWidth(self.buttonsView.frame) / 2 + 5, 5, CGRectGetWidth(self.buttonsView.frame) / 2 - 5, 42);
    } else {
        self.emailButton.frame = CGRectMake(0, 5, CGRectGetWidth(self.buttonsView.frame), 42);
    }
    [self.phoneNumberButton setBackgroundColor:[HXColor hx_colorWithHexString:@"2299c3"]];
    self.phoneNumberButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    if (self.emailButton) {
        self.userImageView.frame = CGRectMake(10, CGRectGetMaxY(self.emailButton.frame) + 5, 80, 80);
    } else if (self.phoneNumberButton) {
        self.userImageView.frame = CGRectMake(10, CGRectGetMaxY(self.phoneNumberButton.frame) + 5, 80, 80);
    } else {
        self.userImageView.frame = CGRectMake(10, CGRectGetMaxY(self.separator2.frame) + 5, 80, 80);
    }
    
    if (![[self.adDetails[@"user"] objectForKey:@"avatar"] isKindOfClass:[NSNull class]]) {
        if ([[self.adDetails[@"user"] objectForKey:@"avatar"] length]) {
            [self.userImageView hnk_setImageFromURL:[NSURL URLWithString:[self.adDetails[@"user"] objectForKey:@"avatar"]]];
        } else {
            self.userImageView.image = [UIImage imageNamed:@"no-image"];
        }
    } else {
        self.userImageView.image = [UIImage imageNamed:@"no-image"];
    }
    
    self.userLabel.frame = CGRectMake(CGRectGetMaxX(self.userImageView.frame) + 5, CGRectGetMinY(self.userImageView.frame), CGRectGetWidth(self.scrollView.frame) - CGRectGetWidth(self.userImageView.frame), 30);
    self.userLabel.font = [UIFont boldSystemFontOfSize:19];
    self.registeredLabel.frame = CGRectMake(CGRectGetMaxX(self.userImageView.frame) + 5, CGRectGetMaxY(self.userLabel.frame) - 5, CGRectGetWidth(self.scrollView.frame) - CGRectGetWidth(self.userImageView.frame), 30);
    self.onlineLabel.frame = CGRectMake(CGRectGetMaxX(self.userImageView.frame) + 5, CGRectGetMaxY(self.registeredLabel.frame) - 5, CGRectGetWidth(self.scrollView.frame) - CGRectGetWidth(self.userImageView.frame), 30);
    if (!self.toPublish) {
        self.publishButton.frame = CGRectMake(10, CGRectGetMaxY(self.separator2.frame) + 5, CGRectGetWidth(self.scrollView.frame) - 20, 42);
    } else {
        self.publishButton.frame = CGRectMake(10, CGRectGetMaxY(self.buttonsView.frame), CGRectGetWidth(self.scrollView.frame) - 20, 42);
    }
    

    
    
   
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.titleLabel.frame) + CGRectGetHeight(self.viewsLabel.frame) + CGRectGetHeight(self.descriptionLabel.frame) + CGRectGetHeight(self.separator1.frame) + CGRectGetHeight(self.adIdLabel.frame) + CGRectGetHeight(self.separator2.frame) + imageHeight + CGRectGetHeight(self.userImageView.frame) + CGRectGetHeight(self.publishButton.frame) + 154);
    
}

- (void)updateTitle {
    
    CGRect titleFrame = self.titleLabel.frame;
    float titleHeight = [self getHeightForText:self.titleLabel.text
                                      withFont:self.titleLabel.font
                                      andWidth:self.titleLabel.frame.size.width];
    
    self.titleLabel.frame = CGRectMake(titleFrame.origin.x,
                                       titleFrame.origin.y,
                                       titleFrame.size.width,
                                       titleHeight);
    
}

- (void)updateDescription {
    CGRect descriptionFrame = self.descriptionLabel.frame;
    
    float descriptionHeight = [self getHeightForText:self.descriptionLabel.text
                                            withFont:self.descriptionLabel.font
                                            andWidth:self.descriptionLabel.frame.size.width];
    
    self.descriptionLabel.frame = CGRectMake(descriptionFrame.origin.x,
                                             descriptionFrame.origin.y,
                                             descriptionFrame.size.width,
                                             descriptionHeight);
}

- (NSString *)findStringInDescription:(NSString *)searchedString {
//    NSString *searchedString = @"domain-name.tld.tld2";
    NSRange   searchedRange = NSMakeRange(0, [searchedString length]);
    NSString *pattern = @"<a href=\"tel:.*\">";
    NSError  *error = nil;
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
    NSArray* matches = [regex matchesInString:searchedString options:0 range: searchedRange];
    for (NSTextCheckingResult* match in matches) {
        NSString* matchText = [searchedString substringWithRange:[match range]];
        NSLog(@"match: %@", matchText);
        return matchText;
//        NSRange group1 = [match rangeAtIndex:1];
//        NSRange group2 = [match rangeAtIndex:2];
//        NSLog(@"group1: %@", [searchedString substringWithRange:group1]);
//        NSLog(@"group2: %@", [searchedString substringWithRange:group2]);
    }
    return nil;
}

- (void)popToRoot:(NSNotification *)notification {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)publishButtonTapped:(id)sender {
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    [[WebServiceManager sharedInstance] createAnnouncementWithCategoryId:[NSString stringWithFormat:@"%@",self.announcementInfo[@"id_categ"]] userId:[NSString stringWithFormat:@"%@",self.announcementInfo[@"id_user"]] locationId:[NSString stringWithFormat:@"%@",self.announcementInfo[@"id_locatie"]] announcementType:[NSString stringWithFormat:@"%@",self.announcementInfo[@"setari_anunturi_id"]] title:self.announcementInfo[@"titlu"] description:self.announcementInfo[@"descriere"] phoneNumber:[NSString stringWithFormat:@"%@",self.announcementInfo[@"telefon"]] images:self.adDetails[@"images"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!error) {
            if ([dictionary[@"success"] boolValue]) {
                if ([self.announcementInfo[@"setari_anunturi_id"] integerValue] == 2) {
//                    if (!self.toPublish) {
                        self.tabBarController.tabBar.hidden = NO;
//                    }
//                    [self.navigationController popToRootViewControllerAnimated:YES];
                    SuccessViewController *successViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SuccessViewControllerIdentifier"];
                    [self.navigationController pushViewController:successViewController animated:YES];
                } else {
                    newAnnouncement = dictionary;
//                    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
                    _paypalConfig = [[PayPalConfiguration alloc] init];
                    _paypalConfig.acceptCreditCards = YES;
                    _paypalConfig.merchantName = @"Anunțul de UK";
                    _paypalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
                    _paypalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
                    
                    _paypalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
                    
                    _paypalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionNone;
                    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
                    
                    PayPalItem *item1 = [PayPalItem itemWithName:[NSString stringWithFormat:@"%@",self.announcementType[@"titlu"]] withQuantity:1 withPrice:[NSDecimalNumber decimalNumberWithString:self.announcementType[@"amount"]] withCurrency:@"GBP" withSku:self.announcementInfo[@"titlu"]];
                    NSArray *items = @[item1];
                    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
                    
                    // Optional: include payment details
                    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0"];
                    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0"];
                    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                                               withShipping:shipping
                                                                                                    withTax:tax];
                    
                    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
                    
                    PayPalPayment *payment = [[PayPalPayment alloc] init];
                    payment.amount = total;
                    payment.currencyCode = @"GBP";
                    payment.shortDescription = [NSString stringWithFormat:@"%@",self.announcementType[@"titlu"]];
                    payment.items = items;  // if not including multiple items, then leave payment.items as nil
                    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
                    _paypalConfig.acceptCreditCards = YES;
                    
                    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:_paypalConfig delegate:self];
                    [self presentViewController:paymentViewController animated:YES completion:nil];

                }
            }
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
    
}

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    //    self.resultText = [completedPayment description];
    
    
    [self dismissViewControllerAnimated:YES completion:^{
//        if (!self.toPublish) {
            self.tabBarController.tabBar.hidden = NO;
//        }
        NSString *email = @"";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults objectForKey:@"email"]) {
            email = [userDefaults objectForKey:@"email"];
        } else if ([userDefaults objectForKey:@"facebookEmail"]) {
            email = [userDefaults objectForKey:@"facebookEmail"];
        }
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        [[WebServiceManager sharedInstance] paymentPerformedByUserId:[NSString stringWithFormat:@"%@",self.announcementInfo[@"id_user"]] announcementId:[NSString stringWithFormat:@"%@",newAnnouncement[@"id_anunt"]] typeId:[NSString stringWithFormat:@"%@",self.announcementInfo[@"setari_anunturi_id"]] ammount:[NSString stringWithFormat:@"%@",completedPayment.amount] currency:completedPayment.currencyCode email:email details:@"" orderNumber:[completedPayment.confirmation[@"response"] objectForKey:@"id"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            if (!error) {
                if ([dictionary[@"success"] boolValue]) {
                }
                SuccessViewController *successViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SuccessViewControllerIdentifier"];
                [self.navigationController pushViewController:successViewController animated:YES];

            } else {
                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];

    }];
}

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
    
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
//    if (!self.toPublish) {
        self.tabBarController.tabBar.hidden = NO;
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
    
}



- (NSString*)htmlToText:(NSString*)htmlString {
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&gt;"  withString:@">"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&quot;" withString:@""""];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#039;"  withString:@"'"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    return htmlString;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    if (!self.toPublish) {
        self.tabBarController.tabBar.hidden = NO;
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if (!self.toPublish) {
        self.tabBarController.tabBar.hidden = YES;
//    }
}

- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonTapped:(id)sender {
    NSString *textToShare = @"";
    NSURL *myWebsite = [NSURL URLWithString:[NSString stringWithFormat:@"https://anuntul.co.uk/%@.html",self.adDetails[@"permalink"]]];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo,
                                   UIActivityTypePostToTwitter,
                                   UIActivityTypePostToTencentWeibo,
                                   UIActivityTypeOpenInIBooks];
    
    activityVC.excludedActivityTypes = excludeActivities;
    NSString *reqSysVer = @"8";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending) {
        if ( [activityVC respondsToSelector:@selector(popoverPresentationController)] ) {
            // iOS8
            activityVC.popoverPresentationController.sourceView = self.view;
        }
    }
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.toPublish) {
        self.navigationItem.title = @"Detalii anunț";
    } else {
        self.navigationItem.title = @"Previzualizare";
    }
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 15) ];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem1 = [[UIBarButtonItem alloc]
                                           initWithCustomView:backButton];
    [leftBarButtonItem1 setTintColor:[UIColor blackColor]];
    
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem1;
    if (!self.toPublish) {
        UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 16) ];
        [shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem1 = [[UIBarButtonItem alloc]
                                                initWithCustomView:shareButton];
        [rightBarButtonItem1 setTintColor:[UIColor blackColor]];
        
        //set the action for button
        
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem1;
    }


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRoot:) name:@"PopToRoot" object:nil];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    if (!self.scrollView) {
        NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.userInteractionEnabled = YES;
        [self.view addSubview:self.scrollView];
        
    }
    
    if (!self.titleLabel) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        [self.scrollView addSubview:self.titleLabel];
    }
    self.titleLabel.text = [NSString removeCharacterFromString:self.adDetails[@"titlu"]];
    self.titleLabel.textColor = [HXColor hx_colorWithHexString:@"222"];
    self.titleLabel.numberOfLines = 0;
    
    [self updateTitle];
    
    if (!self.viewsLabel) {
        self.viewsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.viewsLabel.font = [UIFont systemFontOfSize:15];
        [self.scrollView addSubview:self.viewsLabel];
    }
    
    
    
    
    if (!self.toPublish) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        NSString *currentDateString = self.adDetails[@"timp"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
        NSDate *currentDate = [dateFormatter dateFromString:currentDateString];
        
        NSLog(@"CurrentDate:%@", currentDate);
        [dateFormatter setDateFormat:@"dd MMM yyyy', 'hh:mm"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
//
//        
        if ([[self.adDetails[@"location"] objectForKey:@"titlu"] length]) {
            self.viewsLabel.text = [NSString stringWithFormat:@"%@, %@, %@ afisari",[self.adDetails[@"location"] objectForKey:@"titlu"], dateString, self.adDetails[@"afisari"]];
        } else {
            self.viewsLabel.text = [NSString stringWithFormat:@"%@, %@ afisari", dateString, self.adDetails[@"afisari"]];
        }
    } else {
        if ([self.adDetails[@"city"] length]) {
            self.viewsLabel.text = [NSString stringWithFormat:@"%@, %@, %@ afisari",self.adDetails[@"city"], self.adDetails[@"timp"], self.adDetails[@"afisari"]];
        } else {
            self.viewsLabel.text = [NSString stringWithFormat:@"%@, %@ afisari", self.adDetails[@"timp"], self.adDetails[@"afisari"]];
        }
    }
    self.viewsLabel.textColor = [HXColor hx_colorWithHexString:@"929292"];
//
    if ([self.adDetails[@"images"] count]) {
        if (!self.collectionView) {
            UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.minimumLineSpacing = 0;
            layout.minimumInteritemSpacing = 0;
            self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];

            self.collectionView.pagingEnabled = YES;
            [self.collectionView setDataSource:self];
            [self.collectionView setDelegate:self];
            
//            [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
            [self.collectionView setBackgroundColor:[UIColor clearColor]];
            [self.collectionView registerClass:[PhotoGalleryCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoGalleryCollectionViewCellIdentifier"];
            
            [self.scrollView addSubview:self.collectionView];
        }
    }
    if (self.collectionView) {
        if (!self.pageControl) {
            self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
            self.pageControl.numberOfPages = [self.adDetails[@"images"] count];
            self.pageControl.currentPage = 0;
            self.pageControl.backgroundColor = [UIColor hx_colorWithHexString:@"929292"];
//            self.pageControl.alpha = f;
            [self.scrollView addSubview:self.pageControl];
        }
    }
//
    if (!self.descriptionLabel) {
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.descriptionLabel.textAlignment = NSTextAlignmentJustified;
        [self.scrollView addSubview:self.descriptionLabel];
    }
//    self.descriptionLabel.text = self.adDetails[@"descriere"];
    NSString *descriptionText = self.adDetails[@"descriere"];
    descriptionText = [NSString removeCharacterFromString:descriptionText];
    NSString *searchedString = [self findStringInDescription:descriptionText];
    if (searchedString) {
        descriptionText = [descriptionText stringByReplacingOccurrencesOfString:searchedString withString:@""];
    }
    //    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"U00c8" withString:@"asd"];
//    descriptionText = [descriptionText stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

//    NSString *str = [NSString stringWithCharacters:"\U00c8" length:1];
    self.descriptionLabel.text = descriptionText;
    self.descriptionLabel.numberOfLines = 0;
    
    [self updateDescription];
    
    if (!self.usernameLabel) {
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.scrollView addSubview:self.usernameLabel];
    }
    self.usernameLabel.text = [NSString stringWithFormat:@"Publicat de: %@", [self.adDetails[@"user"] objectForKey:@"nume"]];
    self.usernameLabel.textColor = [HXColor hx_colorWithHexString:@"929292"];
    self.usernameLabel.font = [UIFont systemFontOfSize:15];

    
    if (!self.createdAtLabel) {
        self.createdAtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.scrollView addSubview:self.createdAtLabel];
    }
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    NSString *registeredDateString = [self.adDetails[@"user"] objectForKey:@"data_inreg"];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    NSDate *registeredDate = [dateFormatter2 dateFromString:registeredDateString];
    
    [dateFormatter2 setDateFormat:@"dd-MM-yyyy"];
    NSString *newDateString = [dateFormatter2 stringFromDate:registeredDate];
//    self.registeredLabel.text = [NSString stringWithFormat:@"Inregistrat pe %@",newDateString];
    self.createdAtLabel.text = [NSString stringWithFormat:@"Membru din: %@", newDateString];
    self.createdAtLabel.textColor = [HXColor hx_colorWithHexString:@"929292"];
    self.createdAtLabel.font = [UIFont systemFontOfSize:15];


    
    if (!self.separator1) {
        self.separator1 = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.separator1.backgroundColor = [HXColor hx_colorWithHexString:@"929292"];
        [self.scrollView addSubview:self.separator1];
    }
    
    if (!self.adIdLabel) {
        self.adIdLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.adIdLabel.textColor = [HXColor hx_colorWithHexString:@"929292"];
        self.adIdLabel.textAlignment = NSTextAlignmentLeft;
        self.adIdLabel.font = [UIFont systemFontOfSize:15];
        [self.scrollView addSubview:self.adIdLabel];
    }
    self.adIdLabel.text = [NSString stringWithFormat:@"ID %@",self.adDetails[@"id_anunt"]];
    
    if (!self.reportButton) {
        self.reportButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.reportButton setTitleColor:[HXColor hx_colorWithHexString:@"f50000"] forState:UIControlStateNormal];
        self.reportButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.reportButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.reportButton addTarget:self action:@selector(reportButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:self.reportButton];
    }
    [self.reportButton setTitle:@"Raportează" forState:UIControlStateNormal];
    
    if (!self.separator2) {
        self.separator2 = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.separator2.backgroundColor = [HXColor hx_colorWithHexString:@"929292"];
        [self.scrollView addSubview:self.separator2];
    }
    
    if (!self.buttonsView) {
        self.buttonsView = [[UIView alloc] initWithFrame:CGRectZero];
        if (!self.toPublish) {
            [self.buttonsView setBackgroundColor:[UIColor whiteColor]];
            [self.view addSubview:self.buttonsView];

        } else {
            [self.buttonsView setBackgroundColor:[UIColor clearColor]];
            [self.scrollView addSubview:self.buttonsView];
        }
    }
    
    if ([[self.adDetails[@"user"] objectForKey:@"email"] length]) {
        if (!self.emailButton) {
            self.emailButton = [[UIButton alloc] initWithFrame:CGRectZero];
            [self.emailButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [self.emailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.emailButton addTarget:self action:@selector(emailButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonsView addSubview:self.emailButton];
        }
    }
    if ([self.adDetails[@"telefon1"] length]) {
        if (!self.phoneNumberButton) {
            self.phoneNumberButton = [[UIButton alloc] initWithFrame:CGRectZero];
            [self.phoneNumberButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [self.phoneNumberButton addTarget:self action:@selector(phoneNumberTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self.phoneNumberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.buttonsView addSubview:self.phoneNumberButton];
        }
    }
    
    
    //    [self.emailButton setTitle:[self.adDetails[@"user"] objectForKey:@"email"] forState:UIControlStateNormal];
    [self.emailButton setTitle:@"Email" forState:UIControlStateNormal];
    //    [self.phoneNumberButton setTitle:[self.adDetails[@"user"] objectForKey:@"telefon"] forState:UIControlStateNormal];
    [self.phoneNumberButton setTitle:@"Telefon" forState:UIControlStateNormal];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.titleLabel.frame) + CGRectGetHeight(self.descriptionLabel.frame) + CGRectGetHeight(self.emailButton.frame) + CGRectGetHeight(self.phoneNumberButton.frame) + 100);
    
//    if ([self.adDetails[@"images"] count] == 0) {
//        self.imageView1 = nil;
//        self.imageView2 = nil;
//        self.imageView3 = nil;
//    } else if ([self.adDetails[@"images"] count] == 1) {
//        self.imageView1 = nil;
//        self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
//        self.imageView2.image = [UIImage imageNamed:@"no-image"];
//        self.imageView3 = nil;
//        UITapGestureRecognizer *imageGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImages:)];
//        [self.imageView2 addGestureRecognizer:imageGesture2];
//        self.imageView2.userInteractionEnabled = YES;
//        [self.scrollView addSubview:self.imageView2];
//    } else if ([self.adDetails[@"images"] count] == 2) {
//        self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
//        self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
//        self.imageView1.image = [UIImage imageNamed:@"no-image"];
//        self.imageView2.image = [UIImage imageNamed:@"no-image"];
//        self.imageView3 = nil;
//        UITapGestureRecognizer *imageGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImages:)];
//        [self.imageView1 addGestureRecognizer:imageGesture1];
//        UITapGestureRecognizer *imageGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImages:)];
//        [self.imageView2 addGestureRecognizer:imageGesture2];
//        self.imageView1.userInteractionEnabled = YES;
//        self.imageView2.userInteractionEnabled = YES;
//        [self.scrollView addSubview:self.imageView1];
//        [self.scrollView addSubview:self.imageView2];
//    } else if ([self.adDetails[@"images"] count] >= 3) {
//        self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
//        self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
//        self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectZero];
//        self.imageView1.image = [UIImage imageNamed:@"no-image"];
//        self.imageView2.image = [UIImage imageNamed:@"no-image"];
//        self.imageView3.image = [UIImage imageNamed:@"no-image"];
//        UITapGestureRecognizer *imageGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImages:)];
//        [self.imageView1 addGestureRecognizer:imageGesture1];
//        UITapGestureRecognizer *imageGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImages:)];
//        [self.imageView2 addGestureRecognizer:imageGesture2];
//        UITapGestureRecognizer *imageGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImages:)];
//        [self.imageView3 addGestureRecognizer:imageGesture3];
//        self.imageView1.userInteractionEnabled = YES;
//        self.imageView2.userInteractionEnabled = YES;
//        self.imageView3.userInteractionEnabled = YES;
//        [self.scrollView addSubview:self.imageView1];
//        [self.scrollView addSubview:self.imageView2];
//        [self.scrollView addSubview:self.imageView3];
//    }
    
    if (self.toPublish) {
        self.publishButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.publishButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.publishButton addTarget:self action:@selector(publishButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:self.publishButton];
    }
    [self.publishButton setTitle:@"Publică anunț" forState:UIControlStateNormal];
    [self.publishButton setBackgroundColor:[HXColor hx_colorWithHexString:@"2299c3"]];
    self.publishButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    // Do any additional setup after loading the view.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.adDetails[@"images"] count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoGalleryCollectionViewCell *cell = (PhotoGalleryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoGalleryCollectionViewCellIdentifier" forIndexPath:indexPath];
    
    if (!cell) {
        cell = (PhotoGalleryCollectionViewCell *)[[PhotoGalleryCollectionViewCell alloc] initWithFrame:self.collectionView.bounds];
    }
    NSDictionary *image = [self.adDetails[@"images"] objectAtIndex:indexPath.row];
    [cell loadImageWithInfo:image isFullScreen:NO];
    [cell layoutSubviews];
    self.pageControl.currentPage = indexPath.row;
    
    return cell;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size =  self.collectionView.frame.size;
//    size.width -= 10;
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.toPublish) {
        NSArray *imagesArray = [self.adDetails objectForKey:@"images"];
        PhotoGalleryViewController *photoGalleryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoGalleryViewControllerIdentifier"];
        photoGalleryViewController.imagesArray = imagesArray;
        [self.navigationController pushViewController:photoGalleryViewController animated:YES];
    }

}

- (void)openImages:(UIGestureRecognizer *)gesture {
    NSArray *imagesArray = [self.adDetails objectForKey:@"images"];
    PhotoGalleryViewController *photoGalleryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoGalleryViewControllerIdentifier"];
    photoGalleryViewController.imagesArray = imagesArray;
    [self.navigationController pushViewController:photoGalleryViewController animated:YES];
}

- (void)reportButtonTapped:(id)sender {
    EmailViewController *emailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmailViewControllerIdentifier"];
    emailViewController.fieldType = REPORT;
    emailViewController.announcementId = self.adDetails[@"id_anunt"];
    [self.navigationController pushViewController:emailViewController animated:YES];
}

- (void)userImageViewTapped:(UIGestureRecognizer *)tapGesture {
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    [[WebServiceManager sharedInstance] getAdsForUser:[self.adDetails[@"user"] objectForKey:@"id_user"] withPageNumber:[NSNumber numberWithInteger:1] withCompletionBlock:^(NSArray *array, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!error) {
            LocationAdsViewController *locationAdsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationAdsViewControllerIdentifier"];
            locationAdsViewController.locationAds = [NSMutableArray arrayWithArray:array];
            locationAdsViewController.locationId = [self.adDetails[@"user"] objectForKey:@"id_user"];
            locationAdsViewController.locationTitle = [self.adDetails[@"user"] objectForKey:@"nume"];
            locationAdsViewController.isLocations = NO;
            locationAdsViewController.isMyProfile = NO;
            [self.navigationController pushViewController:locationAdsViewController animated:YES];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

-(CGFloat) getHeightForText:(NSString*) text withFont:(UIFont*) font andWidth:(float) width{
    CGSize constraint = CGSizeMake(width , 20000.0f);
    CGSize title_size;
    float totalHeight;
    
    SEL selector = @selector(boundingRectWithSize:options:attributes:context:);
    if ([text respondsToSelector:selector]) {
        title_size = [text boundingRectWithSize:constraint
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{ NSFontAttributeName : font }
                                        context:nil].size;
        
        totalHeight = ceil(title_size.height);
    } else {
        //        title_size = [text sizeWithFont:font
        //                      constrainedToSize:constraint
        //                          lineBreakMode:NSLineBreakByWordWrapping];
        CGRect rect = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil];
        totalHeight = rect.size.height ;
    }
    
    CGFloat height = MAX(totalHeight, 40.0f);
    return height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)phoneNumberTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.adDetails[@"telefon1"]]]];
}

#pragma mark MFMailComposeViewControllerDelegate methods

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled"); break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved"); break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent"); break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]); break;
        default:
            break;
    }
    
    // close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)emailButtonTapped:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    if ([userDefaults objectForKey:@"email"]) {
//        EmailViewController *emailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmailViewControllerIdentifier"];
//        NSDictionary *emailInfo = [NSDictionary dictionaryWithObjectsAndKeys:[userDefaults objectForKey:@"email"],@"email",self.adDetails[@"id_anunt"], @"id_anunt", nil];
//        emailViewController.fieldType = SEND_EMAIL;
//        emailViewController.emailInfo = emailInfo;
//        [self.navigationController pushViewController:emailViewController animated:YES];
//    } else if ([userDefaults objectForKey:@"facebookEmail"]) {
        EmailViewController *emailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmailViewControllerIdentifier"];
        NSDictionary *emailInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"email",self.adDetails[@"id_anunt"], @"id_anunt", nil];
        emailViewController.emailInfo = emailInfo;
        emailViewController.fieldType = SEND_EMAIL;
        [self.navigationController pushViewController:emailViewController animated:YES];
        
//    } else {
//        [[[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Pentru a trimite e-mail, trebuie sa va logati" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//    }
//    NSString * subject = @"";
//    //email body
//    NSString * body = @"";
//    //recipient(s)
//    NSArray * recipients = [NSArray arrayWithObjects:[self.adDetails[@"user"] objectForKey:@"email"], nil];
//    
//    //create the MFMailComposeViewController
//    MFMailComposeViewController * composer = [[MFMailComposeViewController alloc] init];
//    composer.mailComposeDelegate = self;
//    [composer setSubject:subject];
//    [composer setMessageBody:body isHTML:YES];
//    //[composer setMessageBody:body isHTML:YES]; //if you want to send an HTML message
//    [composer setToRecipients:recipients];
//    
//    //get the filepath from resources
//    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
//    
//    //read the file using NSData
//    //    NSData * fileData = [NSData dataWithContentsOfFile:filePath];
//    //    NSString *mimeType = @"image/png";
//    
//    //add attachement
//    //    [composer addAttachmentData:fileData mimeType:mimeType fileName:filePath];
//    
//    //present it on the screen
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
//    [self presentViewController:composer animated:YES completion:^{
//        [hud hide:YES];
//    }];
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
