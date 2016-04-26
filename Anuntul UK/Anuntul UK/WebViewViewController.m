//
//  WebViewViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 25/03/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController()<UIWebViewDelegate> {
    
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WebViewViewController

- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 15) ];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem1 = [[UIBarButtonItem alloc]
                                           initWithCustomView:backButton];
    [leftBarButtonItem1 setTintColor:[UIColor blackColor]];
    
    //set the action for button
    
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem1;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    self.webView.scalesPageToFit = YES;
}

@end
