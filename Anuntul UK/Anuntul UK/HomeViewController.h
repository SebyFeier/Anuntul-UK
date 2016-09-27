//
//  HomeViewController.h
//  Anuntul de UK
//
//  Created by Seby Feier on 29/01/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *listOfAds;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (nonatomic, assign) BOOL searchResultsRequired;
@property (nonatomic, assign) BOOL isCategory;
@end
