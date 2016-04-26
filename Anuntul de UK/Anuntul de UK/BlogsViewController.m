//
//  BlogsViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 30/01/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "BlogsViewController.h"
#import "BlogTableViewCell.h"
#import "MenuTableViewController.h"
#import "WebServiceManager.h"
#import "MBProgressHUD.h"
#import "BlogDetailsViewController.h"

@interface BlogsViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSInteger _pageNumber;
}
@property (weak, nonatomic) IBOutlet UITableView *blogsTableView;

@end

@implementation BlogsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNumber = 2;
    self.blogsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBlogArticles:) name:@"Get Blog Articles" object:nil];
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    [[WebServiceManager sharedInstance] getBlogArticlesWithPageNumber:[NSNumber numberWithInteger:1] WithCompletionBlock:^(NSArray *array, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!error) {
            self.listOfBlogs = [[NSMutableArray alloc] initWithArray:[[WebServiceManager sharedInstance] listOfArticles]];
            [self.blogsTableView reloadData];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
    //    self.listOfBlogs = [[NSMutableArray alloc] initWithObjects:
    //                        [NSDictionary dictionaryWithObjectsAndKeys:@"Article Name1",@"articleName",@"Author1",@"articleAuthor", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Article Name2",@"articleName",@"Author1",@"articleAuthor", nil], nil];
    self.listOfBlogs = [[NSMutableArray alloc] initWithArray:[[WebServiceManager sharedInstance] listOfArticles]];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tabBarController.navigationItem.hidesBackButton = YES;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)getBlogArticles:(NSNotification *)notification {
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    [[WebServiceManager sharedInstance] getBlogArticlesWithPageNumber:[NSNumber numberWithInteger:1] WithCompletionBlock:^(NSArray *array, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!error) {
            self.listOfBlogs = [[NSMutableArray alloc] initWithArray:[[WebServiceManager sharedInstance] listOfArticles]];
            [self.blogsTableView reloadData];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
    }];
}

- (IBAction)goToMainMenu:(id)sender {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    MenuTableViewController *menuTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewControllerIdentifier"];
    [self.navigationController pushViewController:menuTableViewController animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listOfBlogs.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    NSDictionary *article = self.listOfBlogs[indexPath.row];
    [[WebServiceManager sharedInstance] getBlogArticleDetails:article[@"id"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!error) {
            BlogDetailsViewController *blogDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BlogDetailsViewControllerIdentifier"];
            blogDetailsViewController.articleDetails = dictionary;
            [self.navigationController pushViewController:blogDetailsViewController animated:YES];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BlogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlogTableViewCellIdentifier"];
    if (!cell) {
        cell = [[BlogTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BlogTableViewCellIdentifier"];
    }
    NSDictionary *article = self.listOfBlogs[indexPath.row];
    [cell updateCellWithInfo:article];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == self.listOfBlogs.count - 3) {
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        [[WebServiceManager sharedInstance] getBlogArticlesWithPageNumber:[NSNumber numberWithInteger:_pageNumber] WithCompletionBlock:^(NSArray *array, NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            if (!error) {
                if (array && [array count]) {
                    [self.listOfBlogs addObjectsFromArray:array];
                    _pageNumber++;
                    [self.blogsTableView reloadData];
                }
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
    }
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
