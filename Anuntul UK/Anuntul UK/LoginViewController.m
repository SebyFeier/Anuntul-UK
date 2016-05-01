//
//  LoginViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 30/01/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MenuTableViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "UIView+Borders.h"
#import "WebServiceManager.h"
#import "MBProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>
#import "LocationAdsViewController.h"
#import "Haneke.h"
#import "HexColors.h"
#import "WebViewViewController.h"
#import "EmailViewController.h"


@interface LoginViewController ()<UITextFieldDelegate, FBSDKLoginButtonDelegate> {
    NSDictionary *userInfo;
}

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UITextField *accountUsernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountConfirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTelephoneTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *registeredLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;
@property (weak, nonatomic) IBOutlet UIButton *myProfileButton;
@property (weak, nonatomic) IBOutlet UIButton *myAnnouncements;
@property (weak, nonatomic) IBOutlet UIButton *faqButton;
@property (weak, nonatomic) IBOutlet UIButton *termsOfUseButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *confidentialityButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.widthConstraint.constant = CGRectGetWidth(self.view.frame) - 15;

    self.navigationItem.title = @"Contul meu";
    self.tabBarController.navigationItem.title = @"Contul meu";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.myProfileButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [self.myAnnouncements setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [self.faqButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [self.termsOfUseButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [self.logoutButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [self.confidentialityButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [self.contactButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    self.myProfileButton.layer.masksToBounds = NO;
    self.myProfileButton.layer.shadowColor = [UIColor hx_colorWithHexString:@"BFBFBF"].CGColor;
    self.myProfileButton.layer.shadowOpacity = 0.8;
    self.myProfileButton.layer.shadowRadius = 5;
    self.myProfileButton.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    self.myAnnouncements.layer.masksToBounds = NO;
    self.myAnnouncements.layer.shadowColor = [UIColor hx_colorWithHexString:@"BFBFBF"].CGColor;
    self.myAnnouncements.layer.shadowOpacity = 0.8;
    self.myAnnouncements.layer.shadowRadius = 5;
    self.myAnnouncements.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    self.faqButton.layer.masksToBounds = NO;
    self.faqButton.layer.shadowColor = [UIColor hx_colorWithHexString:@"BFBFBF"].CGColor;
    self.faqButton.layer.shadowOpacity = 0.8;
    self.faqButton.layer.shadowRadius = 5;
    self.faqButton.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    self.termsOfUseButton.layer.masksToBounds = NO;
    self.termsOfUseButton.layer.shadowColor = [UIColor hx_colorWithHexString:@"BFBFBF"].CGColor;
    self.termsOfUseButton.layer.shadowOpacity = 0.8;
    self.termsOfUseButton.layer.shadowRadius = 5;
    self.termsOfUseButton.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    self.confidentialityButton.layer.masksToBounds = NO;
    self.confidentialityButton.layer.shadowColor = [UIColor hx_colorWithHexString:@"BFBFBF"].CGColor;
    self.confidentialityButton.layer.shadowOpacity = 0.8;
    self.confidentialityButton.layer.shadowRadius = 5;
    self.confidentialityButton.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    self.contactButton.layer.masksToBounds = NO;
    self.contactButton.layer.shadowColor = [UIColor hx_colorWithHexString:@"BFBFBF"].CGColor;
    self.contactButton.layer.shadowOpacity = 0.8;
    self.contactButton.layer.shadowRadius = 5;
    self.contactButton.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    self.logoutButton.layer.masksToBounds = NO;
    self.logoutButton.layer.shadowColor = [UIColor hx_colorWithHexString:@"BFBFBF"].CGColor;
    self.logoutButton.layer.shadowOpacity = 0.8;
    self.logoutButton.layer.shadowRadius = 5;
    self.logoutButton.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
//    self.myProfileButton.layer.cornerRadius = 10; // this value vary as per your desire
//    self.myProfileButton.clipsToBounds = YES;
//    self.myAnnouncements.layer.cornerRadius = 10; // this value vary as per your desire
//    self.myAnnouncements.clipsToBounds = YES;
//    self.faqButton.layer.cornerRadius = 10; // this value vary as per your desire
//    self.faqButton.clipsToBounds = YES;
//    self.termsOfUseButton.layer.cornerRadius = 10; // this value vary as per your desire
//    self.termsOfUseButton.clipsToBounds = YES;
//    self.logoutButton.layer.cornerRadius = 10; // this value vary as per your desire
//    self.logoutButton.clipsToBounds = YES;
//    self.confidentialityButton.layer.cornerRadius = 10; // this value vary as per your desire
//    self.confidentialityButton.clipsToBounds = YES;
//    self.contactButton.layer.cornerRadius = 10; // this value vary as per your desire
//    self.contactButton.clipsToBounds = YES;
    UIColor *color = [UIColor hx_colorWithHexString:@"BFBFBF"];
    [self.emailTextField addBottomBorderWithHeight:1 andColor:color];
    [self.passwordTextField addBottomBorderWithHeight:1 andColor:color];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.tabBarController.navigationItem.hidesBackButton = YES;
    self.buttonTopConstraint.constant = [[WebServiceManager sharedInstance] topConstraint];
    [self.view layoutIfNeeded];
    
    UIColor *color = [UIColor hx_colorWithHexString:@"BFBFBF"];
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"E-mail" attributes:@{NSForegroundColorAttributeName:color}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Parolă" attributes:@{NSForegroundColorAttributeName:color}];

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"email"] && [userDefaults objectForKey:@"password"]) {
        self.loginView.hidden = YES;
        self.accountView.hidden = NO;
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        [[WebServiceManager sharedInstance] loginWithEmail:[userDefaults objectForKey:@"email"]  andPassword:[self md5:[userDefaults objectForKey:@"password"]] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            if (!error) {
                if (!dictionary[@"failed"]) {
                    userInfo = dictionary;
                    self.loginView.hidden = YES;
                    self.accountView.hidden = NO;
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:[userDefaults objectForKey:@"email"] forKey:@"email"];
                    [userDefaults setObject:[userDefaults objectForKey:@"password"] forKey:@"password"];
                    [userDefaults setObject:[userDefaults objectForKey:@"facebookName"] forKey:@"facebookName"];
                    [userDefaults setObject:[userDefaults objectForKey:@"id_user"] forKey:@"id_user"];
                    [userDefaults synchronize];
                    self.accountUsernameTextField.text = dictionary[@"nume"];
                    self.accountTelephoneTextField.text = dictionary[@"telefon"];
                    self.accountPasswordTextField.text = @"";
                    self.accountConfirmPasswordTextField.text = @"";
                    self.usernameLabel.text = dictionary[@"nume"];
                    
                    if (dictionary[@"avatar"] && ![dictionary[@"avatar"] isEqual:[NSNull null]]) {
                        [self.userImageView hnk_setImageFromURL:[NSURL URLWithString:dictionary[@"avatar"]]];
                    } else {
                        [self.userImageView setImage:[UIImage imageNamed:@"no-image"]];
                    }
                    
                    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
                    NSString *registeredDateString = dictionary[@"data_inreg"];
                    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
                    NSDate *registeredDate = [dateFormatter2 dateFromString:registeredDateString];
                    
                    [dateFormatter2 setDateFormat:@"dd MMM yyyy"];
                    NSString *newDateString = [dateFormatter2 stringFromDate:registeredDate];
                    self.registeredLabel.text = [NSString stringWithFormat:@"Inregistrat pe %@",newDateString];
                    if ([dictionary objectForKey:@"ultima_logare"] && ![[dictionary objectForKey:@"ultima_logare"] isEqual:[NSNull null]]) {
                        
                        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
                        NSString *registeredDateString = [dictionary objectForKey:@"ultima_logare"];
                        [dateFormatter2 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
                        NSDate *registeredDate = [dateFormatter2 dateFromString:registeredDateString];
                        
                        [dateFormatter2 setDateFormat:@"dd MMM yyyy"];
                        NSString *newDateString = [dateFormatter2 stringFromDate:registeredDate];
                        self.onlineLabel.text = [NSString stringWithFormat:@"Online pe %@", newDateString];
                    }
                    [self.loginView setHidden:YES];
                    [self.accountView setHidden:NO];
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"Eroare" message:dictionary[@"failed"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
        
    } else if ([userDefaults objectForKey:@"facebookEmail"]) {
        self.loginView.hidden = YES;
        self.accountView.hidden = NO;
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        [[WebServiceManager sharedInstance] loginWithFacebookId:[userDefaults objectForKey:@"facebookId"] email:[userDefaults objectForKey:@"facebookEmail"] name:[userDefaults objectForKey:@"facebookName"] image:[userDefaults objectForKey:@"facebookImage"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            if (!error) {
                if (!dictionary[@"failed"]) {
                    userInfo = dictionary;
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:[userDefaults objectForKey:@"facebookEmail"] forKey:@"facebookEmail"];
                    [userDefaults setObject:[userDefaults objectForKey:@"facebookName"] forKey:@"facebookName"];
                    [userDefaults setObject:[userDefaults objectForKey:@"facebookId"] forKey:@"facebookId"];
                    [userDefaults setObject:[userDefaults objectForKey:@"facebookImage"] forKey:@"facebookImage"];
                    [userDefaults setObject:[userDefaults objectForKey:@"id_user"] forKey:@"id_user"];

                    [userDefaults synchronize];
                    self.emailTextField.text = @"";
                    self.passwordTextField.text = @"";
                    self.accountUsernameTextField.text = dictionary[@"nume"];
                    self.accountTelephoneTextField.text = dictionary[@"telefon"];
                    self.accountPasswordTextField.text = @"";
                    self.accountConfirmPasswordTextField.text = @"";
                    self.usernameLabel.text = dictionary[@"nume"];
                    if (dictionary[@"avatar"] && ![dictionary[@"avatar"] isEqual:[NSNull null]]) {
                        [self.userImageView hnk_setImageFromURL:[NSURL URLWithString:dictionary[@"avatar"]]];
                    } else {
                        [self.userImageView setImage:[UIImage imageNamed:@"no-image"]];
                    }
                    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
                    NSString *registeredDateString = dictionary[@"data_inreg"];
                    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
                    NSDate *registeredDate = [dateFormatter2 dateFromString:registeredDateString];
                    
                    [dateFormatter2 setDateFormat:@"dd MMM yyyy"];
                    NSString *newDateString = [dateFormatter2 stringFromDate:registeredDate];
                    self.registeredLabel.text = [NSString stringWithFormat:@"Inregistrat pe %@",newDateString];            if ([dictionary objectForKey:@"ultima_logare"] && ![[dictionary objectForKey:@"ultima_logare"] isEqual:[NSNull null]]) {
                        
                        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
                        NSString *registeredDateString = [dictionary objectForKey:@"ultima_logare"];
                        [dateFormatter2 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
                        NSDate *registeredDate = [dateFormatter2 dateFromString:registeredDateString];
                        
                        [dateFormatter2 setDateFormat:@"dd MMM yyyy"];
                        NSString *newDateString = [dateFormatter2 stringFromDate:registeredDate];
                        self.onlineLabel.text = [NSString stringWithFormat:@"Online pe %@", newDateString];
                    }
                    
                    
                    //            self.registeredLabel.text
                    [self.loginView setHidden:YES];
                    [self.accountView setHidden:NO];
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"Eroare" message:dictionary[@"failed"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            }
        }];
    } else {
        self.accountView.hidden = YES;
        self.loginView.hidden = NO;
    }
}

- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self loginButtonTapped:nil];
    }
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)loginButtonTapped:(id)sender {
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    [[WebServiceManager sharedInstance] loginWithEmail:self.emailTextField.text  andPassword:[self md5:self.passwordTextField.text] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!error) {
            if (!dictionary[@"failed"]) {
                userInfo = dictionary;
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:self.emailTextField.text forKey:@"email"];
                [userDefaults setObject:self.passwordTextField.text forKey:@"password"];
                [userDefaults setObject:dictionary[@"id_user"] forKey:@"id_user"];
                [userDefaults setObject:dictionary[@"nume"] forKey:@"facebookName"];
                self.emailTextField.text = @"";
                self.passwordTextField.text = @"";
                [userDefaults synchronize];
                self.accountUsernameTextField.text = dictionary[@"nume"];
                self.accountTelephoneTextField.text = dictionary[@"telefon"];
                self.accountPasswordTextField.text = @"";
                self.accountConfirmPasswordTextField.text = @"";
                self.usernameLabel.text = dictionary[@"nume"];
                
                if (dictionary[@"avatar"] && ![dictionary[@"avatar"] isEqual:[NSNull null]]) {
                    [self.userImageView hnk_setImageFromURL:[NSURL URLWithString:dictionary[@"avatar"]]];
                } else {
                    [self.userImageView setImage:[UIImage imageNamed:@"no-image"]];
                }
                NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
                NSString *registeredDateString = dictionary[@"data_inreg"];
                [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
                NSDate *registeredDate = [dateFormatter2 dateFromString:registeredDateString];
                
                [dateFormatter2 setDateFormat:@"dd MMM yyyy"];
                NSString *newDateString = [dateFormatter2 stringFromDate:registeredDate];
                self.registeredLabel.text = [NSString stringWithFormat:@"Inregistrat pe %@",newDateString];            if ([dictionary objectForKey:@"ultima_logare"] && ![[dictionary objectForKey:@"ultima_logare"] isEqual:[NSNull null]]) {
                    
                    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
                    NSString *registeredDateString = [dictionary objectForKey:@"ultima_logare"];
                    [dateFormatter2 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
                    NSDate *registeredDate = [dateFormatter2 dateFromString:registeredDateString];
                    
                    [dateFormatter2 setDateFormat:@"dd MMM yyyy"];
                    NSString *newDateString = [dateFormatter2 stringFromDate:registeredDate];
                    self.onlineLabel.text = [NSString stringWithFormat:@"Online pe %@", newDateString];
                }
                
                
                //            self.registeredLabel.text
                [self.loginView setHidden:YES];
                [self.accountView setHidden:NO];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:dictionary[@"failed"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}
- (IBAction)registerButtonTapped:(id)sender {
    [self.view endEditing:YES];
    RegisterViewController *registerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewControllerIdentifier"];
    registerViewController.type = REGISTER;
    [self.navigationController pushViewController:registerViewController animated:YES];
}
- (IBAction)forgotPasswordButtonTapped:(id)sender {
    [self.view endEditing:YES];
    RegisterViewController *registerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewControllerIdentifier"];
    registerViewController.type = FORGOT;
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}
- (IBAction)facebookLoginButtonTapped:(id)sender {
//    [FBSDKAccessToken refreshCurrentAccessToken:^(FBSDKGraphRequestConnection *connection, id result, NSError *error){}

    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             if ([FBSDKAccessToken currentAccessToken]) {
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,name,picture.width(100).height(100), email"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result2, NSError *error) {
                     if (!error) {
                         NSString *nameOfLoginUser = [result2 valueForKey:@"name"];
                         NSString *imageStringOfLoginUser = [[[result2 valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
                         NSString *email = [result2 objectForKey:@"email"];
                         NSString *facebookId = [result2 objectForKey:@"id"];
                         [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
                         [[WebServiceManager sharedInstance] loginWithFacebookId:facebookId email:email name:nameOfLoginUser image:imageStringOfLoginUser withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                             [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                             if (!error) {
                                 if (!dictionary[@"failed"]) {
                                     userInfo = dictionary;
                                     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                     [userDefaults setObject:email forKey:@"facebookEmail"];
                                     [userDefaults setObject:nameOfLoginUser forKey:@"facebookName"];
                                     [userDefaults setObject:facebookId forKey:@"facebookId"];
                                     [userDefaults setObject:imageStringOfLoginUser forKey:@"facebookImage"];
                                     [userDefaults setObject:dictionary[@"id_user"] forKey:@"id_user"];

                                     [userDefaults synchronize];
                                     self.emailTextField.text = @"";
                                     self.passwordTextField.text = @"";
                                     self.accountUsernameTextField.text = dictionary[@"nume"];
                                     self.accountTelephoneTextField.text = dictionary[@"telefon"];
                                     self.accountPasswordTextField.text = @"";
                                     self.accountConfirmPasswordTextField.text = @"";
                                     self.usernameLabel.text = dictionary[@"nume"];
//                                     if (dictionary[@"avatar"] && ![dictionary[@"avatar"] isEqual:[NSNull null]]) {
//                                         [self.userImageView hnk_setImageFromURL:[NSURL URLWithString:dictionary[@"avatar"]]];
//                                     } else {
//                                         [self.userImageView setImage:[UIImage imageNamed:@"no-image"]];
//                                     }
                                     NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
                                     NSString *registeredDateString = dictionary[@"data_inreg"];
                                     [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
                                     NSDate *registeredDate = [dateFormatter2 dateFromString:registeredDateString];
                                     
                                     [dateFormatter2 setDateFormat:@"dd MMM yyyy"];
                                     NSString *newDateString = [dateFormatter2 stringFromDate:registeredDate];
                                     self.registeredLabel.text = [NSString stringWithFormat:@"Inregistrat pe %@",newDateString];            if ([dictionary objectForKey:@"ultima_logare"] && ![[dictionary objectForKey:@"ultima_logare"] isEqual:[NSNull null]]) {
                                         
                                         NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
                                         NSString *registeredDateString = [dictionary objectForKey:@"ultima_logare"];
                                         [dateFormatter2 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
                                         NSDate *registeredDate = [dateFormatter2 dateFromString:registeredDateString];
                                         
                                         [dateFormatter2 setDateFormat:@"dd MMM yyyy"];
                                         NSString *newDateString = [dateFormatter2 stringFromDate:registeredDate];
                                         self.onlineLabel.text = [NSString stringWithFormat:@"Online pe %@", newDateString];
                                     }
                                     
                                     
                                     //            self.registeredLabel.text
                                     [self.loginView setHidden:YES];
                                     [self.accountView setHidden:NO];
                                 } else {
                                     [[[UIAlertView alloc] initWithTitle:@"Eroare" message:dictionary[@"failed"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                 }
                             } else {
                                 [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                             }
                         }];
                         
                     }
                 }];
             }
             NSLog(@"Logged in");
         }
     }];
}
- (IBAction)saveButtonTapped:(id)sender {
    RegisterViewController *registerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewControllerIdentifier"];
    registerViewController.type = EDIT;
    registerViewController.userInfo = userInfo;
    [self.navigationController pushViewController:registerViewController animated:YES];
}
- (IBAction)myAdsButtonTapped:(id)sender {
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    [[WebServiceManager sharedInstance] getAdsForUser:[userInfo objectForKey:@"id_user"] withPageNumber:[NSNumber numberWithInteger:1] withCompletionBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            LocationAdsViewController *locationAdsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationAdsViewControllerIdentifier"];
            locationAdsViewController.locationAds = [NSMutableArray arrayWithArray:array];
            locationAdsViewController.locationId = [userInfo objectForKey:@"id_user"];
            locationAdsViewController.locationTitle = [userInfo objectForKey:@"nume"];
            locationAdsViewController.isLocations = NO;
            locationAdsViewController.isMyProfile = YES;
            [self.navigationController pushViewController:locationAdsViewController animated:YES];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
    
    
}
- (IBAction)logoutButtonTapped:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"email"];
    [userDefaults removeObjectForKey:@"password"];
    [userDefaults removeObjectForKey:@"facebookEmail"];
    [userDefaults removeObjectForKey:@"facebookName"];
    [userDefaults removeObjectForKey:@"facebookImage"];
    [userDefaults removeObjectForKey:@"facebookId"];
    [userDefaults synchronize];
    [self.loginView setHidden:NO];
    [self.accountView setHidden:YES];
}
- (IBAction)faqButtonTapped:(id)sender {
    WebViewViewController *webViewViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewViewControllerIdentifier"];
    webViewViewController.urlString = @"https://www.anuntul.co.uk/pagina/intrebari-si-raspunsuri/";
    [self.navigationController pushViewController:webViewViewController animated:YES];
}
- (IBAction)termsAndConditionsButtonTapped:(id)sender {
    WebViewViewController *webViewViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewViewControllerIdentifier"];
    webViewViewController.urlString = @"https://www.anuntul.co.uk/pagina/termeni-si-conditii/";
    [self.navigationController pushViewController:webViewViewController animated:YES];
}
- (IBAction)confidentialityButtonTapped:(id)sender {
    
    WebViewViewController *webViewViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewViewControllerIdentifier"];
    webViewViewController.urlString = @"https://www.anuntul.co.uk/pagina/confidentialitate/";
    [self.navigationController pushViewController:webViewViewController animated:YES];

}
- (IBAction)contactButtonTapped:(id)sender {
    EmailViewController *emailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmailViewControllerIdentifier"];
    emailViewController.fieldType = CONTACT;
//    emailViewController.announcementId = self.adDetails[@"id_anunt"];
    [self.navigationController pushViewController:emailViewController animated:YES];}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
