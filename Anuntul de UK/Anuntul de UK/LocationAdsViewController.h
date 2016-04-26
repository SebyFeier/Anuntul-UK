//
//  LocationAdsViewController.h
//  Anuntul de UK
//
//  Created by Seby Feier on 17/02/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationAdsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *locationAds;
@property (nonatomic, strong) NSString *locationId;
@property (nonatomic, strong) NSString *locationTitle;
@property (nonatomic, assign) BOOL isLocations;

@property (nonatomic, assign) BOOL isMyProfile;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentedControlHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;

@end
