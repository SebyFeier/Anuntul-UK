//
//  EmailViewController.h
//  Anuntul de UK
//
//  Created by Seby Feier on 26/03/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SEND_EMAIL = 1,
    REPORT,
    CONTACT
} FIELD_TYPE;

@interface EmailViewController : UIViewController

@property (nonatomic, strong) NSDictionary *emailInfo;
@property (nonatomic, strong) NSString *announcementId;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic, assign) FIELD_TYPE fieldType;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@end
