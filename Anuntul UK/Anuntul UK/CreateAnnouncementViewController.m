
//  CreateAnnouncementViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 23/02/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "CreateAnnouncementViewController.h"
#import "WebServiceManager.h"
#import "UILabel+Image.h"
#import "HexColors.h"
#import "AdsDetailsViewController.h"
#import "HexColors.h"
#import "PhotoManager.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Borders.h"
#import "SelectionViewController.h"
#import "PictureViewController.h"
#import "Haneke.h"

NSString *const WebServiceUrlPhoto = @"http://anuntul.boxnets.com";


@interface CreateAnnouncementViewController()<UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, PhotoManagerDelegate, SelectionDelegate, DeletePictureDelegate> {
    
    UIPickerView *pickerView;
    UIToolbar *doneToolbar_;
    NSDictionary *selectedCategory;
    NSDictionary *selectedLocation;
    NSMutableArray *allCategories;
    NSMutableArray *allLocations;
    PhotoManager *photoManager;
    NSMutableArray *images;
    NSInteger numberOfImages;
    BOOL isCategorySelected;
    NSData *imageData;
    NSMutableArray *imagesData;
}
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (strong, nonatomic)  UIImageView *imageView1;
@property (strong, nonatomic)  UIImageView *imageView2;
@property (strong, nonatomic)  UIImageView *imageView3;
@property (strong, nonatomic)  UIImageView *imageView4;
@property (strong, nonatomic)  UIImageView *imageView5;
@property (strong, nonatomic)  UIImageView *imageView6;
@property (strong, nonatomic)  UIImageView *imageView7;
@property (strong, nonatomic)  UIImageView *imageView8;
@property (strong, nonatomic)  UILabel *agreeLabel;
@property (strong, nonatomic)  UIButton *visualizeButton;
@property (strong, nonatomic)  UISwitch *agreeSwitch;

@end

@implementation CreateAnnouncementViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.categoryButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [self.locationButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    UIColor *color = [UIColor hx_colorWithHexString:@"BFBFBF"];
    self.descriptionTextView.layer.borderWidth = 0.5f;
    self.descriptionTextView.layer.borderColor = [color CGColor];
    
    [self.titleTextField addTopBorderWithHeight:0.5 andColor:color];
    [self.titleTextField addLeftBorderWithWidth:0.5 andColor:color];
    [self.titleTextField addRightBorderWithWidth:0.5 andColor:color];
    [self.titleTextField addBottomBorderWithHeight:0.5 andColor:color];
    [self.phoneTextField addTopBorderWithHeight:0.5 andColor:color];
    [self.phoneTextField addLeftBorderWithWidth:0.5 andColor:color];
    [self.phoneTextField addRightBorderWithWidth:0.5 andColor:color];
    [self.phoneTextField addBottomBorderWithHeight:0.5 andColor:color];
    [self.categoryButton addTopBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
    [self.categoryButton addLeftBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
    [self.categoryButton addRightBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
    [self.categoryButton addBottomBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
    [self.locationButton addTopBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
    [self.locationButton addLeftBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
    [self.locationButton addRightBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
    [self.locationButton addBottomBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
    
    [self.agreeLabel addTopBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
    [self.agreeLabel addLeftBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
    [self.agreeLabel addRightBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
    [self.agreeLabel addBottomBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
    
    
    
    
    
}


- (void)popToRoot:(NSNotification *)notification {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clearFieldsButtonTapped:(id)sender {
    [self.view endEditing:YES];
    self.titleTextField.text = @"";
    self.descriptionTextView.text = @"Descriere";
    self.descriptionTextView.textColor = [UIColor lightGrayColor]; //optional
    self.phoneTextField.text = @"";
    self.agreeSwitch.on = NO;
    [self.categoryButton setTitle:@"Categoria" forState:UIControlStateNormal];
    [self.locationButton setTitle:@"Locația" forState:UIControlStateNormal];
    [self.imageView1 setImage:[UIImage imageNamed:@"add_image"]];
    [self.imageView2 removeFromSuperview];
    [self.imageView3 removeFromSuperview];
    [self.imageView4 removeFromSuperview];
    [self.imageView5 removeFromSuperview];
    [self.imageView6 removeFromSuperview];
    [self.imageView7 removeFromSuperview];
    [self.imageView8 removeFromSuperview];
    self.imageView1.userInteractionEnabled = YES;
    self.imageView2.userInteractionEnabled = YES;
    self.imageView3.userInteractionEnabled = YES;
    images = nil;
    imagesData = nil;
    numberOfImages = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.widthConstraint.constant = CGRectGetWidth(self.view.frame) - 20;
    [self.view layoutIfNeeded];
    
    
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 15) ];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem1 = [[UIBarButtonItem alloc]
                                           initWithCustomView:backButton];
    [leftBarButtonItem1 setTintColor:[UIColor blackColor]];
    
    //set the action for button
    
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem1;
    
    UIButton *clearFieldsButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18) ];
    [clearFieldsButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [clearFieldsButton addTarget:self action:@selector(clearFieldsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem1 = [[UIBarButtonItem alloc]
                                            initWithCustomView:clearFieldsButton];
    [rightBarButtonItem1 setTintColor:[UIColor blackColor]];
    
    //set the action for button
    
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem1;
    
    
    numberOfImages = 0;
    self.navigationItem.title = @"Adaugă anunț";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRoot:) name:@"PopToRoot" object:nil];
    allCategories = [NSMutableArray arrayWithArray:[[WebServiceManager sharedInstance] listOfCategories]];
    [allCategories removeLastObject];
    [allCategories removeObjectAtIndex:0];
    
    allLocations = [[NSMutableArray alloc] init];
    NSArray *locations = [[WebServiceManager sharedInstance] listOfLocations];
    for (NSDictionary *location in locations) {
        [allLocations addObjectsFromArray:location[@"locations"]];
    }
    self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView1.frame = CGRectMake(20, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
    [self.scrollView addSubview:self.imageView1];

    self.agreeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    self.agreeLabel.font = [UIFont systemFontOfSize:15];
    
    NSString *agreeTermsText = @"Sunt de acord cu Termenii și Condițiile";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:agreeTermsText];
    NSRange range=[agreeTermsText rangeOfString:@"Termenii și Condițiile"];
    
    UIFont *font = [UIFont boldSystemFontOfSize:15];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    [attrString addAttributes:attrsDictionary range:range];
    //    [attrString addAttribute:NSFontAttributeName
    //                   value:[UIFont boldSystemFontOfSize:13]
    //                   range:range];
    self.agreeLabel.textColor = [UIColor blackColor];
    self.agreeLabel.attributedText = attrString;
    
    self.agreeLabel.frame = CGRectMake(15, CGRectGetMaxY(self.imageView1.frame) + 10, CGRectGetWidth(self.view.frame) - 80, 44);
    self.agreeLabel.numberOfLines = 0;
    //    self.agreeLabel.text = @"Sunt de acord cu Termenii si conditiile...";
    self.agreeLabel.textColor = [UIColor hx_colorWithHexString:@"BFBFBF"];
    [self.scrollView addSubview:self.agreeLabel];
    
    self.agreeSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    self.agreeSwitch.on = NO;
    
    self.agreeSwitch.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 40, CGRectGetMinY(self.agreeLabel.frame), 80, 44);
    self.agreeSwitch.center = CGPointMake(self.agreeSwitch.frame.origin.x, CGRectGetMidY(self.agreeLabel.frame));
    
    [self.scrollView addSubview:self.agreeSwitch];
    
    self.visualizeButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.visualizeButton setTitle:@"Previzualizare" forState:UIControlStateNormal];
    self.visualizeButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.visualizeButton setBackgroundColor:[HXColor hx_colorWithHexString:@"2299C3"]];
    [self.visualizeButton addTarget:self action:@selector(visualizeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.visualizeButton.frame = CGRectMake(10, CGRectGetMaxY(self.agreeLabel.frame) + 10, CGRectGetWidth(self.view.frame) - 20, 44);
    
    [self.scrollView addSubview:self.visualizeButton];
    
    self.descriptionTextView.text = @"Descriere";
    self.descriptionTextView.textColor = [UIColor hx_colorWithHexString:@"BFBFBF"];
    
    UIColor *color = [UIColor hx_colorWithHexString:@"BFBFBF"];
    self.titleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Titlu anunt" attributes:@{NSForegroundColorAttributeName:color}];
    self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Telefon" attributes:@{NSForegroundColorAttributeName:color}];
    
    self.agreeLabel.backgroundColor = [UIColor whiteColor];
    
    UIView *usernamePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.titleTextField.leftView = usernamePaddingView;
    self.titleTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.phoneTextField.leftView = passwordPaddingView;
    self.phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    
    //    self.categoryButton.layer.cornerRadius = 10; // this value vary as per your desire
    //    self.categoryButton.clipsToBounds = YES;
    //    self.locationButton.layer.cornerRadius = 10; // this value vary as per your desire
    //    self.locationButton.clipsToBounds = YES;
    //
    //    self.descriptionTextView.clipsToBounds = YES;
    //    self.descriptionTextView.layer.cornerRadius = 10.0f;
    
    
    if (self.republishedAnnouncement) {

        self.titleTextField.text = self.republishedAnnouncement[@"titlu"];
//        self.titleTextField.enabled = NO;
        self.descriptionTextView.text = self.republishedAnnouncement[@"descriere"];
//        self.descriptionTextView.editable = NO;
//        self.descriptionTextView.textColor = [UIColor hx_colorWithHexString:@"BFBFBF"];
        self.descriptionTextView.textColor = [UIColor blackColor];
        self.phoneTextField.text = self.republishedAnnouncement[@"telefon1"];
//        self.phoneTextField.enabled = NO;
        [self.locationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.categoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        selectedLocation = self.republishedAnnouncement[@"location"];
        selectedCategory = self.republishedAnnouncement[@"category"];
        [self.locationButton setTitle:[selectedLocation objectForKey:@"titlu"] forState:UIControlStateNormal];
        [self.categoryButton setTitle:[selectedCategory objectForKey:@"titlu"] forState:UIControlStateNormal];
//        self.locationButton.enabled = NO;
//        self.categoryButton.enabled = NO;
        if (self.republishedAnnouncement[@"images"] && [self.republishedAnnouncement[@"images"] count]) {
            if (!images) {
                images = [[NSMutableArray alloc] init];
            }
            if (!imagesData) {
                imagesData = [[NSMutableArray alloc] init];
            }
            numberOfImages = [self.republishedAnnouncement[@"images"] count];
            if (numberOfImages == 1) {
                NSData *img1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img1) {
                    [imagesData addObject:img1];
                } else {
                    numberOfImages--;
                }
            } else if (numberOfImages == 2) {
                NSData *img1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img1) {
                    [imagesData addObject:img1];
                } else {
                    numberOfImages--;
                }
                NSData *img2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img2) {
                    [imagesData addObject:img2];
                } else {
                    numberOfImages--;
                }
            } else if (numberOfImages == 3) {
                NSData *img1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img1) {
                    [imagesData addObject:img1];
                } else {
                    numberOfImages--;
                }
                NSData *img2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img2) {
                    [imagesData addObject:img2];
                } else {
                    numberOfImages--;
                }
                NSData *img3 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img3) {
                    [imagesData addObject:img3];
                } else {
                    numberOfImages--;
                }
            } else if (numberOfImages == 4) {
                NSData *img1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img1) {
                    [imagesData addObject:img1];
                } else {
                    numberOfImages--;
                }
                NSData *img2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img2) {
                    [imagesData addObject:img2];
                } else {
                    numberOfImages--;
                }
                NSData *img3 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img3) {
                    [imagesData addObject:img3];
                } else {
                    numberOfImages--;
                }
                NSData *img4 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img4) {
                    [imagesData addObject:img4];
                } else {
                    numberOfImages--;
                }
            } else if (numberOfImages == 5) {
                
                NSData *img1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img1) {
                    [imagesData addObject:img1];
                } else {
                    numberOfImages--;
                }
                NSData *img2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img2) {
                    [imagesData addObject:img2];
                } else {
                    numberOfImages--;
                }
                NSData *img3 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img3) {
                    [imagesData addObject:img3];
                } else {
                    numberOfImages--;
                }
                NSData *img4 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img4) {
                    [imagesData addObject:img4];
                } else {
                    numberOfImages--;
                }
                NSData *img5 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][4] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img5) {
                    [imagesData addObject:img5];
                } else {
                    numberOfImages--;
                }
            } else if (numberOfImages == 6) {
                
                NSData *img1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img1) {
                    [imagesData addObject:img1];
                } else {
                    numberOfImages--;
                }
                NSData *img2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img2) {
                    [imagesData addObject:img2];
                } else {
                    numberOfImages--;
                }
                NSData *img3 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img3) {
                    [imagesData addObject:img3];
                } else {
                    numberOfImages--;
                }
                NSData *img4 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img4) {
                    [imagesData addObject:img4];
                } else {
                    numberOfImages--;
                }
                NSData *img5 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][4] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img5) {
                    [imagesData addObject:img5];
                } else {
                    numberOfImages--;
                }
                NSData *img6 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][5] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img6) {
                    [imagesData addObject:img6];
                } else {
                    numberOfImages--;
                }
            } else if (numberOfImages == 7) {
                
                NSData *img1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img1) {
                    [imagesData addObject:img1];
                } else {
                    numberOfImages--;
                }
                NSData *img2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img2) {
                    [imagesData addObject:img2];
                } else {
                    numberOfImages--;
                }
                NSData *img3 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img3) {
                    [imagesData addObject:img3];
                } else {
                    numberOfImages--;
                }
                NSData *img4 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img4) {
                    [imagesData addObject:img4];
                } else {
                    numberOfImages--;
                }
                NSData *img5 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][4] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img5) {
                    [imagesData addObject:img5];
                } else {
                    numberOfImages--;
                }
                NSData *img6 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][5] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img6) {
                    [imagesData addObject:img6];
                } else {
                    numberOfImages--;
                }
                NSData *img7 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][6] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img7) {
                    [imagesData addObject:img7];
                } else {
                    numberOfImages--;
                }
            } else if (numberOfImages == 8) {
                
                NSData *img1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img1) {
                    [imagesData addObject:img1];
                } else {
                    numberOfImages--;
                }
                NSData *img2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img2) {
                    [imagesData addObject:img2];
                } else {
                    numberOfImages--;
                }
                NSData *img3 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img3) {
                    [imagesData addObject:img3];
                } else {
                    numberOfImages--;
                }
                NSData *img4 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img4) {
                    [imagesData addObject:img4];
                } else {
                    numberOfImages--;
                }
                NSData *img5 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][4] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img5) {
                    [imagesData addObject:img5];
                } else {
                    numberOfImages--;
                }
                NSData *img6 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][5] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img6) {
                    [imagesData addObject:img6];
                } else {
                    numberOfImages--;
                }
                NSData *img7 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][6] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img7) {
                    [imagesData addObject:img7];
                } else {
                    numberOfImages--;
                }
                NSData *img8 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][7] objectForKey:@"img"] objectForKey:@"url"]]];
                if (img8) {
                    [imagesData addObject:img8];
                } else {
                    numberOfImages--;
                }
            }
            if (numberOfImages == 0) {
                self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView1.image = [UIImage imageNamed:@"add_image"];
                self.imageView1.frame = CGRectMake(20, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView1];
                
                self.imageView1.userInteractionEnabled = YES;
                UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView1.tag = 111;
                [self.imageView1 addGestureRecognizer:tapGesture1];
            } else if (numberOfImages == 1) {

                [self.imageView1 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]];
                self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
                //                self.imageView2.image = [UIImage imageNamed:@"add_image"];
                self.imageView2.frame = CGRectMake(90, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView2];
                self.imageView2.image = [UIImage imageNamed:@"add_image"];

                [images addObject:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]];
               
                //                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]]];
                
                UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView1.tag = 111;
                [self.imageView1 addGestureRecognizer:tapGesture1];
                UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView2.tag = 222;
                [self.imageView2 addGestureRecognizer:tapGesture2];
            } else if (numberOfImages == 2) {
                self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
//                self.imageView2.image = [UIImage imageNamed:@"add_image"];
                self.imageView2.frame = CGRectMake(90, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView2];
                
                [self.imageView1 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView2 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]];
                self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView3.frame = CGRectMake(160, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView3];
                self.imageView3.image = [UIImage imageNamed:@"add_image"];
                
                [images addObject:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]]];
                
                UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView1.tag = 111;
                [self.imageView1 addGestureRecognizer:tapGesture1];
                UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView2.tag = 222;
                [self.imageView2 addGestureRecognizer:tapGesture2];
                UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView3.tag = 333;
                [self.imageView3 addGestureRecognizer:tapGesture3];
            } else if (numberOfImages == 3) {
                self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView2.frame = CGRectMake(90, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView2];
                self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView3.frame = CGRectMake(160, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView3];
                
                [self.imageView1 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView2 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView3 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]]];
                self.imageView4 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView4.frame = CGRectMake(230, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView4];
                self.imageView4.image = [UIImage imageNamed:@"add_image"];
                
                [images addObject:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]]]];
                
                UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView1.tag = 111;
                [self.imageView1 addGestureRecognizer:tapGesture1];
                UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView2.tag = 222;
                [self.imageView2 addGestureRecognizer:tapGesture2];
                UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView3.tag = 333;
                [self.imageView3 addGestureRecognizer:tapGesture3];
                UITapGestureRecognizer *tapGesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView4.tag = 444;
                [self.imageView4 addGestureRecognizer:tapGesture4];

            } else if (numberOfImages == 4) {
                self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView2.frame = CGRectMake(90, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView2];
                self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView3.frame = CGRectMake(160, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView3];
                self.imageView4 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView4.frame = CGRectMake(230, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView4];
                
                self.imageView5 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView5.frame = CGRectMake(20, CGRectGetMaxY(self.imageView1.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView5];
                self.imageView5.image = [UIImage imageNamed:@"add_image"];
                self.agreeLabel.frame = CGRectMake(15, CGRectGetMaxY(self.imageView5.frame) + 10, CGRectGetWidth(self.view.frame) - 60, 44);
                self.agreeSwitch.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 40, CGRectGetMinY(self.agreeLabel.frame), 80, 44);
                self.agreeSwitch.center = CGPointMake(self.agreeSwitch.frame.origin.x, CGRectGetMidY(self.agreeLabel.frame));
                self.visualizeButton.frame = CGRectMake(20, CGRectGetMaxY(self.agreeLabel.frame) + 10, CGRectGetWidth(self.view.frame) - 40, 44);
                [self.imageView1 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView2 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView3 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView4 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]]];
                
                [images addObject:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]]]];
                
                UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView1.tag = 111;
                [self.imageView1 addGestureRecognizer:tapGesture1];
                UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView2.tag = 222;
                [self.imageView2 addGestureRecognizer:tapGesture2];
                UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView3.tag = 333;
                [self.imageView3 addGestureRecognizer:tapGesture3];
                UITapGestureRecognizer *tapGesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView4.tag = 444;
                [self.imageView4 addGestureRecognizer:tapGesture4];
                UITapGestureRecognizer *tapGesture5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView5.tag = 555;
                [self.imageView5 addGestureRecognizer:tapGesture5];
                
            } else if (numberOfImages == 5) {
                self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView2.frame = CGRectMake(90, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView2];
                self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView3.frame = CGRectMake(160, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView3];
                self.imageView4 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView4.frame = CGRectMake(230, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView4];
                self.imageView5 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView5.frame = CGRectMake(20, CGRectGetMaxY(self.imageView1.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView5];
                self.agreeLabel.frame = CGRectMake(15, CGRectGetMaxY(self.imageView5.frame) + 10, CGRectGetWidth(self.view.frame) - 60, 44);
                self.agreeSwitch.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 40, CGRectGetMinY(self.agreeLabel.frame), 80, 44);
                self.agreeSwitch.center = CGPointMake(self.agreeSwitch.frame.origin.x, CGRectGetMidY(self.agreeLabel.frame));
                self.visualizeButton.frame = CGRectMake(20, CGRectGetMaxY(self.agreeLabel.frame) + 10, CGRectGetWidth(self.view.frame) - 40, 44);

                [self.imageView1 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView2 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView3 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView4 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView5 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][4] objectForKey:@"img"] objectForKey:@"url"]]];
                self.imageView6 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView6.frame = CGRectMake(90, CGRectGetMaxY(self.imageView1.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView6];
                self.imageView6.image = [UIImage imageNamed:@"add_image"];
                [images addObject:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][4] objectForKey:@"img"] objectForKey:@"url"]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][4] objectForKey:@"img"] objectForKey:@"url"]]]];
                UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView1.tag = 111;
                [self.imageView1 addGestureRecognizer:tapGesture1];
                UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView2.tag = 222;
                [self.imageView2 addGestureRecognizer:tapGesture2];
                UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView3.tag = 333;
                [self.imageView3 addGestureRecognizer:tapGesture3];
                UITapGestureRecognizer *tapGesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView4.tag = 444;
                [self.imageView4 addGestureRecognizer:tapGesture4];
                UITapGestureRecognizer *tapGesture5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView5.tag = 555;
                [self.imageView5 addGestureRecognizer:tapGesture5];
                UITapGestureRecognizer *tapGesture6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView6.tag = 666;
                [self.imageView6 addGestureRecognizer:tapGesture6];

            } else if (numberOfImages == 6) {
                
                self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView2.frame = CGRectMake(90, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView2];
                self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView3.frame = CGRectMake(160, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView3];
                self.imageView4 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView4.frame = CGRectMake(230, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView4];
                self.imageView5 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView5.frame = CGRectMake(20, CGRectGetMaxY(self.imageView1.frame) + 15, 60, 60);
                self.agreeLabel.frame = CGRectMake(15, CGRectGetMaxY(self.imageView5.frame) + 10, CGRectGetWidth(self.view.frame) - 60, 44);
                self.agreeSwitch.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 40, CGRectGetMinY(self.agreeLabel.frame), 80, 44);
                self.agreeSwitch.center = CGPointMake(self.agreeSwitch.frame.origin.x, CGRectGetMidY(self.agreeLabel.frame));
                self.visualizeButton.frame = CGRectMake(20, CGRectGetMaxY(self.agreeLabel.frame) + 10, CGRectGetWidth(self.view.frame) - 40, 44);
                [self.scrollView addSubview:self.imageView5];
                self.imageView6 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView6.frame = CGRectMake(90, CGRectGetMaxY(self.imageView1.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView6];

                [self.imageView1 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView2 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView3 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView4 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView5 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][4] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView6 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][5] objectForKey:@"img"] objectForKey:@"url"]]];
                self.imageView7 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView7.frame = CGRectMake(160, CGRectGetMaxY(self.imageView1.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView7];
                self.imageView7.image = [UIImage imageNamed:@"add_image"];
                [images addObject:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][4] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][5] objectForKey:@"img"] objectForKey:@"url"]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][4] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][5] objectForKey:@"img"] objectForKey:@"url"]]]];
                
                UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView1.tag = 111;
                [self.imageView1 addGestureRecognizer:tapGesture1];
                UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView2.tag = 222;
                [self.imageView2 addGestureRecognizer:tapGesture2];
                UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView3.tag = 333;
                [self.imageView3 addGestureRecognizer:tapGesture3];
                UITapGestureRecognizer *tapGesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView4.tag = 444;
                [self.imageView4 addGestureRecognizer:tapGesture4];
                UITapGestureRecognizer *tapGesture5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView5.tag = 555;
                [self.imageView5 addGestureRecognizer:tapGesture5];
                UITapGestureRecognizer *tapGesture6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView6.tag = 666;
                [self.imageView6 addGestureRecognizer:tapGesture6];
                UITapGestureRecognizer *tapGesture7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView7.tag = 777;
                [self.imageView7 addGestureRecognizer:tapGesture7];
            } else if (numberOfImages == 7) {
                self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView2.frame = CGRectMake(90, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView2];
                self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView3.frame = CGRectMake(160, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView3];
                self.imageView4 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView4.frame = CGRectMake(230, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView4];
                self.imageView5 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView5.frame = CGRectMake(20, CGRectGetMaxY(self.imageView1.frame) + 15, 60, 60);
                self.agreeLabel.frame = CGRectMake(15, CGRectGetMaxY(self.imageView5.frame) + 10, CGRectGetWidth(self.view.frame) - 60, 44);
                self.agreeSwitch.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 40, CGRectGetMinY(self.agreeLabel.frame), 80, 44);
                self.agreeSwitch.center = CGPointMake(self.agreeSwitch.frame.origin.x, CGRectGetMidY(self.agreeLabel.frame));
                self.visualizeButton.frame = CGRectMake(20, CGRectGetMaxY(self.agreeLabel.frame) + 10, CGRectGetWidth(self.view.frame) - 40, 44);
                [self.scrollView addSubview:self.imageView5];
                self.imageView6 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView6.frame = CGRectMake(90, CGRectGetMaxY(self.imageView1.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView6];
                self.imageView7 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView7.frame = CGRectMake(160, CGRectGetMaxY(self.imageView1.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView7];

                [self.imageView1 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView2 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView3 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView4 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView5 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][4] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView6 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][5] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView7 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][6] objectForKey:@"img"] objectForKey:@"url"]]];
                self.imageView8 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView8.frame = CGRectMake(230, CGRectGetMaxY(self.imageView1.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView8];
                self.imageView8.image = [UIImage imageNamed:@"add_image"];
                [images addObject:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][4] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][5] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][6] objectForKey:@"img"] objectForKey:@"url"]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][4] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][5] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][6] objectForKey:@"img"] objectForKey:@"url"]]]];
                
                UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView1.tag = 111;
                [self.imageView1 addGestureRecognizer:tapGesture1];
                UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView2.tag = 222;
                [self.imageView2 addGestureRecognizer:tapGesture2];
                UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView3.tag = 333;
                [self.imageView3 addGestureRecognizer:tapGesture3];
                UITapGestureRecognizer *tapGesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView4.tag = 444;
                [self.imageView4 addGestureRecognizer:tapGesture4];
                UITapGestureRecognizer *tapGesture5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView5.tag = 555;
                [self.imageView5 addGestureRecognizer:tapGesture5];
                UITapGestureRecognizer *tapGesture6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView6.tag = 666;
                [self.imageView6 addGestureRecognizer:tapGesture6];
                UITapGestureRecognizer *tapGesture7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView7.tag = 777;
                [self.imageView7 addGestureRecognizer:tapGesture7];
                UITapGestureRecognizer *tapGesture8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView8.tag = 888;
                [self.imageView8 addGestureRecognizer:tapGesture8];
            } else if (numberOfImages == 8) {
                self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView2.frame = CGRectMake(90, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView2];
                self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView3.frame = CGRectMake(160, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView3];
                self.imageView4 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView4.frame = CGRectMake(230, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView4];
                self.imageView5 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView5.frame = CGRectMake(20, CGRectGetMaxY(self.imageView1.frame) + 15, 60, 60);
                self.agreeLabel.frame = CGRectMake(15, CGRectGetMaxY(self.imageView5.frame) + 10, CGRectGetWidth(self.view.frame) - 60, 44);
                self.agreeSwitch.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 40, CGRectGetMinY(self.agreeLabel.frame), 80, 44);
                self.agreeSwitch.center = CGPointMake(self.agreeSwitch.frame.origin.x, CGRectGetMidY(self.agreeLabel.frame));
                self.visualizeButton.frame = CGRectMake(20, CGRectGetMaxY(self.agreeLabel.frame) + 10, CGRectGetWidth(self.view.frame) - 40, 44);
                [self.scrollView addSubview:self.imageView5];
                self.imageView6 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView6.frame = CGRectMake(90, CGRectGetMaxY(self.imageView1.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView6];
                self.imageView7 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView7.frame = CGRectMake(160, CGRectGetMaxY(self.imageView1.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView7];
                self.imageView8 = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.imageView8.frame = CGRectMake(230, CGRectGetMaxY(self.imageView1.frame) + 15, 60, 60);
                [self.scrollView addSubview:self.imageView8];

                [self.imageView1 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView2 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView3 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView4 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView5 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][4] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView6 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][5] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView7 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][6] objectForKey:@"img"] objectForKey:@"url"]]];
                [self.imageView8 hnk_setImageFromURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][7] objectForKey:@"img"] objectForKey:@"url"]]];
                [images addObject:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][4] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][5] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][6] objectForKey:@"img"] objectForKey:@"url"]];
                [images addObject:[[self.republishedAnnouncement[@"images"][7] objectForKey:@"img"] objectForKey:@"url"]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][0] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][1] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][2] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][3] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][4] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][5] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][6] objectForKey:@"img"] objectForKey:@"url"]]]];
//                [imagesData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.republishedAnnouncement[@"images"][7] objectForKey:@"img"] objectForKey:@"url"]]]];
                
                UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView1.tag = 111;
                [self.imageView1 addGestureRecognizer:tapGesture1];
                UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView2.tag = 222;
                [self.imageView2 addGestureRecognizer:tapGesture2];
                UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView3.tag = 333;
                [self.imageView3 addGestureRecognizer:tapGesture3];
                UITapGestureRecognizer *tapGesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView4.tag = 444;
                [self.imageView4 addGestureRecognizer:tapGesture4];
                UITapGestureRecognizer *tapGesture5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView5.tag = 555;
                [self.imageView5 addGestureRecognizer:tapGesture5];
                UITapGestureRecognizer *tapGesture6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView6.tag = 666;
                [self.imageView6 addGestureRecognizer:tapGesture6];
                UITapGestureRecognizer *tapGesture7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView7.tag = 777;
                [self.imageView7 addGestureRecognizer:tapGesture7];
                UITapGestureRecognizer *tapGesture8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
                self.imageView8.tag = 888;
                [self.imageView8 addGestureRecognizer:tapGesture8];
            }
        } else {
            self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
            self.imageView1.image = [UIImage imageNamed:@"add_image"];
            self.imageView1.frame = CGRectMake(20, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
            [self.scrollView addSubview:self.imageView1];
            
            self.imageView1.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
            self.imageView1.tag = 111;
            [self.imageView1 addGestureRecognizer:tapGesture1];
        }
    } else {
        self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView1.image = [UIImage imageNamed:@"add_image"];
        self.imageView1.frame = CGRectMake(20, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
        [self.scrollView addSubview:self.imageView1];

        self.imageView1.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
        self.imageView1.tag = 111;
        [self.imageView1 addGestureRecognizer:tapGesture1];
    }
    self.imageView1.userInteractionEnabled = YES;
    self.imageView2.userInteractionEnabled = YES;
    self.imageView3.userInteractionEnabled = YES;
    self.imageView4.userInteractionEnabled = YES;
    self.imageView5.userInteractionEnabled = YES;
    self.imageView6.userInteractionEnabled = YES;
    self.imageView7.userInteractionEnabled = YES;
    self.imageView8.userInteractionEnabled = YES;
}

- (void)deleteButtonTappedWithNumberOfImages:(NSInteger)numberOfImagesRemaining andTag:(NSInteger)tag {
    switch (numberOfImagesRemaining) {
        case 1:
            if (tag == 111) {
                numberOfImages--;
                [images removeObjectAtIndex:0];
                [imagesData removeObjectAtIndex:0];
                self.imageView1.image = [UIImage imageNamed:@"add_image"];
                [self.imageView2 removeFromSuperview];
                [self.imageView3 removeFromSuperview];
                
            }
            break;
        case 2:
            if (tag == 111) {
                
                numberOfImages--;
                [images replaceObjectAtIndex:0 withObject:[images objectAtIndex:1]];
                [images removeObjectAtIndex:1];
                [imagesData replaceObjectAtIndex:0 withObject:[imagesData objectAtIndex:1]];
                [imagesData removeObjectAtIndex:1];
                self.imageView1.image = [UIImage imageWithData:[imagesData objectAtIndex:0]];
                self.imageView2.image = [UIImage imageNamed:@"add_image"];
                [self.imageView3 removeFromSuperview];
            } else if (tag == 222) {
                numberOfImages--;
                [images removeObjectAtIndex:1];
                [imagesData removeObjectAtIndex:1];
                self.imageView2.image = [UIImage imageNamed:@"add_image"];
                [self.imageView3 removeFromSuperview];
            }
            break;
        case 3:
            if (tag == 111) {
                numberOfImages--;
                [images replaceObjectAtIndex:0 withObject:[images objectAtIndex:1]];
                [images replaceObjectAtIndex:1 withObject:[images objectAtIndex:2]];
                [images removeObjectAtIndex:2];
                [imagesData replaceObjectAtIndex:0 withObject:[imagesData objectAtIndex:1]];
                [imagesData replaceObjectAtIndex:1 withObject:[imagesData objectAtIndex:2]];
                [imagesData removeObjectAtIndex:2];
                self.imageView1.image = [UIImage imageWithData:[imagesData objectAtIndex:0]];
                self.imageView2.image = [UIImage imageWithData:[imagesData objectAtIndex:1]];
                self.imageView3.image = [UIImage imageNamed:@"add_image"];
                [self.imageView4 removeFromSuperview];
            } else if (tag == 222) {
                numberOfImages--;
                [images replaceObjectAtIndex:1 withObject:[images objectAtIndex:2]];
                [images removeObjectAtIndex:2];
                [imagesData replaceObjectAtIndex:1 withObject:[imagesData objectAtIndex:2]];
                [imagesData removeObjectAtIndex:2];
                self.imageView2.image = [UIImage imageWithData:[imagesData objectAtIndex:1]];
                self.imageView3.image = [UIImage imageNamed:@"add_image"];
                [self.imageView4 removeFromSuperview];
                
            } else if (tag == 333) {
                numberOfImages--;
                [images removeObjectAtIndex:2];
                [imagesData removeObjectAtIndex:2];
                self.imageView3.image = [UIImage imageNamed:@"add_image"];
                [self.imageView4 removeFromSuperview];
            }
            break;
        case 4:
            if (tag == 111) {
                numberOfImages--;
                [images replaceObjectAtIndex:0 withObject:[images objectAtIndex:1]];
                [images replaceObjectAtIndex:1 withObject:[images objectAtIndex:2]];
                [images replaceObjectAtIndex:2 withObject:[images objectAtIndex:3]];
                [images removeObjectAtIndex:3];
                [imagesData replaceObjectAtIndex:0 withObject:[imagesData objectAtIndex:1]];
                [imagesData replaceObjectAtIndex:1 withObject:[imagesData objectAtIndex:2]];
                [imagesData replaceObjectAtIndex:2 withObject:[imagesData objectAtIndex:3]];
                [imagesData removeObjectAtIndex:3];
                self.imageView1.image = [UIImage imageWithData:[imagesData objectAtIndex:0]];
                self.imageView2.image = [UIImage imageWithData:[imagesData objectAtIndex:1]];
                self.imageView3.image = [UIImage imageWithData:[imagesData objectAtIndex:2]];
                self.imageView4.image = [UIImage imageNamed:@"add_image"];
                [self.imageView5 removeFromSuperview];
                self.agreeLabel.frame = CGRectMake(15, CGRectGetMaxY(self.imageView1.frame) + 10, CGRectGetWidth(self.view.frame) - 60, 44);
                self.agreeSwitch.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 40, CGRectGetMinY(self.agreeLabel.frame), 80, 44);
                self.agreeSwitch.center = CGPointMake(self.agreeSwitch.frame.origin.x, CGRectGetMidY(self.agreeLabel.frame));
                self.visualizeButton.frame = CGRectMake(20, CGRectGetMaxY(self.agreeLabel.frame) + 10, CGRectGetWidth(self.view.frame) - 40, 44);
            } else if (tag == 222) {
                numberOfImages--;
                [images replaceObjectAtIndex:1 withObject:[images objectAtIndex:2]];
                [images replaceObjectAtIndex:2 withObject:[images objectAtIndex:3]];
                [images removeObjectAtIndex:3];
                [imagesData replaceObjectAtIndex:1 withObject:[imagesData objectAtIndex:2]];
                [imagesData replaceObjectAtIndex:2 withObject:[imagesData objectAtIndex:3]];
                [imagesData removeObjectAtIndex:3];
                self.imageView2.image = [UIImage imageWithData:[imagesData objectAtIndex:1]];
                self.imageView3.image = [UIImage imageWithData:[imagesData objectAtIndex:2]];
                self.imageView4.image = [UIImage imageNamed:@"add_image"];
                [self.imageView5 removeFromSuperview];
                self.agreeLabel.frame = CGRectMake(15, CGRectGetMaxY(self.imageView1.frame) + 10, CGRectGetWidth(self.view.frame) - 60, 44);
                self.agreeSwitch.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 40, CGRectGetMinY(self.agreeLabel.frame), 80, 44);
                self.agreeSwitch.center = CGPointMake(self.agreeSwitch.frame.origin.x, CGRectGetMidY(self.agreeLabel.frame));
                self.visualizeButton.frame = CGRectMake(20, CGRectGetMaxY(self.agreeLabel.frame) + 10, CGRectGetWidth(self.view.frame) - 40, 44);
            } else if (tag == 333) {
                numberOfImages--;
                [images replaceObjectAtIndex:2 withObject:[images objectAtIndex:3]];
                [images removeObjectAtIndex:3];
                [imagesData replaceObjectAtIndex:2 withObject:[imagesData objectAtIndex:3]];
                [imagesData removeObjectAtIndex:3];
                self.imageView3.image = [UIImage imageWithData:[imagesData objectAtIndex:2]];
                self.imageView4.image = [UIImage imageNamed:@"add_image"];
                [self.imageView5 removeFromSuperview];
                self.agreeLabel.frame = CGRectMake(15, CGRectGetMaxY(self.imageView1.frame) + 10, CGRectGetWidth(self.view.frame) - 60, 44);
                self.agreeSwitch.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 40, CGRectGetMinY(self.agreeLabel.frame), 80, 44);
                self.agreeSwitch.center = CGPointMake(self.agreeSwitch.frame.origin.x, CGRectGetMidY(self.agreeLabel.frame));
                self.visualizeButton.frame = CGRectMake(20, CGRectGetMaxY(self.agreeLabel.frame) + 10, CGRectGetWidth(self.view.frame) - 40, 44);
            } else if (tag == 444) {
                numberOfImages--;
                [images removeObjectAtIndex:3];
                [imagesData removeObjectAtIndex:3];
                self.imageView4.image = [UIImage imageNamed:@"add_image"];
                [self.imageView5 removeFromSuperview];
                self.agreeLabel.frame = CGRectMake(15, CGRectGetMaxY(self.imageView1.frame) + 10, CGRectGetWidth(self.view.frame) - 60, 44);
                self.agreeSwitch.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 40, CGRectGetMinY(self.agreeLabel.frame), 80, 44);
                self.agreeSwitch.center = CGPointMake(self.agreeSwitch.frame.origin.x, CGRectGetMidY(self.agreeLabel.frame));
                self.visualizeButton.frame = CGRectMake(20, CGRectGetMaxY(self.agreeLabel.frame) + 10, CGRectGetWidth(self.view.frame) - 40, 44);
            }
            break;
        case 5:
            if (tag == 111) {
                numberOfImages--;
                [images replaceObjectAtIndex:0 withObject:[images objectAtIndex:1]];
                [images replaceObjectAtIndex:1 withObject:[images objectAtIndex:2]];
                [images replaceObjectAtIndex:2 withObject:[images objectAtIndex:3]];
                [images replaceObjectAtIndex:3 withObject:[images objectAtIndex:4]];
                [images removeObjectAtIndex:4];
                [imagesData replaceObjectAtIndex:0 withObject:[imagesData objectAtIndex:1]];
                [imagesData replaceObjectAtIndex:1 withObject:[imagesData objectAtIndex:2]];
                [imagesData replaceObjectAtIndex:2 withObject:[imagesData objectAtIndex:3]];
                [imagesData replaceObjectAtIndex:3 withObject:[imagesData objectAtIndex:4]];
                [imagesData removeObjectAtIndex:4];
                self.imageView1.image = [UIImage imageWithData:[imagesData objectAtIndex:0]];
                self.imageView2.image = [UIImage imageWithData:[imagesData objectAtIndex:1]];
                self.imageView3.image = [UIImage imageWithData:[imagesData objectAtIndex:2]];
                self.imageView4.image = [UIImage imageWithData:[imagesData objectAtIndex:3]];
                self.imageView5.image = [UIImage imageNamed:@"add_image"];
                [self.imageView6 removeFromSuperview];
                
            } else if (tag == 222) {
                numberOfImages--;
                [images replaceObjectAtIndex:1 withObject:[images objectAtIndex:2]];
                [images replaceObjectAtIndex:2 withObject:[images objectAtIndex:3]];
                [images replaceObjectAtIndex:3 withObject:[images objectAtIndex:4]];
                [images removeObjectAtIndex:4];
                [imagesData replaceObjectAtIndex:1 withObject:[imagesData objectAtIndex:2]];
                [imagesData replaceObjectAtIndex:2 withObject:[imagesData objectAtIndex:3]];
                [imagesData replaceObjectAtIndex:3 withObject:[imagesData objectAtIndex:4]];
                [imagesData removeObjectAtIndex:4];
                self.imageView2.image = [UIImage imageWithData:[imagesData objectAtIndex:1]];
                self.imageView3.image = [UIImage imageWithData:[imagesData objectAtIndex:2]];
                self.imageView4.image = [UIImage imageWithData:[imagesData objectAtIndex:3]];
                self.imageView5.image = [UIImage imageNamed:@"add_image"];
                [self.imageView6 removeFromSuperview];
            } else if (tag == 333) {
                numberOfImages--;
                [images replaceObjectAtIndex:2 withObject:[images objectAtIndex:3]];
                [images replaceObjectAtIndex:3 withObject:[images objectAtIndex:4]];
                [images removeObjectAtIndex:4];
                [imagesData replaceObjectAtIndex:2 withObject:[imagesData objectAtIndex:3]];
                [imagesData replaceObjectAtIndex:3 withObject:[imagesData objectAtIndex:4]];
                [imagesData removeObjectAtIndex:4];
                self.imageView3.image = [UIImage imageWithData:[imagesData objectAtIndex:2]];
                self.imageView4.image = [UIImage imageWithData:[imagesData objectAtIndex:3]];
                self.imageView5.image = [UIImage imageNamed:@"add_image"];
                [self.imageView6 removeFromSuperview];
            } else if (tag == 444) {
                numberOfImages--;
                [images replaceObjectAtIndex:3 withObject:[images objectAtIndex:4]];
                [images removeObjectAtIndex:4];
                [imagesData replaceObjectAtIndex:3 withObject:[imagesData objectAtIndex:4]];
                [imagesData removeObjectAtIndex:4];
                self.imageView4.image = [UIImage imageWithData:[imagesData objectAtIndex:3]];
                self.imageView5.image = [UIImage imageNamed:@"add_image"];
                [self.imageView6 removeFromSuperview];
            } else if (tag == 555) {
                numberOfImages--;
                [images removeObjectAtIndex:4];
                [imagesData removeObjectAtIndex:4];
                self.imageView5.image = [UIImage imageNamed:@"add_image"];
                [self.imageView6 removeFromSuperview];
            }
            break;
        case 6:
            if (tag == 111) {
                numberOfImages--;
                [images replaceObjectAtIndex:0 withObject:[images objectAtIndex:1]];
                [images replaceObjectAtIndex:1 withObject:[images objectAtIndex:2]];
                [images replaceObjectAtIndex:2 withObject:[images objectAtIndex:3]];
                [images replaceObjectAtIndex:3 withObject:[images objectAtIndex:4]];
                [images replaceObjectAtIndex:4 withObject:[images objectAtIndex:5]];
                [images removeObjectAtIndex:5];
                [imagesData replaceObjectAtIndex:0 withObject:[imagesData objectAtIndex:1]];
                [imagesData replaceObjectAtIndex:1 withObject:[imagesData objectAtIndex:2]];
                [imagesData replaceObjectAtIndex:2 withObject:[imagesData objectAtIndex:3]];
                [imagesData replaceObjectAtIndex:3 withObject:[imagesData objectAtIndex:4]];
                [imagesData replaceObjectAtIndex:4 withObject:[imagesData objectAtIndex:5]];
                [imagesData removeObjectAtIndex:5];
                self.imageView1.image = [UIImage imageWithData:[imagesData objectAtIndex:0]];
                self.imageView2.image = [UIImage imageWithData:[imagesData objectAtIndex:1]];
                self.imageView3.image = [UIImage imageWithData:[imagesData objectAtIndex:2]];
                self.imageView4.image = [UIImage imageWithData:[imagesData objectAtIndex:3]];
                self.imageView5.image = [UIImage imageWithData:[imagesData objectAtIndex:4]];
                self.imageView6.image = [UIImage imageNamed:@"add_image"];
                [self.imageView7 removeFromSuperview];
            } else if (tag == 222) {
                numberOfImages--;
                [images replaceObjectAtIndex:1 withObject:[images objectAtIndex:2]];
                [images replaceObjectAtIndex:2 withObject:[images objectAtIndex:3]];
                [images replaceObjectAtIndex:3 withObject:[images objectAtIndex:4]];
                [images replaceObjectAtIndex:4 withObject:[images objectAtIndex:5]];
                [images removeObjectAtIndex:5];
                [imagesData replaceObjectAtIndex:1 withObject:[imagesData objectAtIndex:2]];
                [imagesData replaceObjectAtIndex:2 withObject:[imagesData objectAtIndex:3]];
                [imagesData replaceObjectAtIndex:3 withObject:[imagesData objectAtIndex:4]];
                [imagesData replaceObjectAtIndex:4 withObject:[imagesData objectAtIndex:5]];
                [imagesData removeObjectAtIndex:5];
                self.imageView2.image = [UIImage imageWithData:[imagesData objectAtIndex:1]];
                self.imageView3.image = [UIImage imageWithData:[imagesData objectAtIndex:2]];
                self.imageView4.image = [UIImage imageWithData:[imagesData objectAtIndex:3]];
                self.imageView5.image = [UIImage imageWithData:[imagesData objectAtIndex:4]];
                self.imageView6.image = [UIImage imageNamed:@"add_image"];
                [self.imageView7 removeFromSuperview];
            } else if (tag == 333) {
                numberOfImages--;
                [images replaceObjectAtIndex:2 withObject:[images objectAtIndex:3]];
                [images replaceObjectAtIndex:3 withObject:[images objectAtIndex:4]];
                [images replaceObjectAtIndex:4 withObject:[images objectAtIndex:5]];
                [images removeObjectAtIndex:5];
                [imagesData replaceObjectAtIndex:2 withObject:[imagesData objectAtIndex:3]];
                [imagesData replaceObjectAtIndex:3 withObject:[imagesData objectAtIndex:4]];
                [imagesData replaceObjectAtIndex:4 withObject:[imagesData objectAtIndex:5]];
                [imagesData removeObjectAtIndex:5];
                self.imageView3.image = [UIImage imageWithData:[imagesData objectAtIndex:2]];
                self.imageView4.image = [UIImage imageWithData:[imagesData objectAtIndex:3]];
                self.imageView5.image = [UIImage imageWithData:[imagesData objectAtIndex:4]];
                self.imageView6.image = [UIImage imageNamed:@"add_image"];
                [self.imageView7 removeFromSuperview];
            } else if (tag == 444) {
                numberOfImages--;
                [images replaceObjectAtIndex:3 withObject:[images objectAtIndex:4]];
                [images replaceObjectAtIndex:4 withObject:[images objectAtIndex:5]];
                [images removeObjectAtIndex:5];
                [imagesData replaceObjectAtIndex:3 withObject:[imagesData objectAtIndex:4]];
                [imagesData replaceObjectAtIndex:4 withObject:[imagesData objectAtIndex:5]];
                [imagesData removeObjectAtIndex:5];
                self.imageView4.image = [UIImage imageWithData:[imagesData objectAtIndex:3]];
                self.imageView5.image = [UIImage imageWithData:[imagesData objectAtIndex:4]];
                self.imageView6.image = [UIImage imageNamed:@"add_image"];
                [self.imageView7 removeFromSuperview];
            } else if (tag == 555) {
                numberOfImages--;
                [images replaceObjectAtIndex:4 withObject:[images objectAtIndex:5]];
                [images removeObjectAtIndex:5];
                [imagesData replaceObjectAtIndex:4 withObject:[imagesData objectAtIndex:5]];
                [imagesData removeObjectAtIndex:5];
                self.imageView5.image = [UIImage imageWithData:[imagesData objectAtIndex:4]];
                self.imageView6.image = [UIImage imageNamed:@"add_image"];
                [self.imageView7 removeFromSuperview];
            } else if (tag == 666) {
                numberOfImages--;
                [images removeObjectAtIndex:5];
                [imagesData removeObjectAtIndex:5];
                self.imageView6.image = [UIImage imageNamed:@"add_image"];
                [self.imageView7 removeFromSuperview];
            }
            break;
        case 7:
            if (tag == 111) {
                numberOfImages--;
                [images replaceObjectAtIndex:0 withObject:[images objectAtIndex:1]];
                [images replaceObjectAtIndex:1 withObject:[images objectAtIndex:2]];
                [images replaceObjectAtIndex:2 withObject:[images objectAtIndex:3]];
                [images replaceObjectAtIndex:3 withObject:[images objectAtIndex:4]];
                [images replaceObjectAtIndex:4 withObject:[images objectAtIndex:5]];
                [images replaceObjectAtIndex:5 withObject:[images objectAtIndex:6]];
                [images removeObjectAtIndex:6];
                [imagesData replaceObjectAtIndex:0 withObject:[imagesData objectAtIndex:1]];
                [imagesData replaceObjectAtIndex:1 withObject:[imagesData objectAtIndex:2]];
                [imagesData replaceObjectAtIndex:2 withObject:[imagesData objectAtIndex:3]];
                [imagesData replaceObjectAtIndex:3 withObject:[imagesData objectAtIndex:4]];
                [imagesData replaceObjectAtIndex:4 withObject:[imagesData objectAtIndex:5]];
                [imagesData replaceObjectAtIndex:5 withObject:[imagesData objectAtIndex:6]];
                [imagesData removeObjectAtIndex:6];
                self.imageView1.image = [UIImage imageWithData:[imagesData objectAtIndex:0]];
                self.imageView2.image = [UIImage imageWithData:[imagesData objectAtIndex:1]];
                self.imageView3.image = [UIImage imageWithData:[imagesData objectAtIndex:2]];
                self.imageView4.image = [UIImage imageWithData:[imagesData objectAtIndex:3]];
                self.imageView5.image = [UIImage imageWithData:[imagesData objectAtIndex:4]];
                self.imageView6.image = [UIImage imageWithData:[imagesData objectAtIndex:5]];
                self.imageView7.image = [UIImage imageNamed:@"add_image"];
                [self.imageView8 removeFromSuperview];
            } else if (tag == 222) {
                numberOfImages--;
                [images replaceObjectAtIndex:1 withObject:[images objectAtIndex:2]];
                [images replaceObjectAtIndex:2 withObject:[images objectAtIndex:3]];
                [images replaceObjectAtIndex:3 withObject:[images objectAtIndex:4]];
                [images replaceObjectAtIndex:4 withObject:[images objectAtIndex:5]];
                [images replaceObjectAtIndex:5 withObject:[images objectAtIndex:6]];
                [images removeObjectAtIndex:6];
                [imagesData replaceObjectAtIndex:1 withObject:[imagesData objectAtIndex:2]];
                [imagesData replaceObjectAtIndex:2 withObject:[imagesData objectAtIndex:3]];
                [imagesData replaceObjectAtIndex:3 withObject:[imagesData objectAtIndex:4]];
                [imagesData replaceObjectAtIndex:4 withObject:[imagesData objectAtIndex:5]];
                [imagesData replaceObjectAtIndex:5 withObject:[imagesData objectAtIndex:6]];
                [imagesData removeObjectAtIndex:6];
                self.imageView2.image = [UIImage imageWithData:[imagesData objectAtIndex:1]];
                self.imageView3.image = [UIImage imageWithData:[imagesData objectAtIndex:2]];
                self.imageView4.image = [UIImage imageWithData:[imagesData objectAtIndex:3]];
                self.imageView5.image = [UIImage imageWithData:[imagesData objectAtIndex:4]];
                self.imageView6.image = [UIImage imageWithData:[imagesData objectAtIndex:5]];
                self.imageView7.image = [UIImage imageNamed:@"add_image"];
                [self.imageView8 removeFromSuperview];
            } else if (tag == 333) {
                numberOfImages--;
                [images replaceObjectAtIndex:2 withObject:[images objectAtIndex:3]];
                [images replaceObjectAtIndex:3 withObject:[images objectAtIndex:4]];
                [images replaceObjectAtIndex:4 withObject:[images objectAtIndex:5]];
                [images replaceObjectAtIndex:5 withObject:[images objectAtIndex:6]];
                [images removeObjectAtIndex:6];
                [imagesData replaceObjectAtIndex:2 withObject:[imagesData objectAtIndex:3]];
                [imagesData replaceObjectAtIndex:3 withObject:[imagesData objectAtIndex:4]];
                [imagesData replaceObjectAtIndex:4 withObject:[imagesData objectAtIndex:5]];
                [imagesData replaceObjectAtIndex:5 withObject:[imagesData objectAtIndex:6]];
                [imagesData removeObjectAtIndex:6];
                self.imageView3.image = [UIImage imageWithData:[imagesData objectAtIndex:2]];
                self.imageView4.image = [UIImage imageWithData:[imagesData objectAtIndex:3]];
                self.imageView5.image = [UIImage imageWithData:[imagesData objectAtIndex:4]];
                self.imageView6.image = [UIImage imageWithData:[imagesData objectAtIndex:5]];
                self.imageView7.image = [UIImage imageNamed:@"add_image"];
                [self.imageView8 removeFromSuperview];
            } else if (tag == 444) {
                numberOfImages--;
                [images replaceObjectAtIndex:3 withObject:[images objectAtIndex:4]];
                [images replaceObjectAtIndex:4 withObject:[images objectAtIndex:5]];
                [images replaceObjectAtIndex:5 withObject:[images objectAtIndex:6]];
                [images removeObjectAtIndex:6];
                [imagesData replaceObjectAtIndex:3 withObject:[imagesData objectAtIndex:4]];
                [imagesData replaceObjectAtIndex:4 withObject:[imagesData objectAtIndex:5]];
                [imagesData replaceObjectAtIndex:5 withObject:[imagesData objectAtIndex:6]];
                [imagesData removeObjectAtIndex:6];
                self.imageView4.image = [UIImage imageWithData:[imagesData objectAtIndex:3]];
                self.imageView5.image = [UIImage imageWithData:[imagesData objectAtIndex:4]];
                self.imageView6.image = [UIImage imageWithData:[imagesData objectAtIndex:5]];
                self.imageView7.image = [UIImage imageNamed:@"add_image"];
                [self.imageView8 removeFromSuperview];
            } else if (tag == 555) {
                numberOfImages--;
                [images replaceObjectAtIndex:4 withObject:[images objectAtIndex:5]];
                [images replaceObjectAtIndex:5 withObject:[images objectAtIndex:6]];
                [images removeObjectAtIndex:6];
                [imagesData replaceObjectAtIndex:4 withObject:[imagesData objectAtIndex:5]];
                [imagesData replaceObjectAtIndex:5 withObject:[imagesData objectAtIndex:6]];
                [imagesData removeObjectAtIndex:6];
                self.imageView5.image = [UIImage imageWithData:[imagesData objectAtIndex:4]];
                self.imageView6.image = [UIImage imageWithData:[imagesData objectAtIndex:5]];
                self.imageView7.image = [UIImage imageNamed:@"add_image"];
                [self.imageView8 removeFromSuperview];
            } else if (tag == 666) {
                numberOfImages--;
                [images replaceObjectAtIndex:5 withObject:[images objectAtIndex:6]];
                [images removeObjectAtIndex:6];
                [imagesData replaceObjectAtIndex:5 withObject:[imagesData objectAtIndex:6]];
                [imagesData removeObjectAtIndex:6];
                self.imageView6.image = [UIImage imageWithData:[imagesData objectAtIndex:5]];
                self.imageView7.image = [UIImage imageNamed:@"add_image"];
                [self.imageView8 removeFromSuperview];
            } else if (tag == 777) {
                numberOfImages--;
                [images removeObjectAtIndex:6];
                [imagesData removeObjectAtIndex:6];
                self.imageView7.image = [UIImage imageNamed:@"add_image"];
                [self.imageView8 removeFromSuperview];
            }
            break;
        case 8:
            if (tag == 111) {
                numberOfImages--;
                [images replaceObjectAtIndex:0 withObject:[images objectAtIndex:1]];
                [images replaceObjectAtIndex:1 withObject:[images objectAtIndex:2]];
                [images replaceObjectAtIndex:2 withObject:[images objectAtIndex:3]];
                [images replaceObjectAtIndex:3 withObject:[images objectAtIndex:4]];
                [images replaceObjectAtIndex:4 withObject:[images objectAtIndex:5]];
                [images replaceObjectAtIndex:5 withObject:[images objectAtIndex:6]];
                [images replaceObjectAtIndex:6 withObject:[images objectAtIndex:7]];
                [images removeObjectAtIndex:7];
                [imagesData replaceObjectAtIndex:0 withObject:[imagesData objectAtIndex:1]];
                [imagesData replaceObjectAtIndex:1 withObject:[imagesData objectAtIndex:2]];
                [imagesData replaceObjectAtIndex:2 withObject:[imagesData objectAtIndex:3]];
                [imagesData replaceObjectAtIndex:3 withObject:[imagesData objectAtIndex:4]];
                [imagesData replaceObjectAtIndex:4 withObject:[imagesData objectAtIndex:5]];
                [imagesData replaceObjectAtIndex:5 withObject:[imagesData objectAtIndex:6]];
                [imagesData replaceObjectAtIndex:6 withObject:[imagesData objectAtIndex:7]];
                [imagesData removeObjectAtIndex:7];
                self.imageView1.image = [UIImage imageWithData:[imagesData objectAtIndex:0]];
                self.imageView2.image = [UIImage imageWithData:[imagesData objectAtIndex:1]];
                self.imageView3.image = [UIImage imageWithData:[imagesData objectAtIndex:2]];
                self.imageView4.image = [UIImage imageWithData:[imagesData objectAtIndex:3]];
                self.imageView5.image = [UIImage imageWithData:[imagesData objectAtIndex:4]];
                self.imageView6.image = [UIImage imageWithData:[imagesData objectAtIndex:5]];
                self.imageView7.image = [UIImage imageWithData:[imagesData objectAtIndex:6]];
                self.imageView8.image = [UIImage imageNamed:@"add_image"];
            } else if (tag == 222) {
                numberOfImages--;
                [images replaceObjectAtIndex:1 withObject:[images objectAtIndex:2]];
                [images replaceObjectAtIndex:2 withObject:[images objectAtIndex:3]];
                [images replaceObjectAtIndex:3 withObject:[images objectAtIndex:4]];
                [images replaceObjectAtIndex:4 withObject:[images objectAtIndex:5]];
                [images replaceObjectAtIndex:5 withObject:[images objectAtIndex:6]];
                [images replaceObjectAtIndex:6 withObject:[images objectAtIndex:7]];
                [images removeObjectAtIndex:7];
                [imagesData replaceObjectAtIndex:1 withObject:[imagesData objectAtIndex:2]];
                [imagesData replaceObjectAtIndex:2 withObject:[imagesData objectAtIndex:3]];
                [imagesData replaceObjectAtIndex:3 withObject:[imagesData objectAtIndex:4]];
                [imagesData replaceObjectAtIndex:4 withObject:[imagesData objectAtIndex:5]];
                [imagesData replaceObjectAtIndex:5 withObject:[imagesData objectAtIndex:6]];
                [imagesData replaceObjectAtIndex:6 withObject:[imagesData objectAtIndex:7]];
                [imagesData removeObjectAtIndex:7];
                self.imageView2.image = [UIImage imageWithData:[imagesData objectAtIndex:1]];
                self.imageView3.image = [UIImage imageWithData:[imagesData objectAtIndex:2]];
                self.imageView4.image = [UIImage imageWithData:[imagesData objectAtIndex:3]];
                self.imageView5.image = [UIImage imageWithData:[imagesData objectAtIndex:4]];
                self.imageView6.image = [UIImage imageWithData:[imagesData objectAtIndex:5]];
                self.imageView7.image = [UIImage imageWithData:[imagesData objectAtIndex:6]];
                self.imageView8.image = [UIImage imageNamed:@"add_image"];
            } else if (tag == 333) {
                numberOfImages--;
                [images replaceObjectAtIndex:2 withObject:[images objectAtIndex:3]];
                [images replaceObjectAtIndex:3 withObject:[images objectAtIndex:4]];
                [images replaceObjectAtIndex:4 withObject:[images objectAtIndex:5]];
                [images replaceObjectAtIndex:5 withObject:[images objectAtIndex:6]];
                [images replaceObjectAtIndex:6 withObject:[images objectAtIndex:7]];
                [images removeObjectAtIndex:7];
                [imagesData replaceObjectAtIndex:2 withObject:[imagesData objectAtIndex:3]];
                [imagesData replaceObjectAtIndex:3 withObject:[imagesData objectAtIndex:4]];
                [imagesData replaceObjectAtIndex:4 withObject:[imagesData objectAtIndex:5]];
                [imagesData replaceObjectAtIndex:5 withObject:[imagesData objectAtIndex:6]];
                [imagesData replaceObjectAtIndex:6 withObject:[imagesData objectAtIndex:7]];
                [imagesData removeObjectAtIndex:7];
                self.imageView3.image = [UIImage imageWithData:[imagesData objectAtIndex:2]];
                self.imageView4.image = [UIImage imageWithData:[imagesData objectAtIndex:3]];
                self.imageView5.image = [UIImage imageWithData:[imagesData objectAtIndex:4]];
                self.imageView6.image = [UIImage imageWithData:[imagesData objectAtIndex:5]];
                self.imageView7.image = [UIImage imageWithData:[imagesData objectAtIndex:6]];
                self.imageView8.image = [UIImage imageNamed:@"add_image"];
            } else if (tag == 444) {
                numberOfImages--;
                [images replaceObjectAtIndex:3 withObject:[images objectAtIndex:4]];
                [images replaceObjectAtIndex:4 withObject:[images objectAtIndex:5]];
                [images replaceObjectAtIndex:5 withObject:[images objectAtIndex:6]];
                [images replaceObjectAtIndex:6 withObject:[images objectAtIndex:7]];
                [images removeObjectAtIndex:7];
                [imagesData replaceObjectAtIndex:3 withObject:[imagesData objectAtIndex:4]];
                [imagesData replaceObjectAtIndex:4 withObject:[imagesData objectAtIndex:5]];
                [imagesData replaceObjectAtIndex:5 withObject:[imagesData objectAtIndex:6]];
                [imagesData replaceObjectAtIndex:6 withObject:[imagesData objectAtIndex:7]];
                [imagesData removeObjectAtIndex:7];
                self.imageView4.image = [UIImage imageWithData:[imagesData objectAtIndex:3]];
                self.imageView5.image = [UIImage imageWithData:[imagesData objectAtIndex:4]];
                self.imageView6.image = [UIImage imageWithData:[imagesData objectAtIndex:5]];
                self.imageView7.image = [UIImage imageWithData:[imagesData objectAtIndex:6]];
                self.imageView8.image = [UIImage imageNamed:@"add_image"];
            } else if (tag == 555) {
                numberOfImages--;
                [images replaceObjectAtIndex:4 withObject:[images objectAtIndex:5]];
                [images replaceObjectAtIndex:5 withObject:[images objectAtIndex:6]];
                [images replaceObjectAtIndex:6 withObject:[images objectAtIndex:7]];
                [images removeObjectAtIndex:7];
                [imagesData replaceObjectAtIndex:4 withObject:[imagesData objectAtIndex:5]];
                [imagesData replaceObjectAtIndex:5 withObject:[imagesData objectAtIndex:6]];
                [imagesData replaceObjectAtIndex:6 withObject:[imagesData objectAtIndex:7]];
                [imagesData removeObjectAtIndex:7];
                self.imageView5.image = [UIImage imageWithData:[imagesData objectAtIndex:4]];
                self.imageView6.image = [UIImage imageWithData:[imagesData objectAtIndex:5]];
                self.imageView7.image = [UIImage imageWithData:[imagesData objectAtIndex:6]];
                self.imageView8.image = [UIImage imageNamed:@"add_image"];
            } else if (tag == 666) {
                numberOfImages--;
                [images replaceObjectAtIndex:5 withObject:[images objectAtIndex:6]];
                [images replaceObjectAtIndex:6 withObject:[images objectAtIndex:7]];
                [images removeObjectAtIndex:7];
                [imagesData replaceObjectAtIndex:5 withObject:[imagesData objectAtIndex:6]];
                [imagesData replaceObjectAtIndex:6 withObject:[imagesData objectAtIndex:7]];
                [imagesData removeObjectAtIndex:7];
                self.imageView6.image = [UIImage imageWithData:[imagesData objectAtIndex:5]];
                self.imageView7.image = [UIImage imageWithData:[imagesData objectAtIndex:6]];
                self.imageView8.image = [UIImage imageNamed:@"add_image"];
            } else if (tag == 777) {
                numberOfImages--;
                [images replaceObjectAtIndex:6 withObject:[images objectAtIndex:7]];
                [images removeObjectAtIndex:7];
                [imagesData replaceObjectAtIndex:6 withObject:[imagesData objectAtIndex:7]];
                [imagesData removeObjectAtIndex:7];
                self.imageView7.image = [UIImage imageWithData:[imagesData objectAtIndex:6]];
                self.imageView8.image = [UIImage imageNamed:@"add_image"];
            } else if (tag == 888) {
                numberOfImages--;
                [images removeObjectAtIndex:7];
                [imagesData removeObjectAtIndex:7];
                self.imageView8.image = [UIImage imageNamed:@"add_image"];
            }
            break;
        default:
            break;
    }
}

- (void)userImageViewTapped:(UIGestureRecognizer *)tapGesture {
    [self.view endEditing:YES];
    
    switch (numberOfImages) {
        case 0:
            if (!photoManager) {
                photoManager = [[PhotoManager alloc] init];
                photoManager.delegate = self;
            }
            [photoManager takePictureWithPresentationController:self];
            self.tabBarController.hidesBottomBarWhenPushed = YES;
            self.tabBarController.tabBar.hidden = YES;
            break;
        case 1:
            if (tapGesture.view.tag == 111) {
                NSLog(@"DELETE IMAGE");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:0];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
            } else {
                if (!photoManager) {
                    photoManager = [[PhotoManager alloc] init];
                    photoManager.delegate = self;
                }
                [photoManager takePictureWithPresentationController:self];
                self.tabBarController.hidesBottomBarWhenPushed = YES;
                self.tabBarController.tabBar.hidden = YES;
            }
            break;
        case 2:
            if (tapGesture.view.tag == 111) {
                NSLog(@"DELETE FIRST");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:0];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
            } else if (tapGesture.view.tag == 222) {
                NSLog(@"DELETE SECOND");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:1];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else {
                if (!photoManager) {
                    photoManager = [[PhotoManager alloc] init];
                    photoManager.delegate = self;
                }
                [photoManager takePictureWithPresentationController:self];
                self.tabBarController.hidesBottomBarWhenPushed = YES;
                self.tabBarController.tabBar.hidden = YES;
            }
            break;
        case 3:
            if (tapGesture.view.tag == 111) {
                NSLog(@"DELETE FIRST");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:0];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else if (tapGesture.view.tag == 222) {
                NSLog(@"DELETE SECOND");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:1];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else if (tapGesture.view.tag == 333) {
                NSLog(@"DELETE THIRD");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:2];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else {
                if (!photoManager) {
                    photoManager = [[PhotoManager alloc] init];
                    photoManager.delegate = self;
                }
                [photoManager takePictureWithPresentationController:self];
                self.tabBarController.hidesBottomBarWhenPushed = YES;
                self.tabBarController.tabBar.hidden = YES;
            }
            break;
        case 4:
            if (tapGesture.view.tag == 111) {
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:0];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else if (tapGesture.view.tag == 222) {
                NSLog(@"DELETE SECOND");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:1];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else if (tapGesture.view.tag == 333) {
                NSLog(@"DELETE THIRD");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:2];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else if (tapGesture.view.tag == 444) {
                NSLog(@"DELETE FOURTH");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:3];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else {
                if (!photoManager) {
                    photoManager = [[PhotoManager alloc] init];
                    photoManager.delegate = self;
                }
                [photoManager takePictureWithPresentationController:self];
                self.tabBarController.hidesBottomBarWhenPushed = YES;
                self.tabBarController.tabBar.hidden = YES;
            }
            

            break;
        case 5:
            if (tapGesture.view.tag == 111) {
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:0];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
            } else if (tapGesture.view.tag == 222) {
            NSLog(@"DELETE SECOND");
            PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
            pictureViewController.imageData = [imagesData objectAtIndex:1];
            pictureViewController.numberOfImages = numberOfImages;
            pictureViewController.tag = tapGesture.view.tag;
            pictureViewController.delegate = self;
            [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
            
        } else if (tapGesture.view.tag == 333) {
            NSLog(@"DELETE THIRD");
            PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
            pictureViewController.imageData = [imagesData objectAtIndex:2];
            pictureViewController.numberOfImages = numberOfImages;
            pictureViewController.tag = tapGesture.view.tag;
            pictureViewController.delegate = self;
            [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
           
        } else if (tapGesture.view.tag == 444) {
            NSLog(@"DELETE FOURTH");
            PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
            pictureViewController.imageData = [imagesData objectAtIndex:3];
            pictureViewController.numberOfImages = numberOfImages;
            pictureViewController.tag = tapGesture.view.tag;
            pictureViewController.delegate = self;
            [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
            
        } else if (tapGesture.view.tag == 555) {
            NSLog(@"DELETE FIFTH");
            PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
            pictureViewController.imageData = [imagesData objectAtIndex:4];
            pictureViewController.numberOfImages = numberOfImages;
            pictureViewController.tag = tapGesture.view.tag;
            pictureViewController.delegate = self;
            [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
            
        } else {
            if (!photoManager) {
                photoManager = [[PhotoManager alloc] init];
                photoManager.delegate = self;
            }
            [photoManager takePictureWithPresentationController:self];
            self.tabBarController.hidesBottomBarWhenPushed = YES;
            self.tabBarController.tabBar.hidden = YES;
        }
            break;
        case 6:
            if (tapGesture.view.tag == 111) {
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:0];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else if (tapGesture.view.tag == 222) {
                NSLog(@"DELETE SECOND");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:1];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else if (tapGesture.view.tag == 333) {
                NSLog(@"DELETE THIRD");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:2];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else if (tapGesture.view.tag == 444) {
                NSLog(@"DELETE FOURTH");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:3];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else if (tapGesture.view.tag == 555) {
                NSLog(@"DELETE FIFTH");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:4];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else if (tapGesture.view.tag == 666) {
                NSLog(@"DELETE SIXTH");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:5];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else {
                if (!photoManager) {
                    photoManager = [[PhotoManager alloc] init];
                    photoManager.delegate = self;
                }
                [photoManager takePictureWithPresentationController:self];
                self.tabBarController.hidesBottomBarWhenPushed = YES;
                self.tabBarController.tabBar.hidden = YES;
            }
            break;
        case 7:
            if (tapGesture.view.tag == 111) {
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:0];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else if (tapGesture.view.tag == 222) {
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:1];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                NSLog(@"DELETE SECOND");
                
            } else if (tapGesture.view.tag == 333) {
                NSLog(@"DELETE THIRD");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:2];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else if (tapGesture.view.tag == 444) {
                NSLog(@"DELETE FOURTH");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:3];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else if (tapGesture.view.tag == 555) {
                NSLog(@"DELETE FIFTH");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:4];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else if (tapGesture.view.tag == 666) {
                NSLog(@"DELETE SIXTH");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:5];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else if (tapGesture.view.tag == 777) {
                NSLog(@"DELETE SEVENTH");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:6];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else {
                if (!photoManager) {
                    photoManager = [[PhotoManager alloc] init];
                    photoManager.delegate = self;
                }
                [photoManager takePictureWithPresentationController:self];
                self.tabBarController.hidesBottomBarWhenPushed = YES;
                self.tabBarController.tabBar.hidden = YES;
            }
            break;
        case 8:
            if (tapGesture.view.tag == 111) {
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:0];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
//                [self.imageView9 removeFromSuperview];
            } else if (tapGesture.view.tag == 222) {
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:1];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                NSLog(@"DELETE SECOND");
                
//                [self.imageView8 removeFromSuperview];
            } else if (tapGesture.view.tag == 333) {
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:2];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                NSLog(@"DELETE THIRD");
                
//                [self.imageView8 removeFromSuperview];
            } else if (tapGesture.view.tag == 444) {
                NSLog(@"DELETE FOURTH");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:3];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
//                [self.imageView8 removeFromSuperview];
            } else if (tapGesture.view.tag == 555) {
                NSLog(@"DELETE FIFTH");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:4];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
//                [self.imageView8 removeFromSuperview];
            } else if (tapGesture.view.tag == 666) {
                NSLog(@"DELETE SIXTH");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:5];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
//                [self.imageView8 removeFromSuperview];
            } else if (tapGesture.view.tag == 777) {
                NSLog(@"DELETE SEVENTH");
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:6];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
//                [self.imageView8 removeFromSuperview];
            } else if (tapGesture.view.tag == 888) {
                PictureViewController *pictureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureViewControllerIdentifier"];
                pictureViewController.imageData = [imagesData objectAtIndex:7];
                pictureViewController.numberOfImages = numberOfImages;
                pictureViewController.tag = tapGesture.view.tag;
                pictureViewController.delegate = self;
                [self.navigationController presentViewController:pictureViewController animated:YES completion:nil];
                
            } else {
                if (!photoManager) {
                    photoManager = [[PhotoManager alloc] init];
                    photoManager.delegate = self;
                }
                [photoManager takePictureWithPresentationController:self];
                self.tabBarController.hidesBottomBarWhenPushed = YES;
                self.tabBarController.tabBar.hidden = YES;
            }

            break;
        default:
            break;
    }
    
}



- (void)photoManager:(PhotoManager *)photoManager didFailWithError:(NSError *)error {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)photoManagerDidCancelSelection:(PhotoManager *)photoManager {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)uploadFileFromLocation:(NSString *)fileLocation {
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                         NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *imagesPath = @"";
    NSString *fileName = @"";
    NSString *mimeType = @"";
//    NSString *extension = @"";
//    imagesPath = @"";
    fileName = @"";
    mimeType = @"";
//    extension = @"";
//    NSString *imageLocation = [documentsDirectory
//                               stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@%@",imagesPath,fileLocation,extension]];
//    if ([fileManager fileExistsAtPath:imageLocation]) {
//        imageData = [NSData dataWithContentsOfFile:imageLocation];
    imageData = [[NSData alloc] initWithBase64EncodedString:fileLocation options:NSDataBase64DecodingIgnoreUnknownCharacters];
//        NSString *finalImagePath = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
//        NSString *strImageData = [finalImagePath stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];

        //        imageData = fileData;
        [self showHudWithText:@"Se salvează imaginea"];
        //        NSURL *url = [NSURL URLWithString:@"http://api.brmbnavigator.com"];
        NSURL *url = [NSURL URLWithString:WebServiceUrlPhoto];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSString *path = [NSString stringWithFormat:@"upload_one_image"];
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"id_user"],@"user_id",fileLocation,@"image", nil];
        
        
        NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData name:@"Image1" fileName:fileName mimeType:mimeType];
        }];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long  long totalBytesWritten, long long totalBytesExpectedToWrite) {
        }];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self uploadedFinished:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self uploadFinishedWithError:error];
        }];
        [operation start];
//    } else {
//        [self uploadFinishedWithError:nil];
//    }
    
}


- (void)uploadedFinished:(id)response {
    NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSError *jsonError;
    NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    if (numberOfImages == 0) {
        [self.imageView1 setImage:[UIImage imageWithData:imageData]];
        if (!imagesData) {
            imagesData = [[NSMutableArray alloc] init];
        }
        [imagesData addObject:imageData];
        if (!images) {
            images = [[NSMutableArray alloc] init];
        }
        [images addObject:[json[@"img_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        numberOfImages++;
        self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView2.image = [UIImage imageNamed:@"add_image"];
        self.imageView2.frame = CGRectMake(90, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
        [self.scrollView addSubview:self.imageView2];
        self.imageView2.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
        self.imageView2.tag = 222;
        [self.imageView2 addGestureRecognizer:tapGesture1];
        
    } else if (numberOfImages == 1) {
        [self.imageView2 setImage:[UIImage imageWithData:imageData]];
        if (!imagesData) {
            imagesData = [[NSMutableArray alloc] init];
        }
        [imagesData addObject:imageData];
        if (!images) {
            images = [[NSMutableArray alloc] init];
        }
        [images addObject:[json[@"img_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        numberOfImages++;
        //        self.imageView2.userInteractionEnabled = NO;
        self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView3.image = [UIImage imageNamed:@"add_image"];
        
        
        self.imageView3.frame = CGRectMake(160, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
        [self.scrollView addSubview:self.imageView3];
        self.imageView3.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
        self.imageView3.tag = 333;
        [self.imageView3 addGestureRecognizer:tapGesture1];
        
    } else if (numberOfImages == 2) {
        //        [self.imageView3 setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:json[@"img_url"]]]]];
        self.imageView4 = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView4.image = [UIImage imageNamed:@"add_image"];
        
        
        self.imageView4.frame = CGRectMake(230, CGRectGetMaxY(self.locationButton.frame) + 15, 60, 60);
        [self.scrollView addSubview:self.imageView4];
        self.imageView4.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
        self.imageView4.tag = 444;
        [self.imageView4 addGestureRecognizer:tapGesture1];
        [self.imageView3 setImage:[UIImage imageWithData:imageData]];
        if (!imagesData) {
            imagesData = [[NSMutableArray alloc] init];
        }
        [imagesData addObject:imageData];
        if (!images) {
            images = [[NSMutableArray alloc] init];
        }
        [images addObject:[json[@"img_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        numberOfImages++;
        //        self.imageView3.userInteractionEnabled = NO;
    } else if (numberOfImages == 3) {
        self.imageView5 = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView5.image = [UIImage imageNamed:@"add_image"];
        
        
        self.imageView5.frame = CGRectMake(20, CGRectGetMaxY(self.imageView1.frame) + 15, 60, 60);
        self.agreeLabel.frame = CGRectMake(15, CGRectGetMaxY(self.imageView5.frame) + 10, CGRectGetWidth(self.view.frame) - 60, 44);
        self.agreeSwitch.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 40, CGRectGetMinY(self.agreeLabel.frame), 80, 44);
        self.agreeSwitch.center = CGPointMake(self.agreeSwitch.frame.origin.x, CGRectGetMidY(self.agreeLabel.frame));
        self.visualizeButton.frame = CGRectMake(20, CGRectGetMaxY(self.agreeLabel.frame) + 10, CGRectGetWidth(self.view.frame) - 40, 44);

        [self.scrollView addSubview:self.imageView5];
        self.imageView5.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
        self.imageView5.tag = 555;
        [self.imageView5 addGestureRecognizer:tapGesture1];
        [self.imageView4 setImage:[UIImage imageWithData:imageData]];
        if (!imagesData) {
            imagesData = [[NSMutableArray alloc] init];
        }
        [imagesData addObject:imageData];
        if (!images) {
            images = [[NSMutableArray alloc] init];
        }
        [images addObject:[json[@"img_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        numberOfImages++;
    } else if (numberOfImages == 4) {
        self.imageView6 = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView6.image = [UIImage imageNamed:@"add_image"];
        
        
        self.imageView6.frame = CGRectMake(90, CGRectGetMaxY(self.imageView1.frame) + 15, 60, 60);
        [self.scrollView addSubview:self.imageView6];
        self.imageView6.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
        self.imageView6.tag = 666;
        [self.imageView6 addGestureRecognizer:tapGesture1];
        [self.imageView5 setImage:[UIImage imageWithData:imageData]];
        if (!imagesData) {
            imagesData = [[NSMutableArray alloc] init];
        }
        [imagesData addObject:imageData];
        if (!images) {
            images = [[NSMutableArray alloc] init];
        }
        [images addObject:[json[@"img_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        numberOfImages++;
    } else if (numberOfImages == 5) {
        self.imageView7 = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView7.image = [UIImage imageNamed:@"add_image"];
        
        
        self.imageView7.frame = CGRectMake(160, CGRectGetMaxY(self.imageView1.frame) + 15, 60, 60);
        [self.scrollView addSubview:self.imageView7];
        self.imageView7.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
        self.imageView7.tag = 777;
        [self.imageView7 addGestureRecognizer:tapGesture1];
        [self.imageView6 setImage:[UIImage imageWithData:imageData]];
        if (!imagesData) {
            imagesData = [[NSMutableArray alloc] init];
        }
        [imagesData addObject:imageData];
        if (!images) {
            images = [[NSMutableArray alloc] init];
        }
        [images addObject:[json[@"img_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        numberOfImages++;
    } else if (numberOfImages == 6) {
        self.imageView8 = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView8.image = [UIImage imageNamed:@"add_image"];
        
        
        self.imageView8.frame = CGRectMake(230, CGRectGetMaxY(self.imageView1.frame) + 15, 60, 60);
        [self.scrollView addSubview:self.imageView8];
        self.imageView8.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTapped:)];
        self.imageView8.tag = 888;
        [self.imageView8 addGestureRecognizer:tapGesture1];
        [self.imageView7 setImage:[UIImage imageWithData:imageData]];
        if (!imagesData) {
            imagesData = [[NSMutableArray alloc] init];
        }
        [imagesData addObject:imageData];
        if (!images) {
            images = [[NSMutableArray alloc] init];
        }
        [images addObject:[json[@"img_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        numberOfImages++;
    } else if (numberOfImages == 7) {
        [self.imageView8 setImage:[UIImage imageWithData:imageData]];
        if (!imagesData) {
            imagesData = [[NSMutableArray alloc] init];
        }
        [imagesData addObject:imageData];
        if (!images) {
            images = [[NSMutableArray alloc] init];
        }
        [images addObject:[json[@"img_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        numberOfImages++;
    }
}

- (void)uploadFinishedWithError:(NSError *)error {
    
}

- (void)showHudWithText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:(UIView*)[UIApplication sharedApplication].windows.firstObject animated:YES];
    hud.labelText = text;
}
- (void)removeHud {
    [MBProgressHUD hideHUDForView:(UIView*)[UIApplication sharedApplication].windows.firstObject animated:YES];
}

- (void)photoManager:(PhotoManager *)photoManager didFinishSelectingPhotoWithInfo:(NSDictionary *)photoInfo {
    self.tabBarController.tabBar.hidden = NO;
    [self uploadFileFromLocation:[[WebServiceManager sharedInstance] fileLocation]];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (numberOfImages >= 4) {
        self.bottomConstraint.constant = 550;
    } else {
        self.bottomConstraint.constant = 400;
    }    [self.view layoutIfNeeded];
    //    [self.descriptionTextView addTopBorderWithHeight:1 andColor:[UIColor clearColor]];
    //    [self.descriptionTextView addLeftBorderWithWidth:1 andColor:[UIColor clearColor]];
    //    [self.descriptionTextView addRightBorderWithWidth:1 andColor:[UIColor clearColor]];
    //    [self.descriptionTextView addBottomBorderWithHeight:1 andColor:[UIColor clearColor]];
    if ([textView.text isEqualToString:@"Descriere"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.bottomConstraint.constant = 300;
    [self.view layoutIfNeeded];
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Descriere";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //    if([text isEqualToString:@"\n"]) {
    ////        [textView resignFirstResponder];
    ////        [self.phoneTextField becomeFirstResponder];
    //        return NO;
    //    }
    
    return YES;
}

- (void)visualizeButtonTapped:(id)sender {
    UIColor *color = [UIColor hx_colorWithHexString:@"BFBFBF"];
    [self.agreeLabel addTopBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
    [self.agreeLabel addLeftBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
    [self.agreeLabel addRightBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
    [self.agreeLabel addBottomBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
    
    //    [self.descriptionTextView addTopBorderWithHeight:0.5 andColor:color];
    //    [self.descriptionTextView addLeftBorderWithWidth:0.5 andColor:color];
    //    [self.descriptionTextView addRightBorderWithWidth:0.5 andColor:color];
    //    [self.descriptionTextView addBottomBorderWithHeight:0.5 andColor:color];
    
    [self.categoryButton addTopBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
    [self.categoryButton addLeftBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
    [self.categoryButton addRightBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
    [self.categoryButton addBottomBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
    
    [self.locationButton addTopBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
    [self.locationButton addLeftBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
    [self.locationButton addRightBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
    [self.locationButton addBottomBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
    
    [self.titleTextField addTopBorderWithHeight:0.5 andColor:color];
    [self.titleTextField addLeftBorderWithWidth:0.5 andColor:color];
    [self.titleTextField addRightBorderWithWidth:0.5 andColor:color];
    [self.titleTextField addBottomBorderWithHeight:0.5 andColor:color];
    
    [self.phoneTextField addTopBorderWithHeight:0.5 andColor:color];
    [self.phoneTextField addLeftBorderWithWidth:0.5 andColor:color];
    [self.phoneTextField addRightBorderWithWidth:0.5 andColor:color];
    [self.phoneTextField addBottomBorderWithHeight:0.5 andColor:color];
    if ([self.titleTextField.text length]) {
        
        [self.titleTextField addTopBorderWithHeight:0.5 andColor:color];
        [self.titleTextField addLeftBorderWithWidth:0.5 andColor:color];
        [self.titleTextField addRightBorderWithWidth:0.5 andColor:color];
        [self.titleTextField addBottomBorderWithHeight:0.5 andColor:color];
        if ([self.descriptionTextView.text length] && ![self.descriptionTextView.text isEqualToString:@"Descriere"]) {
            
            //            [self.descriptionTextView addTopBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
            //            [self.descriptionTextView addLeftBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
            //            [self.descriptionTextView addRightBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
            //            [self.descriptionTextView addBottomBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
            if ([self.descriptionTextView.text length] >= 80) {
                
                //                [self.descriptionTextView addTopBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
                //                [self.descriptionTextView addLeftBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
                //                [self.descriptionTextView addRightBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
                //                [self.descriptionTextView addBottomBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
                if (selectedLocation) {
                    
                    [self.locationButton addTopBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
                    [self.locationButton addLeftBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
                    [self.locationButton addRightBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
                    [self.locationButton addBottomBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
                    if (selectedCategory) {
                        
                        [self.categoryButton addTopBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
                        [self.categoryButton addLeftBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
                        [self.categoryButton addRightBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
                        [self.categoryButton addBottomBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
                        if (self.agreeSwitch.isOn) {
                            [self.agreeLabel addTopBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
                            [self.agreeLabel addLeftBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
                            [self.agreeLabel addRightBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
                            [self.agreeLabel addBottomBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
                            //                        NSString *currentDateString = self.adDetails[@"timp"];
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
                            NSDate *currentDate = [NSDate date];
                            
                            NSLog(@"CurrentDate:%@", currentDate);
                            [dateFormatter setDateFormat:@"dd MMM yyyy', 'hh:mm"];
                            NSString *dateString = [dateFormatter stringFromDate:currentDate];
                            NSDictionary *user = [NSDictionary dictionaryWithObjectsAndKeys:[NSNull null],@"avatar", @"",@"data_inreg",[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]:[[NSUserDefaults standardUserDefaults] objectForKey:@"facebookEmail"],@"email",@"",@"id_user", @"Seby Feier", @"nume", self.phoneTextField.text,@"telefon", [NSNull null],@"ultima_logare", nil];
                            NSDictionary *adDetails = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"afisari", selectedLocation[@"titlu"],@"city",self.descriptionTextView.text,@"descriere",@"123123",@"id_anunt",self.phoneTextField.text,@"telefon1", images?images:[NSArray array],@"images", dateString,@"timp", self.titleTextField.text,@"titlu", user,@"user" , nil];
                            AdsDetailsViewController *adsDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdsDetailsViewControllerIdentifier"];
                            adsDetailsViewController.adDetails = adDetails;
//                            if (self.republishedAnnouncement) {
                                adsDetailsViewController.republishedAnnouncement = self.republishedAnnouncement;
//                            } else {
//                                adsDetailsViewController.shouldDeleteAd = NO;
//                            }
                            NSDictionary *announcementInfo = [NSDictionary dictionaryWithObjectsAndKeys:selectedCategory[@"id_categ"]?selectedCategory[@"id_categ"]:@"",@"id_categ",selectedLocation[@"id"],@"id_locatie",[[NSUserDefaults standardUserDefaults] objectForKey:@"id_user" ],@"id_user", self.announcementType[@"id"],@"setari_anunturi_id",self.phoneTextField.text,@"telefon",self.titleTextField.text,@"titlu",self.descriptionTextView.text,@"descriere", nil];
                            adsDetailsViewController.toPublish = YES;
                            adsDetailsViewController.announcementInfo = announcementInfo;
                            adsDetailsViewController.announcementType = self.announcementType;
                            //                        adsDetailsViewController.paypalPayment = self.paypalPayment;
                            [self.navigationController pushViewController:adsDetailsViewController animated:YES];
                        } else {
                            //                       [[[UIAlertView alloc] initWithTitle:@"Eroare" message:@"Trebuie sa fiți de acord cu termenii si condițiile" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                            [self.agreeLabel addTopBorderWithHeight:0.5 andColor:[UIColor redColor]];
                            [self.agreeLabel addLeftBorderWithWidth:0.5 andColor:[UIColor redColor]];
                            [self.agreeLabel addRightBorderWithWidth:0.5 andColor:[UIColor redColor]];
                            [self.agreeLabel addBottomBorderWithHeight:0.5 andColor:[UIColor redColor]];
                            
                        }
                    } else {
                        //                    [[[UIAlertView alloc] initWithTitle:@"Eroare" message:@"Vă rugăm completați toate câmpurile" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                        
                        [self.categoryButton addTopBorderWithHeight:0.5 andColor:[UIColor redColor]];
                        [self.categoryButton addLeftBorderWithWidth:0.5 andColor:[UIColor redColor]];
                        [self.categoryButton addRightBorderWithWidth:0.5 andColor:[UIColor redColor]];
                        [self.categoryButton addBottomBorderWithHeight:0.5 andColor:[UIColor redColor]];
                    }
                } else {
                    //                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:@"Vă rugăm completați toate câmpurile" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    
                    [self.locationButton addTopBorderWithHeight:0.5 andColor:[UIColor redColor]];
                    [self.locationButton addLeftBorderWithWidth:0.5 andColor:[UIColor redColor]];
                    [self.locationButton addRightBorderWithWidth:0.5 andColor:[UIColor redColor]];
                    [self.locationButton addBottomBorderWithHeight:0.5 andColor:[UIColor redColor]];
                }
            } else {
                //                [self.descriptionTextView addTopBorderWithHeight:0.5 andColor:[UIColor redColor]];
                //                [self.descriptionTextView addLeftBorderWithWidth:0.5 andColor:[UIColor redColor]];
                //                [self.descriptionTextView addRightBorderWithWidth:0.5 andColor:[UIColor redColor]];
                //                [self.descriptionTextView addBottomBorderWithHeight:0.5 andColor:[UIColor redColor]];
                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:@"Descrierea trebuie sa contina minim 80 de caractere" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:@"Descrierea trebuie sa contina minim 80 de caractere" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            //            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:@"Descrierea trebuie sa contina minim 80 de caractere" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
            //            [self.descriptionTextView addTopBorderWithHeight:1 andColor:[UIColor redColor]];
            //            [self.descriptionTextView addLeftBorderWithWidth:1 andColor:[UIColor redColor]];
            //            [self.descriptionTextView addRightBorderWithWidth:1 andColor:[UIColor redColor]];
            //            [self.descriptionTextView addBottomBorderWithHeight:1 andColor:[UIColor redColor]];
        }
    } else {
        //        [[[UIAlertView alloc] initWithTitle:@"Eroare" message:@"Vă rugăm completați toate câmpurile" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
        [self.titleTextField addTopBorderWithHeight:0.5 andColor:[UIColor redColor]];
        [self.titleTextField addLeftBorderWithWidth:0.5 andColor:[UIColor redColor]];
        [self.titleTextField addRightBorderWithWidth:0.5 andColor:[UIColor redColor]];
        [self.titleTextField addBottomBorderWithHeight:0.5 andColor:[UIColor redColor]];
    }
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.titleTextField) {
        [self.descriptionTextView becomeFirstResponder];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.bottomConstraint.constant = 300;
    [self.view layoutIfNeeded];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (numberOfImages >= 4) {
        self.bottomConstraint.constant = 550;
    } else {
        self.bottomConstraint.constant = 400;
    }
    [self.view layoutIfNeeded];
    //    if (textField == self.categoryTextField) {
    //        [self createToolbar];
    //        [self createPickerView];
    //        [textField setInputView:pickerView];
    //        [textField setInputAccessoryView:doneToolbar_];
    //        [pickerView reloadAllComponents];
    //    } else if (textField == self.locationTextField) {
    //        [self createToolbar];
    //        [self createPickerView];
    //        [textField setInputView:pickerView];
    //        [textField setInputAccessoryView:doneToolbar_];
    //        [pickerView reloadAllComponents];
    //    }
}


- (void)createToolbar {
    
    if (!doneToolbar_) {
        doneToolbar_ = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, CGRectGetWidth(self.view.frame), 44)];
        [doneToolbar_ insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar_40.png"]] atIndex:0];
        [doneToolbar_ setTintColor:[UIColor blackColor]];
        UIBarButtonItem *barButtonFlexibleGap = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                          target:self
                                          action:@selector(toolBarSelectedDone:)];
        doneToolbar_.items = [NSArray arrayWithObjects:barButtonFlexibleGap,barButtonDone, nil];
    }
}

- (void)createPickerView {
    if (!pickerView) {
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200)];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        [pickerView setShowsSelectionIndicator:YES];
    }
}

- (void)toolBarSelectedDone:(id)sender {
    if (sender) {
        //        if ([self.categoryTextField isFirstResponder]) {
        //            if (selectedCategory) {
        //                self.categoryTextField.text = [selectedCategory objectForKey:@"titlu"];
        //            } else {
        //                selectedCategory = [allCategories objectAtIndex:0];
        //                self.categoryTextField.text = [[allCategories objectAtIndex:0] objectForKey:@"titlu"];
        //            }
        //        } else if ([self.locationTextField isFirstResponder]) {
        //            if (selectedLocation) {
        //                self.locationTextField.text = [selectedLocation objectForKey:@"titlu"];
        //            } else {
        //                selectedLocation = [allLocations objectAtIndex:0];
        //                self.locationTextField.text = [[allLocations objectAtIndex:0] objectForKey:@"titlu"];
        //            }
        //        }
        [self.view endEditing:YES];
    }
}

#pragma mark UIPickerViewDelegate & DataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //    if ([self.categoryTextField isFirstResponder]) {
    //        return allCategories.count;
    //    } else if ([self.locationTextField isFirstResponder]) {
    //        return allLocations.count;
    //    }
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //    if ([self.categoryTextField isFirstResponder]) {
    //        return [[allCategories objectAtIndex:row] objectForKey:@"titlu"];
    //    } else if ([self.locationTextField isFirstResponder]) {
    //        return [[allLocations objectAtIndex:row] objectForKey:@"titlu"];
    //    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //    if ([self.categoryTextField isFirstResponder]) {
    //        selectedCategory = nil;
    //        selectedCategory = [[NSDictionary alloc] initWithDictionary:[allCategories objectAtIndex:row]];
    //    } else if ([self.locationTextField isFirstResponder]) {
    //        selectedLocation = nil;
    //        selectedLocation = [[NSDictionary alloc] initWithDictionary:[allLocations objectAtIndex:row]];
    //    }
}
- (IBAction)categoryButtonTapped:(id)sender {
    [self.view endEditing:YES];
    SelectionViewController *selectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectionViewControllerIdentifier"];
    selectionViewController.allSelections = allCategories;
    selectionViewController.delegate = self;
    [self.navigationController pushViewController:selectionViewController animated:YES];
    isCategorySelected = YES;
}
- (IBAction)locationButtonTapped:(id)sender {
    [self.view endEditing:YES];
    SelectionViewController *selectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectionViewControllerIdentifier"];
    selectionViewController.allSelections = allLocations;
    selectionViewController.delegate = self;
    [self.navigationController pushViewController:selectionViewController animated:YES];
    isCategorySelected = NO;
}

- (void)selectionDidSelect:(NSDictionary *)selection {
    if (isCategorySelected) {
        selectedCategory = selection;
        [self.categoryButton setTitle:selection[@"titlu"] forState:UIControlStateNormal];
//        self.categoryButton.titleLabel.textColor = [UIColor blackColor];
        [self.categoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        selectedLocation = selection;
        [self.locationButton setTitle:selection[@"titlu"] forState:UIControlStateNormal];
        [self.locationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}


@end
