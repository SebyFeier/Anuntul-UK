//
//  CustomSlidingViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 29/01/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "CustomSlidingViewController.h"

@interface CustomSlidingViewController ()

@end

@implementation CustomSlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)anchorTopViewToRightAnimated:(BOOL)animated {
    if ([self canContinue]) {
        [super anchorTopViewToRightAnimated:animated];
    }
}
- (void)anchorTopViewToLeftAnimated:(BOOL)animated onComplete:(void (^)())complete {
    if ([self canContinue]) {
        [super anchorTopViewToLeftAnimated:animated onComplete:complete];
    }
}
- (void)anchorTopViewToRightAnimated:(BOOL)animated onComplete:(void (^)())complete {
    if ([self canContinue]) {
        [super anchorTopViewToRightAnimated:animated onComplete:complete];
    }
}
- (void)anchorTopViewToLeftAnimated:(BOOL)animated {
    if ([self canContinue]) {
        [super anchorTopViewToLeftAnimated:animated];
    }
}
- (BOOL)canContinue {
    return YES;
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
