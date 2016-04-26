//
//  AnnouncementTableViewCell.h
//  Anuntul de UK
//
//  Created by Seby Feier on 24/02/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnouncementTableViewCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UILabel *adTitle;
@property (weak, nonatomic) IBOutlet UILabel *adDescription;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionWidthConstraint;

@property (weak, nonatomic) IBOutlet UIWebView *descriptionWebView;
- (void)createCellWithInfo:(NSDictionary *)announcementType;

@end
