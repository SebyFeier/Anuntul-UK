//
//  PictureViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 12/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "PictureViewController.h"

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pictureImageView.image = [UIImage imageWithData:self.imageData];
}
- (IBAction)closeButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)deleteButtonTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteButtonTappedWithNumberOfImages:andTag:)]) {
        [self.delegate deleteButtonTappedWithNumberOfImages:self.numberOfImages andTag:self.tag];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
