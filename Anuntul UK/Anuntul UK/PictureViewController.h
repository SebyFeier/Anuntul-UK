//
//  PictureViewController.h
//  Anuntul de UK
//
//  Created by Seby Feier on 12/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeletePictureDelegate <NSObject>

- (void)deleteButtonTappedWithNumberOfImages:(NSInteger)numberOfImagesRemaining andTag:(NSInteger)tag;

@end

@interface PictureViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;

@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) NSInteger numberOfImages;
@property (nonatomic, assign) id<DeletePictureDelegate>delegate;

@end
