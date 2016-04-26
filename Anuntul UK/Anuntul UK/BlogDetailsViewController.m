//
//  BlogDetailsViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 22/02/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "BlogDetailsViewController.h"

@interface BlogDetailsViewController()<UIWebViewDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation BlogDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRoot:) name:@"PopToRoot" object:nil];
    [self.webView loadHTMLString:self.articleDetails[@"content"] baseURL:nil];
    self.webView.scalesPageToFit = YES;

}

- (void)popToRoot:(NSNotification *)notification {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
