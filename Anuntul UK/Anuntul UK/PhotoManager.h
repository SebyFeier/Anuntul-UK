//
//  PhotoManager.h
//  Anuntul de UK
//
//  Created by Seby Feier on 01/03/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class PhotoManager;

@protocol PhotoManagerDelegate <NSObject>

- (void)photoManager:(PhotoManager *)photoManager didFinishSelectingPhotoWithInfo:(NSDictionary *)photoInfo;
- (void)photoManagerDidCancelSelection:(PhotoManager *)photoManager;
- (void)photoManager:(PhotoManager *)photoManager didFailWithError:(NSError *)error;

@end

@interface PhotoManager : NSObject<UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id <PhotoManagerDelegate> delegate;

- (void)takePictureWithPresentationController:(UIViewController *)controller;

@end
