//
//  PhotoGalleryViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 25/02/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "PhotoGalleryViewController.h"
#import "PhotoGalleryCollectionViewCell.h"
@interface PhotoGalleryViewController()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation PhotoGalleryViewController

- (void)viewDidLayoutSubviews {
    
    self.collectionView.contentInset = UIEdgeInsetsZero;
    [self.view layoutSubviews];
    
    [self.collectionView reloadData];
}

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRoot:) name:@"PopToRoot" object:nil];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setMinimumLineSpacing:0];
    [_collectionView setPagingEnabled:YES];
    [_collectionView setCollectionViewLayout:flowLayout];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    flowLayout = nil;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)popToRoot:(NSNotification *)notification {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionView Datasource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoGalleryCollectionViewCell *cell = (PhotoGalleryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoGalleryCollectionViewCellIdentifier" forIndexPath:indexPath];
    
    if (!cell) {
        cell = (PhotoGalleryCollectionViewCell *)[[PhotoGalleryCollectionViewCell alloc] initWithFrame:self.collectionView.bounds];
    }
    NSDictionary *image = [self.imagesArray objectAtIndex:indexPath.row];
    [cell loadImageWithInfo:image isFullScreen:YES];
    [cell layoutSubviews];
    
    return cell;
}

#pragma mark - UICollectionView Datasource Methods
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size =  self.collectionView.frame.size;
//    size.width -= 10;
    return size;
}

@end
