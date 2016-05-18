//
//  CreateAnnouncementViewController.h
//  Anuntul de UK
//
//  Created by Seby Feier on 23/02/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

@interface CreateAnnouncementViewController : UIViewController

@property (nonatomic, strong) NSDictionary *announcementType;
@property (nonatomic, strong) PayPalPayment *paypalPayment;
@property (nonatomic, strong) NSDictionary *republishedAnnouncement;

@end
