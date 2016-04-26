//
//  PhotoGalleryCollectionViewCell.m
//  Anuntul de UK
//
//  Created by Seby Feier on 25/02/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "PhotoGalleryCollectionViewCell.h"
#import "Haneke.h"

@implementation PhotoGalleryCollectionViewCell {
    UIImageView *_imageView;
//    UIScrollView *_scrollView;
}

- (void)loadImageWithInfo:(NSDictionary *)imageInfo isFullScreen:(BOOL)isFullScreen {
    if (!_imageView ) {
        _imageView = [[UIImageView alloc] initWithFrame:self.frame];
        if (isFullScreen) {
            [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        } else {
            [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        }
        [self addSubview:_imageView];
        _imageView.frame = self.frame;
        [_imageView setBackgroundColor:[UIColor clearColor]];
        _imageView.image = nil;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            UIImage *backImage = [UIImage imageNamed:name];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                _imageView.image = backImage;
//            });
//        });
    }
//    [_imageView hnk_setImageFromURL:[NSURL URLWithString:imageInfo[@"img"]]];
    if ([imageInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *img = imageInfo[@"img"];
        [_imageView hnk_setImageFromURL:[NSURL URLWithString:img[@"url"]]];
    } else if ([imageInfo isKindOfClass:[NSString class]]) {
        [_imageView hnk_setImageFromURL:[NSURL URLWithString:(NSString *)imageInfo]];
    }
}

- (void)layoutSubviews {
    [_imageView setFrame:self.bounds];
    [super layoutSubviews];
}

@end
