//
//  RegisterViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 30/01/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "RegisterViewController.h"
#import "WebServiceManager.h"
#import <CommonCrypto/CommonDigest.h>
#import "MBProgressHUD.h"
#import "HexColors.h"
#import "Haneke.h"
#import "UIView+Borders.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UITextField *registerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *registerEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *registerPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerAgreeButton;
@property (weak, nonatomic) IBOutlet UITextField *registerConfirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIView *forgotView;
@property (weak, nonatomic) IBOutlet UITextField *forgotEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *forgotPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *forgotConfirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *profileUsernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *profileEmailLabel;
@property (weak, nonatomic) IBOutlet UITextField *profilePasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *profileConfirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UISwitch *agreeSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editWidthConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *editScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@end

@implementation RegisterViewController

- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *grayColor = [UIColor hx_colorWithHexString:@"BFBFBF"];
    [self.registerNameTextField addBottomBorderWithHeight:1 andColor:grayColor];
    [self.registerEmailTextField addBottomBorderWithHeight:1 andColor:grayColor];
    [self.registerPasswordTextField addBottomBorderWithHeight:1 andColor:grayColor];
    [self.registerConfirmPasswordTextField addBottomBorderWithHeight:1 andColor:grayColor];
    
    
    [self.forgotEmailTextField addBottomBorderWithHeight:1 andColor:grayColor];
    [self.forgotPasswordTextField addBottomBorderWithHeight:1 andColor:grayColor];
    [self.forgotConfirmPasswordTextField addBottomBorderWithHeight:1 andColor:grayColor];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 15) ];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem1 = [[UIBarButtonItem alloc]
                                           initWithCustomView:backButton];
    [leftBarButtonItem1 setTintColor:[UIColor blackColor]];
    
    //set the action for button
    
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRoot:) name:@"PopToRoot" object:nil];
    if (self.type == REGISTER) {
        self.registerView.hidden = NO;
        self.forgotView.hidden = YES;
        self.editView.hidden = YES;
        self.navigationItem.title = @"Inregistrare";
    } else if (self.type == FORGOT) {
        self.registerView.hidden = YES;
        self.forgotView.hidden = NO;
        self.editView.hidden = YES;
        self.navigationItem.title = @"Resetare Parolă";
    } else if (self.type == EDIT) {
        self.registerView.hidden = YES;
        self.forgotView.hidden = YES;
        self.editView.hidden = NO;
        self.navigationItem.title = @"Profilul meu";
        self.editWidthConstraint.constant = CGRectGetWidth(self.view.frame) - 40;
//        self.editScrollView.frame = CGRectMake(0, 0, 200, 200);
//        self.editScrollView.frame = self.view.frame;
//        self.editScrollView.contentSize = self.view.frame.size;
//        self.editScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 330);
        [self.view layoutIfNeeded];
        if (self.userInfo) {
            self.profileUsernameLabel.text = self.userInfo[@"nume"];
            self.profileEmailLabel.text = self.userInfo[@"email"];
//            if ([self.userInfo[@"post_avatar"] length]) {
//            [self.profileImageView hnk_setImageFromURL:[NSURL URLWithString:self.userInfo[@"post_avatar"]]];
//            } else {
//                [self.profileImageView setImage:[UIImage imageNamed:@"no_avatar"]];
//            }
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"facebookImage"]) {
                [self.profileImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"facebookImage"]]]]];
            } else {
                [self.profileImageView setImage:[UIImage imageNamed:@"no_avatar"]];
            }
        }
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.registerAgreeButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    
    NSString *agreeTermsText = @"  Sunt de acord cu Termenii și Condițiile";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:agreeTermsText];
    NSRange range=[agreeTermsText rangeOfString:@"Termenii și Condițiile"];
    
    UIFont *font = [UIFont boldSystemFontOfSize:13];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    [attrString addAttributes:attrsDictionary range:range];
    //    [attrString addAttribute:NSFontAttributeName
    //                   value:[UIFont boldSystemFontOfSize:13]
    //                   range:range];
    [self.registerAgreeButton.titleLabel setTextColor:[UIColor blackColor]];
    [self.registerAgreeButton setAttributedTitle:attrString forState:UIControlStateNormal];
    
    UIColor *color = [UIColor hx_colorWithHexString:@"000000"];
//    self.registerNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Nume complet" attributes:@{NSForegroundColorAttributeName:color}];
//    self.registerEmailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Adresa de email valida" attributes:@{NSForegroundColorAttributeName:color}];
//    self.registerPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Parola (minim 5 caractere)" attributes:@{NSForegroundColorAttributeName:color}];
//    self.registerConfirmPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Parola din nou" attributes:@{NSForegroundColorAttributeName:color}];
//    self.forgotEmailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Adresa de email" attributes:@{NSForegroundColorAttributeName:color}];
//    self.forgotPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Parola (minim 5 caractere)" attributes:@{NSForegroundColorAttributeName:color}];
//    self.forgotConfirmPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Parola din nou" attributes:@{NSForegroundColorAttributeName:color}];
    self.profileUsernameLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName:color}];
//    self.profilePasswordLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Parola noua" attributes:@{NSForegroundColorAttributeName:color}];
//    self.profileConfirmPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirma parola noua" attributes:@{NSForegroundColorAttributeName:color}];
    self.profileEmailLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"E-mail" attributes:@{NSForegroundColorAttributeName:color}];
    
    UIView *usernamePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.profileUsernameLabel.leftView = usernamePaddingView;
    self.profileUsernameLabel.leftViewMode = UITextFieldViewModeAlways;
    UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.profilePasswordLabel.leftView = passwordPaddingView;
    self.profilePasswordLabel.leftViewMode = UITextFieldViewModeAlways;
    UIView *confirmPasswordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.profileConfirmPasswordTextField.leftView = confirmPasswordPaddingView;
    self.profileConfirmPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *emailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.profileEmailLabel.leftView = emailPaddingView;
    self.profileEmailLabel.leftViewMode = UITextFieldViewModeAlways;
    
    self.profileImageView.layer.cornerRadius = 30.0f;
    [self.profileImageView layoutIfNeeded];
    
    // Do any additional setup after loading the view.
}

- (void)popToRoot:(NSNotification *)notification {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registerButtonTapped:(id)sender {
    [self.view endEditing:YES];
    if ([self validateUsername:self.registerNameTextField.text]) {
        if ([self validateEmail:self.registerEmailTextField.text]) {
            if ([self validatePassword:self.registerPasswordTextField.text]) {
                if ([self.registerPasswordTextField.text isEqualToString:self.registerConfirmPasswordTextField.text]) {
                    if (self.agreeSwitch.isOn) {
                    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
                    [[WebServiceManager sharedInstance] registerWithEmail:self.registerEmailTextField.text andPassword:[self md5:self.registerPasswordTextField.text] andUsername:self.registerNameTextField.text withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                        if (!error) {
                            if (dictionary[@"failed"]) {
                                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:dictionary[@"failed"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                            } else {
                                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                [userDefaults setObject:self.registerEmailTextField.text forKey:@"email"];
                                [userDefaults setObject:self.registerPasswordTextField.text forKey:@"password"];
                                [userDefaults synchronize];
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }
                        } else {
                            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                        }
                    }];
                    } else {
                        [[[UIAlertView alloc] initWithTitle:@"Eroare" message:@"Trebuie să fiți de acord cu termenii și condițiile" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    }
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"Eroare" message:@"Parolele nu coincid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:@"Parola este prea scurtă" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:@"Email invalid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Eroare" message:@"Introduceți numele" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.bottomConstraint.constant = 50;
    [self.view layoutIfNeeded];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.bottomConstraint.constant = 170;
    [self.view layoutIfNeeded];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.registerNameTextField) {
        [self.registerEmailTextField becomeFirstResponder];
    } else if (textField == self.registerEmailTextField) {
        [self.registerPasswordTextField becomeFirstResponder];
    } else if (textField == self.registerPasswordTextField) {
        [self.registerConfirmPasswordTextField becomeFirstResponder];
    } else if (textField == self.registerConfirmPasswordTextField) {
        [self registerButtonTapped:nil];
    } else if (textField == self.forgotEmailTextField) {
        [self.forgotPasswordTextField becomeFirstResponder];
    } else if (textField == self.forgotPasswordTextField) {
        [self.forgotConfirmPasswordTextField becomeFirstResponder];
    } else if (textField == self.forgotConfirmPasswordTextField) {
        [self forgotResetPasswordButtonTapped:nil];
    } else if (textField == self.profileUsernameLabel) {
        [self.profileEmailLabel becomeFirstResponder];
    } else if (textField == self.profileEmailLabel) {
        [self.profilePasswordLabel becomeFirstResponder];
    } else if (textField == self.profilePasswordLabel) {
        [self.profileConfirmPasswordTextField becomeFirstResponder];
    } else if (textField == self.profileConfirmPasswordTextField) {
        [self editSaveButtonTapped:nil];
    }
    return YES;
}
- (IBAction)registerAgreeTermsButtonTapped:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)forgotResetPasswordButtonTapped:(id)sender {
    [self.view endEditing:YES];
    if ([self validateEmail:self.forgotEmailTextField.text]) {
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];

        [[WebServiceManager sharedInstance] resetPasswordForEmail:self.forgotEmailTextField.text withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            if (!error) {
                if ([dictionary[@"success"] boolValue]) {
                    [[[UIAlertView alloc] initWithTitle:@"" message:@"Va rugam sa va verificati emailul (inclusiv in folderul Spam).V-a fost trimis un email ce contine linkul de resetare a parolei." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    [self.navigationController popViewControllerAnimated:YES];
                } else if (dictionary[@"failed"]) {
                    [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[dictionary objectForKey:@"failed"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

            }
        }];
//        if ([self validatePassword:self.forgotPasswordTextField.text]) {
//            if ([self.forgotPasswordTextField.text isEqualToString:self.forgotConfirmPasswordTextField.text]) {
//                //TODO: IMPLEMENT FORGOT
//            } else {
//                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:@"Parolele nu coincid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//            }
//        } else {
//            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:@"Parola prea scurtă" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//        }
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Eroare" message:@"Email invalid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    [self.view endEditing:YES];
}
- (IBAction)editSaveButtonTapped:(id)sender {
    [self.view endEditing:YES];
    if ([self.profileUsernameLabel.text length]) {
        if ([self.profilePasswordLabel.text length]) {
            if ([self.profilePasswordLabel.text isEqualToString:self.profileConfirmPasswordTextField.text]) {
                [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
                [[WebServiceManager sharedInstance] editUserWithId:self.userInfo[@"id_user"] username:self.profileUsernameLabel.text andPassword:[self md5:self.profilePasswordLabel.text] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:self.profileEmailLabel.text forKey:@"email"];
                    [userDefaults setObject:self.profilePasswordLabel.text forKey:@"password"];
                    [userDefaults setObject:dictionary[@"id_user"] forKey:@"id_user"];
                    [userDefaults synchronize];

                }];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:@"Parolele nu coincid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        } else {
            [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
            [[WebServiceManager sharedInstance] editUserWithId:self.userInfo[@"id_user"] username:self.profileUsernameLabel.text andPassword:nil withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:self.profileUsernameLabel.text forKey:@"email"];
//                [userDefaults setObject:self.passwordTextField.text forKey:@"password"];
                [userDefaults setObject:dictionary[@"id_user"] forKey:@"id_user"];
                [userDefaults synchronize];
            }];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Eroare" message:@"Introduceți numele" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

-(BOOL) validateEmail: (NSString *) email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}

- (BOOL)validatePassword:(NSString *)password {
    if (password.length >= 5) {
        return YES;
    }
    return NO;
}

- (BOOL)validateUsername:(NSString *)username {
    if (username.length > 0) {
        return YES;
    }
    return NO;
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
