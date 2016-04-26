//
//  PhotoGalleryCollectionViewCell.h
//  Anuntul de UK
//
//  Created by Seby Feier on 25/02/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoGalleryCollectionViewCell : UICollectionViewCell

- (void)loadImageWithInfo:(NSDictionary *)imageInfo isFullScreen:(BOOL)isFullScreen;

@end
