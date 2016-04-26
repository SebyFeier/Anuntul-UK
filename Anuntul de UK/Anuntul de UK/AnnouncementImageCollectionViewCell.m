//
//  AnnouncementImageCollectionViewCell.m
//  Anuntul de UK
//
//  Created by Seby Feier on 31/03/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "AnnouncementImageCollectionViewCell.h"
#import "Haneke.h"

@interface AnnouncementImageCollectionViewCell() {
    
    NSIndexPath *_indexPath;
    
}
@property (nonatomic, strong) UIImageView *imageView;

@end



@implementation AnnouncementImageCollectionViewCell

- (void)setImageFromUrl:(NSString *)urlString withIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    if (!self.imageView) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.frame];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    [self.imageView hnk_setImageFromURL:url];
    [self addSubview:self.imageView];
}

@end
