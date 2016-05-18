//
//  AnnouncementTypesViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 23/02/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "AnnouncementTypesViewController.h"
#import "MBProgressHUD.h"
#import "WebServiceManager.h"
#import "AnnouncementTableViewCell.h"
#import "CreateAnnouncementViewController.h"
#import "HexColors.h"
#import "MenuTableViewController.h"
#import "PayPalMobile.h"
#import "NSString+RemovedCharacters.h"

#define kPayPalEnvironment PayPalEnvironmentProduction


@interface AnnouncementTypesViewController()<UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate,PayPalFuturePaymentDelegate, PayPalPaymentDelegate> {
    NSArray *announcementTypes;
    NSIndexPath *_indexPath;
    
}

@property (nonatomic, strong) PayPalConfiguration *paypalConfig;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AnnouncementTypesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAnnouncementTypes:) name:@"Get Announcement Types" object:nil];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    [[WebServiceManager sharedInstance] getAnnouncementsTypeWithCompletionBlock:^(NSArray *array, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!error) {
            announcementTypes = array;
            [self.tableView reloadData];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
    self.navigationItem.title = @"Alege tip anunț";
    self.tabBarController.navigationItem.title = @"Alege tip anunț";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    if (self.republishedAnnouncement) {
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 15) ];
        [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButtonItem1 = [[UIBarButtonItem alloc]
                                               initWithCustomView:backButton];
        [leftBarButtonItem1 setTintColor:[UIColor blackColor]];
        
        //set the action for button
        
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem1;

    }

}

- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)getAnnouncementTypes:(NSNotification *)notification {
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    [[WebServiceManager sharedInstance] getAnnouncementsTypeWithCompletionBlock:^(NSArray *array, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!error) {
            announcementTypes = array;
            [self.tableView reloadData];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return announcementTypes.count;
}

//- (CGFloat)updateDescriptionWithIndexpath:(NSIndexPath *)indexpath {
//    if (announcementTypes) {
//        AnnouncementTableViewCell *cell = (AnnouncementTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexpath];
//        CGRect descriptionFrame = cell.adDescription.frame;
//        NSDictionary *announcementType = [announcementTypes objectAtIndex:indexpath.row];
//        float descriptionHeight = [self getHeightForText:announcementType[@"descriere"]
//                                                withFont:cell.adDescription.font
//                                                andWidth:cell.adDescription.frame.size.width];
//
//        cell.adDescription.frame = CGRectMake(descriptionFrame.origin.x,
//                                              descriptionFrame.origin.y,
//                                              descriptionFrame.size.width,
//                                              descriptionHeight);
//        return cell.adDescription.frame.size.height;
//    }
//    return 0;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [self updateDescriptionWithIndexpath:indexPath];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnnouncementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementTableViewCellIdentifier"];
    if (!cell) {
        cell = [[AnnouncementTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AnnouncementTableViewCellIdentifier"];
    }
    NSDictionary *announcementType = [announcementTypes objectAtIndex:indexPath.row];
    cell.adTitle.text = announcementType[@"titlu"];
    cell.priceLabel.text = [NSString stringWithFormat:@"£%@",announcementType[@"amount"]];
    //    cell.adDescription.text = announcementType[@"descriere"];
//    NSError *err = nil;
//    cell.descriptionWidthConstraint.constant = CGRectGetWidth(self.view.frame) - 20;
//    [self.view layoutIfNeeded];
//    cell.adDescription.attributedText =
//    [[NSAttributedString alloc]
//     initWithData: [announcementType[@"descriere"] dataUsingEncoding:NSUTF8StringEncoding]
//     options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
//     documentAttributes: nil
//     error: &err];
    
    [cell.descriptionWebView loadHTMLString:[NSString removeCharacterFromString:announcementType[@"descriere"]] baseURL:nil];

    cell.descriptionWebView.delegate = self;
    cell.descriptionWebView.scrollView.scrollEnabled = NO;
    cell.descriptionWebView.userInteractionEnabled = NO;
    cell.descriptionWebView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.descriptionWebView setDataDetectorTypes:UIDataDetectorTypeNone];
    cell.descriptionWebView.opaque = NO;
//    cell.descriptionWebView.scrollView.bounces = NO;
    //    cell.adDescription.text = @"sdfjsdfjhsldjf lskjdhflskhflshfsd lsdfhjlisdhfoish lsfjhlsidjhfl s lsfsldifhsld slhslf ";
    //    [cell createCellWithInfo:announcementType];
    return cell;
}


- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    aWebView.frame = frame;
    
    NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
    [aWebView stringByEvaluatingJavaScriptFromString:@"document.styleSheets[0].addRule(\"a.link\", \"color:#FF0000\")"];
    [aWebView stringByEvaluatingJavaScriptFromString:@"document.styleSheets[0].addRule(\".active\", \"pointer-events: none;\");document.styleSheets[0].addRule(\".active\", \"cursor: default;\")"];


}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString rangeOfString:@"tel"].location != NSNotFound) {
        return NO;
    }
    if ([request.URL.absoluteString rangeOfString:@"http://"].location != NSNotFound) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
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
//    NSString *string = @"Alege tip anunt";
//    /* Section header is in 0th index... */
//    [label setText:string];
//    //    [label setTextColor:[UIColor colorFromHexString:@"c1c1c1"]];
//    [label setTextColor:[HXColor hx_colorWithHexString:@"c1c1c1"]];
//    [view addSubview:label];
//    //    [view setBackgroundColor:[UIColor colorFromHexString:@"f1eef1"]];
//    [view setBackgroundColor:[HXColor hx_colorWithHexString:@"f1eef1"]];
//    return view;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *announcementType = [announcementTypes objectAtIndex:indexPath.row];
//    if (indexPath.row == 0) {
    CreateAnnouncementViewController *createAnnouncement = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateAnnouncementViewControllerIdentifier"];
    createAnnouncement.announcementType = announcementType;
    createAnnouncement.republishedAnnouncement = self.republishedAnnouncement;
    [self.navigationController pushViewController:createAnnouncement animated:YES];
//    } else {
//        
//        _indexPath = indexPath;
//        _paypalConfig = [[PayPalConfiguration alloc] init];
//        _paypalConfig.acceptCreditCards = YES;
//        _paypalConfig.merchantName = @"Anuntul de UK";
//        _paypalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
//        _paypalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
//        
//        _paypalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
//        
//        _paypalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionNone;
//        [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentNoNetwork];
//        
//        PayPalItem *item1 = [PayPalItem itemWithName:announcementType[@"titlu"] withQuantity:1 withPrice:[NSDecimalNumber decimalNumberWithString:announcementType[@"amount"]] withCurrency:@"GBP" withSku:announcementType[@"titlu"]];
//        NSArray *items = @[item1];
//        NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
//        
//        // Optional: include payment details
//        NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0"];
//        NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0"];
//        PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
//                                                                                   withShipping:shipping
//                                                                                        withTax:tax];
//        
//        NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
//        
//        PayPalPayment *payment = [[PayPalPayment alloc] init];
//        payment.amount = total;
//        payment.currencyCode = @"GBP";
//        payment.shortDescription = announcementType[@"titlu"];
//        payment.items = items;  // if not including multiple items, then leave payment.items as nil
//        payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
//        _paypalConfig.acceptCreditCards = YES;
//        
//        PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:_paypalConfig delegate:self];
//        [self presentViewController:paymentViewController animated:YES completion:nil];
//    }
}

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    //    self.resultText = [completedPayment description];
    
    
    //    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:^{
        NSDictionary *announcementType = [announcementTypes objectAtIndex:_indexPath.row];
        CreateAnnouncementViewController *createAnnouncement = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateAnnouncementViewControllerIdentifier"];
        createAnnouncement.announcementType = announcementType;
        createAnnouncement.paypalPayment = completedPayment;
        [self.navigationController pushViewController:createAnnouncement animated:YES];

    }];
}

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
    
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
    
}


@end
