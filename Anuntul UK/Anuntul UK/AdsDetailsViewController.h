//
//  AdsDetailsViewController.h
//  Anuntul de UK
//
//  Created by Seby Feier on 29/01/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PayPalMobile.h"

@interface AdsDetailsViewController : UIViewController

@property (nonatomic, strong) NSDictionary *adDetails;
@property (nonatomic, strong) NSDictionary *announcementInfo;
@property (nonatomic, strong) NSDictionary *announcementType;
@property (nonatomic, assign) BOOL toPublish;
//@property (nonatomic, strong) PayPalPayment *paypalPayment;
@property (nonatomic, assign) NSDictionary *republishedAnnouncement;

@end
