//
//  PhotoManager.m
//  Anuntul de UK
//
//  Created by Seby Feier on 01/03/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "PhotoManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MBProgressHUD.h"
#import "UIImage+Resize.h"
#import "WebServiceManager.h"

#define kDocumentsImagesPath @"Images"

#define IS_IOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

@implementation PhotoManager {
    __weak UIViewController *_presentationViewController;
    UIImagePickerController *_pickerController;
}

- (void)takePictureWithPresentationController:(UIViewController *)controller {
    _presentationViewController = controller;
    [self showActionSheetWithTitle:@"Photo" andOption1:@"Take Photo" option2:@"Choose Photo From iPhone Library"];
}

- (void)showActionSheetWithTitle:(NSString *)title andOption1:(NSString *)option1 option2:(NSString *)option2{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil otherButtonTitles:option1, option2,nil];
    [actionSheet showInView:_presentationViewController.view];
}

#pragma mark - UIActionSheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet cancelButtonIndex] != buttonIndex) {
        [self completeActionSheetSelection:buttonIndex];
    } else {
        [_delegate photoManager:self didFailWithError:nil];
    }
}

- (void)completeActionSheetSelection:(NSInteger )buttonIndex {
    UIImagePickerControllerSourceType imageSource = -1;
    NSString *mediaTypes = (NSString *)kUTTypeImage;
    // choosing Image/Video Source
    switch (buttonIndex) {
        case 0:
            imageSource = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            imageSource = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        default:
            break;
    }
    
    //choosing Image/Video type Selection
    UIImagePickerControllerCameraCaptureMode captureMode = -1;
            captureMode = UIImagePickerControllerCameraCaptureModePhoto;
    
        [self openImagePickerWithType:captureMode fromSource:imageSource withMediaType:mediaTypes];
    
}

- (void)openImagePickerWithType:(UIImagePickerControllerCameraCaptureMode) captureMode fromSource:(UIImagePickerControllerSourceType )sourceType withMediaType:(NSString *)mediaType {
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        if (!_pickerController) {
            _pickerController = [[UIImagePickerController alloc] init];
        }
        _pickerController.sourceType = sourceType;
        _pickerController.delegate = self;
        _pickerController.editing = YES;
        _pickerController.mediaTypes = @[mediaType];
        if (IS_IOS8) {
            _pickerController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [_presentationViewController presentViewController:_pickerController animated:YES completion:nil];
        } else {
            [_presentationViewController presentViewController:_pickerController animated:NO completion:nil];
        }
        
    } else {
        [self showErrorPickingMediaSourceType];
    }
    
}

- (void)showErrorPickingMediaSourceType {
    NSString *title = @"Image";
    UIAlertView *pickerError = [[UIAlertView alloc] initWithTitle:title
                                                          message:@"This option is not available on your device."
                                                         delegate:nil
                                                cancelButtonTitle:@"Close"
                                                otherButtonTitles:nil];
    [pickerError show];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    __weak typeof(self) safeSelf = self;
    __strong NSDictionary *strongRetainedInfo = info;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [safeSelf completeActionWithInfo:strongRetainedInfo];
            picker.delegate = nil;
            _pickerController = nil;
        } );
        
    }];
}
- (void)completeActionWithInfo:(NSDictionary *)info {
            // we are performing these operations on a background thread
            // because we must perform a few operations on the image
            
//    [self performSelectorOnMainThread:@selector(showHudWithText:) withObject:@"Se salveaza imaginea" waitUntilDone:YES];
//    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
    [self performSelectorInBackground:@selector(processInfoForImagePickingWithInfo:) withObject:info];
}
- (void)showHudWithText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:(UIView*)[UIApplication sharedApplication].windows.firstObject animated:YES];
    hud.labelText = text;
}
- (void)removeHud {
    [MBProgressHUD hideHUDForView:(UIView*)[UIApplication sharedApplication].windows.firstObject animated:YES];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker.delegate = nil;
    _pickerController = nil;
    
    if ([_delegate respondsToSelector:@selector(photoManagerDidCancelSelection:)]) {
        [_delegate photoManagerDidCancelSelection:self];
    }
}

#pragma mark - Media Processing Methods

#pragma mark Photo Processing Methods
// this should be done on a background thread
- (void)processInfoForImagePickingWithInfo:(NSDictionary *)info {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if (![info objectForKey:UIImagePickerControllerOriginalImage]) {
    }
    UIImage *img          = [info objectForKey:UIImagePickerControllerOriginalImage];
//    img                   = [info valueForKey:UIImagePickerControllerEditedImage];
//    self.imageView.image  = img;
    NSData *imageData     = UIImageJPEGRepresentation(img, 0.9);
//    NSString *fileName = [self writeImageInfoToDisk:info];
    NSString *finalImagePath = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    [[WebServiceManager sharedInstance] setFileLocation:finalImagePath];
//    NSString *fileName = @"photo";
    [self performSelectorOnMainThread:@selector(imageSavingCompleteWithInfo:) withObject:finalImagePath waitUntilDone:YES];
#pragma clang diagnostic pop
}
- (void)imageSavingCompleteWithInfo:(NSString *)fileName {
    if (fileName) {
        NSDictionary *info = @{@"fileLocation": fileName};
        
//        info = [self addCoordinateInfoToItem:info];
//        [self performSelectorOnMainThread:@selector(removeHud) withObject:nil waitUntilDone:YES];
        if ([_delegate respondsToSelector:@selector(photoManager:didFinishSelectingPhotoWithInfo:)]) {
            [_delegate photoManager:self didFinishSelectingPhotoWithInfo:info];
        } }
    else if ([_delegate respondsToSelector:@selector(photoManager:didFailWithError:)]) {
        [_delegate photoManager:self didFailWithError:nil];
    }
    
//    [self removeHud];
    
}


- (NSString *)writeImageInfoToDisk:(NSDictionary *)info {
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSUInteger timeStamp = [[NSDate date] timeIntervalSince1970];
    
    if (!editedImage) {
        
        editedImage = [info objectForKeyedSubscript:UIImagePickerControllerOriginalImage];
    }
    if (!editedImage && [[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
        NSURL *imageUrl = (NSURL *)[info objectForKey:UIImagePickerControllerReferenceURL];
        editedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];//[UIImage imageWithContentsOfFile:imageUrl.absoluteString];
    }
    if (!editedImage) {
        return nil;
    }
    UIImage *fullResolutionImage = editedImage;
    
    CGFloat scaleFactor = [[UIScreen mainScreen] scale];
    scaleFactor = 1;
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGSize resizeFrame = CGSizeMake(CGRectGetWidth(screenRect) * scaleFactor, CGRectGetHeight(screenRect) * scaleFactor);
    
    editedImage = [editedImage scaleImageToSize:resizeFrame];
    NSString *path = kDocumentsImagesPath;
//    NSInteger tripId = [[BRMBSessionManager sharedInstance].tripManager.currentTrip.tripId integerValue];
    UIImage *thumbnail = [editedImage scaleImageToSize:CGSizeMake(120, 120)];//thumbnailImage:120 transparentBorder:0.2 cornerRadius:0.1 interpolationQuality:kCGInterpolationMedium];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
//    NSString *fileName = [NSString stringWithFormat:kDocumentsImagesPath,[userDefaults valueForKey:@"username"],(long)tripId];
    NSString *fileName = @"";
    fileName = [fileName stringByAppendingFormat:@"/image_%ld",(long)timeStamp];
    [self createDirectoryForPath:[self photoDocumentsPath:fileName]];
    if ([editedImage isKindOfClass:[UIImage class]] && ![[info objectForKey:@"type"] isEqualToString:@"video"]) {
        [self writeImage:thumbnail toFileLocation:[self photoThumbnailPath:fileName]];
        
        
        thumbnail = nil;
        [self writeImage:fullResolutionImage toFileLocation:[self photoPresentationImagePath]];
        //        [self writeImage:editedImage toFileLocation:[[fileName photoDocumentsPath] stringByAppendingString:@".png"]];
        return [self saveFileData:UIImageJPEGRepresentation(editedImage, 0.9)
                     withFileName:@"image" extension:@"png"
                    andFolderPath:@"" andTimeStamp:timeStamp];
    }
    return nil;
}

- (NSString *) applicationDocumentsDirectoryWithDocumentPath:(NSString *)documentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    if (documentsPath) {
        basePath = [basePath stringByAppendingFormat:@"/%@",documentsPath];
    }
    return basePath;
}

- (NSString *)saveFileData:(NSData *)data withFileName:(NSString *)fileName extension:(NSString *)extenstion andFolderPath:(NSString *)endDocumentsPath andTimeStamp:(NSInteger )timeStamp{
    NSString *fileLocation = [self applicationDocumentsDirectoryWithDocumentPath:endDocumentsPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileLocation]) {
        [self createDirectoryForPath:fileLocation]; // creates the folder of Saving Item
    }
    fileName = [fileName stringByAppendingFormat:@"_%ld",(long)timeStamp];
    
    fileName = [fileName stringByAppendingFormat:@".%@",extenstion];
    fileLocation = [fileLocation stringByAppendingFormat:@"/%@",fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL created = [fileManager createFileAtPath:fileLocation contents:data attributes:nil];
    NSLog(@"CREATED : FILE: %d",created);
    return fileName;
}


- (NSString *)photoPresentationImagePath {
    NSString *documentsPath = [self documentsPath];
    NSString *finalString = [NSString stringWithFormat:@"%@/%@_presentation.png",documentsPath,self];
    return finalString;
}


- (NSString *)photoThumbnailPath:(NSString *)filePath {
    NSString *documentsPath = [self documentsPath];
    NSString *finalString = [NSString stringWithFormat:@"%@/%@_thumb.png",documentsPath,self];
    return finalString;
}

- (void)createDirectoryForPath:(NSString *)path {
    NSArray *directories = [path componentsSeparatedByString:@"/"];
    NSString *currentPath = nil;
    for (NSString *directory in directories) {
        if (currentPath) {
            currentPath = [currentPath stringByAppendingFormat:@"/%@",directory];
        } else {
            if ([directory length]) {
                currentPath = directory;
            }
        }
        if ([currentPath length]) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSError *error = nil;
            if (![fileManager fileExistsAtPath:currentPath]) {
                BOOL created = [fileManager createDirectoryAtPath:currentPath withIntermediateDirectories:YES attributes:nil error:&error];
                NSLog(@"CREATED DIRECTORY %d %@ With error %@",created, currentPath, error);
            }
        }
    }
}

- (NSString *)photoDocumentsPath:(NSString *)newPath {
    NSString *documentsPath = [self documentsPath];
    NSString *finalLocation = [NSString stringWithFormat:@"%@/%@",documentsPath,self];
    NSMutableArray *components = [NSMutableArray arrayWithArray:[finalLocation componentsSeparatedByString:@"/"]];
    [components removeLastObject];
    NSString *path = [components componentsJoinedByString:@"/"];
    return path;
}

- (NSString *)documentsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (NSString *)writeImageToDiskAfterDownloading:(UIImage *)image {
    NSUInteger timeStamp = [[NSDate date] timeIntervalSince1970];
    
    UIImage *fullResolutionImage = image;
    
    CGFloat scaleFactor = [[UIScreen mainScreen] scale];
    scaleFactor = 1;
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGSize resizeFrame = CGSizeMake(CGRectGetWidth(screenRect) * scaleFactor, CGRectGetHeight(screenRect) * scaleFactor);
    
    image = [image scaleImageToSize:resizeFrame];
//    NSInteger tripId = [trip.tripId integerValue];
    UIImage *thumbnail = [image scaleImageToSize:CGSizeMake(120, 120)];//thumbnailImage:120 transparentBorder:0.2 cornerRadius:0.1 interpolationQuality:kCGInterpolationMedium];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *fileName = [NSString stringWithFormat:kDocumentsImagesPath,[userDefaults valueForKey:@"username"],(long)tripId];
    NSString *fileName = @"";
    fileName = [fileName stringByAppendingFormat:@"/image_%ld",(long)timeStamp];
    [self createDirectoryForPath:[self photoDocumentsPath:fileName]];
    if ([image isKindOfClass:[UIImage class]]) {
        [self writeImage:thumbnail toFileLocation:[self photoThumbnailPath:fileName]];
        
        
        thumbnail = nil;
        [self writeImage:fullResolutionImage toFileLocation:[self photoPresentationImagePath]];
        [self writeImage:image toFileLocation:[self photoDocumentsPath:fileName]];
        return [self saveFileData:UIImageJPEGRepresentation(image, 0.9)
                     withFileName:@"image" extension:@"png"
                    andFolderPath:@"" andTimeStamp:timeStamp];
    }
    return nil;
    
}

- (void)writeImage:(UIImage *)image toFileLocation:(NSString *)fileLocation {
    NSData *data = UIImageJPEGRepresentation(image, 0.9);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL created = [fileManager createFileAtPath:fileLocation contents:data attributes:nil];
    if (!created) {
        NSLog(@"WHY?");
    }
    NSLog(@"CREATED : WI: %d FILE %@",created, fileLocation);
}

//+ (PhotoMarker *)savePhotoWithInfo:(NSDictionary *)info forTrip:(UserTrip *)currentTrip {
//    User *currentUser = [self retrieveCurrentUser];
//    if (currentTrip) {
//        PhotoMarker *newPhoto = (PhotoMarker *)[NSEntityDescription insertNewObjectForEntityForName:@"PhotoMarker" inManagedObjectContext:currentUser.managedObjectContext];
//        newPhoto.fileLocation = [info objectForKey:@"fileLocation"];
//        newPhoto.markerID = @"";
//        if ([info objectForKey:@"mediaUrl"]) {
//            newPhoto.fileURL = [info objectForKey:@"mediaUrl"];
//        } else {
//            newPhoto.fileURL = @"";
//        }
//        if ([info objectForKey:@"mediaThumb"]) {
//            newPhoto.fileThumbURL = [info objectForKey:@"mediaThumb"];
//        } else {
//            newPhoto.fileThumbURL = @"";
//        }
//        if ([info objectForKey:@"mediaName"]) {
//            newPhoto.markerName = [info objectForKey:@"mediaName"];
//        }
//        if ([info objectForKey:@"mediaDesc"]) {
//            newPhoto.markerDescription = [info objectForKey:@"mediaDesc"];
//        }
//        [currentTrip addPhotoMarkersObject:newPhoto];
//        newPhoto.userTrip = currentTrip;
//        currentTrip.dateModified = [NSDate date];
//        NSInteger photos = [currentTrip.photoNumber integerValue];
//        currentTrip.photoNumber = [NSNumber numberWithInteger:++photos];
//        if ([info objectForKey:@"lat"] && [info objectForKey:@"lng"]) {
//            newPhoto.latitude = [info objectForKey:@"lat"];
//            newPhoto.longitude = [info objectForKey:@"lng"];
//        } else {
//            CLLocation *currentLocation = [[BRMBLocationManager sharedInstance] getCurrentLocation];
//            newPhoto.latitude = [NSNumber numberWithFloat:currentLocation.coordinate.latitude];
//            newPhoto.longitude = [NSNumber numberWithFloat:currentLocation.coordinate.longitude];
//        }
//        [self saveChangesInCoreData];
//        return newPhoto;
//    }
//    return nil;
//    
//    
//}




@end
