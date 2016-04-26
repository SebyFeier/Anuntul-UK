//
//  AnnouncementTableViewCell.m
//  Anuntul de UK
//
//  Created by Seby Feier on 24/02/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "AnnouncementTableViewCell.h"

@interface AnnouncementTableViewCell() {
    
}


@end

@implementation AnnouncementTableViewCell

- (void)createCellWithInfo:(NSDictionary *)announcementType {
    self.adTitle.text = announcementType[@"titlu"];
    self.adDescription.text = announcementType[@"descriere"];
//    NSError *err = nil;
//    self.adDescription.attributedText =
//    [[NSAttributedString alloc]
//     initWithData: [announcementType[@"descriere"] dataUsingEncoding:NSUTF8StringEncoding]
//     options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
//     documentAttributes: nil
//     error: &err];
//    if(err)
//        NSLog(@"Unable to parse label text: %@", err);
}

@end
