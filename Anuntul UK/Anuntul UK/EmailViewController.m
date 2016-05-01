//
//  EmailViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 26/03/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "EmailViewController.h"
#import "WebServiceManager.h"
#import "MBProgressHUD.h"
#import "HexColors.h"
#import "UIView+Borders.h"

@interface EmailViewController()<UITextViewDelegate, UITextFieldDelegate> {
    NSString *textViewInitialMessage;
}
//@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendEmailButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailHeight;

@end

@implementation EmailViewController

- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameTextField.delegate = self;
    self.emailTextField.delegate = self;
    
    UIView *usernamePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.emailTextField.leftView = usernamePaddingView;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.nameTextField.leftView = passwordPaddingView;
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;

    UIColor *color = [UIColor hx_colorWithHexString:@"BFBFBF"];
//    self.messageTextView.textColor = color;
    self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Nume" attributes:@{NSForegroundColorAttributeName:color}];
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"E-mail" attributes:@{NSForegroundColorAttributeName:color}];
    self.messageTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"E-mail" attributes:@{NSForegroundColorAttributeName:color}];
    self.messageTextView.textColor = [UIColor hx_colorWithHexString:@"BFBFBF"];
    
    if (self.fieldType == SEND_EMAIL) {
        self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Nume" attributes:@{NSForegroundColorAttributeName:color}];
        self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"E-mail" attributes:@{NSForegroundColorAttributeName:color}];
        self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        self.messageTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Mesajul tau" attributes:@{NSForegroundColorAttributeName:color}];
        self.messageTextView.text = @"\nMesajul tau";

        textViewInitialMessage = @"\nMesajul tau";
        [self.sendEmailButton setTitle:@"Trimite mesajul" forState:UIControlStateNormal];
        self.navigationItem.title = @"Trimite mesaj";
    } else if (self.fieldType == REPORT) {
        self.nameHeight.constant = 0;
        self.emailHeight.constant = 0;
        [self.view layoutIfNeeded];
        self.messageTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Mesajul tau" attributes:@{NSForegroundColorAttributeName:color}];
        self.messageTextView.text = @"\nMesajul tau";

        textViewInitialMessage = @"\nMesajul tau";
        [self.sendEmailButton setTitle:@"Raportează" forState:UIControlStateNormal];
        self.navigationItem.title = @"Raportează";
    } else if (self.fieldType == CONTACT) {
        self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName:color}];
        self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Telefon(optional)" attributes:@{NSForegroundColorAttributeName:color}];
        self.emailTextField.keyboardType = UIKeyboardTypePhonePad;
        self.messageTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Mesajul tau" attributes:@{NSForegroundColorAttributeName:color}];
        self.messageTextView.text = @"\nMesajul tau";

        textViewInitialMessage = @"\nMesajul tau";
        [self.sendEmailButton setTitle:@"Trimite mesajul" forState:UIControlStateNormal];
        self.navigationItem.title = @"Trimite mesaj";

    }
    [self.nameTextField addBottomBorderWithHeight:1 andColor:color];
    [self.emailTextField addBottomBorderWithHeight:1 andColor:color];
    [self.messageTextField addBottomBorderWithHeight:1 andColor:color];
//    self.messageTextView.backgroundColor = [UIColor greenColor];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 15) ];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem1 = [[UIBarButtonItem alloc]
                                           initWithCustomView:backButton];
    [leftBarButtonItem1 setTintColor:[UIColor blackColor]];
    
    //set the action for button
    
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem1;
//    self.messageTextView.clipsToBounds = YES;
//    self.messageTextView.layer.cornerRadius = 10.0f;
//    self.messageTextView.text = textViewInitialMessage;
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if([text isEqualToString:@"\n"]) {
////        [self.messageTextView addBottomBorderWithHeight:1 andColor:[UIColor redColor]];
//        CALayer *border = [CALayer layer];
//        CGFloat borderWidth = 2;
//        border.borderColor = [UIColor blueColor].CGColor;
//        border.frame = CGRectMake(0, self.messageTextView.frame.size.height - borderWidth, self.messageTextView.frame.size.width, self.messageTextView.frame.size.height);
//        border.borderWidth = borderWidth;
//        [self.messageTextView.layer addSublayer:border];
//        self.messageTextView.layer.masksToBounds = YES;
////        return NO;
//    }
////    [self.messageTextView addBottomBorderWithHeight:1 andColor:[UIColor redColor]];
//    
//    return YES;
//    
//}


//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    if ([textView.text isEqualToString:@"Mesajul tau"]) {
//        textView.text = @"";
//        textView.textColor = [UIColor blackColor]; //optional
//    }
//    [textView becomeFirstResponder];
//}
//
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    if ([textView.text isEqualToString:@""]) {
//        textView.text = @"Mesajul tau";
//        textView.textColor = [UIColor lightGrayColor]; //optional
//    }
//    [textView resignFirstResponder];
//}

-(BOOL) validateEmail: (NSString *) email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    if (textField == self.nameTextField) {
        [self.emailTextField becomeFirstResponder];
    } else if (textField == self.emailTextField) {
        [self.messageTextField becomeFirstResponder];
        [self.messageTextView becomeFirstResponder];
    }
    return YES;
}

- (IBAction)sendEmailButtonTapped:(id)sender {
    [self.view endEditing:YES];
    if (self.fieldType == SEND_EMAIL) {
        if ([self.nameTextField.text length]) {
            if ([self validateEmail:self.emailTextField.text]) {
                if ([self.messageTextView.text length]) {
                    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
                    [[WebServiceManager sharedInstance] sendEmailFrom:self.emailTextField.text name:self.nameTextField.text announcement_id:[NSString stringWithFormat:@"%@",self.emailInfo[@"id_anunt"]] body:self.messageTextView.text withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                        if (!error) {
                            if ([dictionary[@"success"] boolValue]) {
                                [[[UIAlertView alloc] initWithTitle:@"" message:@"E-mailul a fost trimis" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                        } else {
                            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                        }
                    }];
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"" message:@"Introduceți mesajul" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            } else {
                [[[UIAlertView alloc] initWithTitle:@"" message:@"Introduceți e-mailul" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        } else {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Introduceți numele" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    } else if (self.fieldType == REPORT) {
        if ([self.messageTextView.text length]) {
            [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
            [[WebServiceManager sharedInstance] reportAnnouncementWithId:[NSString stringWithFormat:@"%@",self.announcementId] withMessage:self.messageTextView.text withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                if (!error) {
                    if ([dictionary[@"success"] boolValue]) {
                        [[[UIAlertView alloc] initWithTitle:@"" message:@"Anunțul a fost raportat" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            }];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Introduceți mesajul" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    } else if (self.fieldType == CONTACT) {
        if ([self validateEmail:self.nameTextField.text]) {
//            if ([self validateEmail:self.emailTextField.text]) {
                if ([self.messageTextView.text length]) {
                    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
                    [[WebServiceManager sharedInstance] contactOwnerWithEmail:self.nameTextField.text phoneNumber:self.emailTextField.text body:self.messageTextView.text withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                        if (!error) {
                            if ([dictionary[@"success"] boolValue]) {
                                [[[UIAlertView alloc] initWithTitle:@"" message:@"Veți fi contactat in curand" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                        } else {
                            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                        }
                        
                    }];
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"" message:@"Introduceți mesajul" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
        } else {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Introduceți emailul" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }
    
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:textViewInitialMessage]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = textViewInitialMessage;
        textView.textColor = [UIColor hx_colorWithHexString:@"BFBFBF"]; //optional
    }
    [textView resignFirstResponder];
}



@end
