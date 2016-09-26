//
//  SuccessViewController.h
//  Anuntul de UK
//
//  Created by Seby Feier on 04/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuccessViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UIButton *myAnnouncements;
@property (weak, nonatomic) IBOutlet UIButton *addAnnouncementButton;

@property (nonatomic, assign) BOOL isError;
@end
